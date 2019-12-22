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



class CaptureViewController: UIViewController {
    
    @IBOutlet weak var captureView: UIView!
    
    var books = [AcquiredBookData]()

    
    // 読み取り範囲
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
    
    lazy var captureSession: AVCaptureSession = AVCaptureSession()
    lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
    lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()
    
    var captureInput: AVCaptureInput? = nil
    lazy var captureOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // どの範囲を解析するか設定する
        captureOutput.rectOfInterest = CGRect(x:y, y:1-x-width, width:height, height:width)

        // 解析範囲を表すボーダービューを作成する
        let borderView = UIView(frame: CGRect(x:x * self.view.bounds.width, y:y * self.view.bounds.height, width:width * self.view.bounds.width, height:height * self.view.bounds.height))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView)
        
        let label = UILabel(frame: CGRect(x: x * self.view.bounds.width, y: y * self.view.bounds.height-50, width: width * self.view.bounds.width, height: 50))
        label.text = "上段のバーコードを枠に入れてください"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(label)

        setUpBarcodeCapture()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturePreviewLayer.frame = self.captureView?.bounds ?? CGRect.zero
    }
    
    func setUpBarcodeCapture(){
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureInput!)
            captureSession.addOutput(captureOutput)
            captureOutput.metadataObjectTypes = captureOutput.availableMetadataObjectTypes
            capturePreviewLayer.frame = self.captureView?.bounds ?? CGRect.zero
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureView?.layer.addSublayer(capturePreviewLayer)
            captureSession.startRunning()
        } catch let error as NSError {
            print(error)
        }
    }
    
    //ISBNの判定を行う
    func isISBN(isbn:String) ->Bool{
        let v = NSString(string: isbn).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        if prefix == 978 || prefix == 979 {
            return true
        }else{ return false }
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
            
            let url = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&isbn=\(value)&applicationId=1043569448607728611"
            AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default).responseJSON{[weak self](response) in
                guard let _ = self else{return}
                    
                switch response.result{
                    case .success:
                        let json:JSON = JSON(response.data as Any)
                        print(json)
                        let resultCount = json["count"].int
                        guard resultCount != 0 else {
                            print("本が見つかりませんでした（0 hit）")
                            return
                        }
                        for i in 0...resultCount!-1{
                            if i < resultCount! {
                                let bookData:AcquiredBookData = AcquiredBookData()
                                bookData.title = json["Items"][i]["Item"]["title"].string!
                                bookData.author = json["Items"][i]["Item"]["author"].string!
                                bookData.publisher = json["Items"][i]["Item"]["publisherName"].string!
                                bookData.publishDate = json["Items"][i]["Item"]["salesDate"].string!
                                let imageURLString = json["Items"][i]["Item"]["largeImageUrl"].string!
                                let imageUrl = URL(string: imageURLString)
                                do {
                                    bookData.image = try Data(contentsOf: imageUrl!)
                                }catch let error{
                                    print(error)
                                }
                                
                                print("データを取得：\(bookData.title)")
                                self!.books.append(bookData)
                            }else{break}
                            self!.performSegue(withIdentifier: "toSearchResult", sender: nil)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        break
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResult"{
            let nextVC = segue.destination as! SearchResultViewController
            nextVC.bookArray = books
        }
    }
}
