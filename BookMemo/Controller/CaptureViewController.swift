//
//  CaptureViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/05.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

final class CaptureViewController: UIViewController {

    @IBOutlet weak var captureView: UIView!

    var books = [AcquiredBookData]()

    lazy var captureSession: AVCaptureSession = AVCaptureSession()
    lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
    lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()

    var captureInput: AVCaptureInput?
    lazy var captureOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // どの範囲を解析するか設定する
        captureOutput.rectOfInterest = CGRect(x: CaptureRange.y, y: 1-CaptureRange.x-CaptureRange.width, width: CaptureRange.height, height: CaptureRange.width)

        // 解析範囲を表すボーダービューを作成する
        let borderView = UIView(frame: CGRect(x: CaptureRange.x * self.view.bounds.width, y: CaptureRange.y * self.view.bounds.height, width: CaptureRange.width * self.view.bounds.width, height: CaptureRange.height * self.view.bounds.height))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView)

        let label = UILabel(frame: CGRect(x: CaptureRange.x * self.view.bounds.width, y: CaptureRange.y * self.view.bounds.height-50, width: CaptureRange.width * self.view.bounds.width, height: 50))
        label.text = "上段のバーコードを枠に入れてください"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = .red
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(label)

        setUpBarcodeCapture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturePreviewLayer.frame = self.captureView?.bounds ?? CGRect.zero
    }

    func setUpBarcodeCapture() {
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureInput!)
            captureSession.addOutput(captureOutput)
            captureOutput.metadataObjectTypes = captureOutput.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.captureView?.bounds ?? CGRect.zero
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureView?.layer.addSublayer(capturePreviewLayer)
            captureSession.startRunning()
        } catch let error {
            print(error)
        }
    }

    //ISBNの判定を行う
    func isISBN(isbn: String) -> Bool {
        let v = NSString(string: isbn).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        if prefix == 978 || prefix == 979 {
            return true
        } else { return false }
    }

    @IBAction func backTopPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension CaptureViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        guard metadataObjects.count > 0 else {return}
        for metadataObject in metadataObjects {
            guard capturePreviewLayer.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject,
                let object = metadataObject as? AVMetadataMachineReadableCodeObject,
                let value = object.stringValue else {continue}
            guard isISBN(isbn: value) else {return}

            print("ISBN：\t \(value)")
            captureSession.stopRunning()
            
            startIndicator()
            
            let urlManager = UrlManager(keywordType: .isbn, keyword: value)
            let url = urlManager.getURL()
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {[weak self](response) in
                guard let _ = self else {return}
                
                let failAlertManager = AlertManager(alertType: .scanFailed)
                failAlertManager.delegate = self
                
                switch response.result {
                case .success:
                    let json: JSON = JSON(response.data as Any)
                    print(json)
                    
                    if let error = json["error"].string {
                        let errorDescriprtion = json["error_description"].string ?? ""
                        let failAlertController = failAlertManager.showAlert(title: error, message: errorDescriprtion)
                        self?.present(failAlertController, animated: true)
                        return
                    }
                    
                    let resultCount = json["count"].int
                    guard resultCount != 0 else {
                        print("本が見つかりませんでした（0 hit）")
                        
                        let failAlertController = failAlertManager.showAlert()
                        self?.present(failAlertController, animated: true)
                        return
                    }
                    let items = json["Items"]

                    for (i, _) in items.enumerated() {
                        var bookData: AcquiredBookData = AcquiredBookData()
                        bookData.title = items[i]["Item"]["title"].string!
                        bookData.author = items[i]["Item"]["author"].string!
                        bookData.publisher = items[i]["Item"]["publisherName"].string!
                        bookData.publishDate = items[i]["Item"]["salesDate"].string!
                        let imageURLString = items[i]["Item"]["largeImageUrl"].string!
                        if let imageUrl = URL(string: imageURLString) {
                            do {
                                bookData.image = try Data(contentsOf: imageUrl)
                            } catch let error {
                                print(error)
                            }
                        }
                        print("データを取得：\(bookData.title)")
                        self!.books.append(bookData)
                    }
                    self!.performSegue(withIdentifier: SegueDestination.searchResult, sender: nil)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
            stopIndicator()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == SegueDestination.searchResult {
            let nextVC = segue.destination as! SearchResultViewController
            nextVC.bookArray = books
        }
    }
}

extension CaptureViewController: alertDelegate {

    func toCaptureViewController() {
        captureSession.startRunning()
    }

    func toSearchViewController() {
        self.performSegue(withIdentifier: SegueDestination.searchByKeyword, sender: nil)
    }
    
    func backToHome() {
        dismiss(animated: true, completion: nil)
    }
}

