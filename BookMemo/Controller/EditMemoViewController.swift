//
//  EditMemoViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/08.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit

class EditMemoViewController: UIViewController,UITextViewDelegate {
    
    var book: Book? = Book()
    var dataManager = DataManager(){}
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @objc func onClickCommitButton(sender: UIButton){
        if memoTextView.isFirstResponder{
            memoTextView.resignFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = book!.title
        authorLabel.text = book!.author
        publisherLabel.text = book!.publisher
        publishDateLabel.text = book!.publishDate
        bookImageView.image = UIImage(data: book!.image!)
        
        memoTextView.text = book!.memo
        memoTextView.layer.cornerRadius = 10.0
        memoTextView.layer.masksToBounds = true
        //キーボードに完了ボタンを追加
        let customBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let commitButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-50, y: 0, width: 50, height: 44))
        commitButton.setTitle("完了", for: .normal)
        commitButton.setTitleColor(UIColor.blue, for: .normal)
        commitButton.addTarget(self, action: #selector(EditMemoViewController.onClickCommitButton), for: .touchUpInside)
        customBar.addSubview(commitButton)
        memoTextView.inputAccessoryView = customBar
        memoTextView.keyboardType = .default
        memoTextView.delegate = self
        
        saveButton.layer.cornerRadius = 10.0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    @IBAction func saveAction(_ sender: Any) {
        
        book!.memo = memoTextView.text
        dataManager.saveContext()
        
        let saveReportManager = AlertManager(alertType: .saveSucceed)
        saveReportManager.delegate = self
        let saveRepotController = saveReportManager.showAlert()
        present(saveRepotController, animated: true)
    }
    
    //削除ボタン
    @IBAction func deleteAction(_ sender: Any) {
        let deleteAlertManager = AlertManager(alertType: .removeWarning)
        deleteAlertManager.delegate = self
        let deleteAlertController = deleteAlertManager.showAlert()
        present(deleteAlertController, animated: true)
    }
}

extension EditMemoViewController: alertDelegate{
    
    func backToHome() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteBook() {
        self.dataManager.delete(title: self.book!.title!)
        self.navigationController?.popViewController(animated: true)
    }
}
