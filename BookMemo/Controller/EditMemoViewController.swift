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
    
    var appDelegate:AppDelegate!
    
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
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
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
  
    
//    箇条書の実装
//    func textViewDidChange(_ textView: UITextView) {
//        let letter = textView.text.suffix(1)
//        if letter == "\n"{
//            print("改行")
//        }else{
//            print("入力された文字:\(letter)")
//            textView.text.append("\u{2022}")
//        }
//    }
    

    @IBAction func saveAction(_ sender: Any) {
        
        book!.memo = memoTextView.text
        appDelegate.dataController.saveContext()
        saveReport(title: "保存しました", message: "book一覧へ戻りますか？編集を続けますか？")
        
    }
    
    
    
    //削除ボタン
    @IBAction func deleteAction(_ sender: Any) {
        deleteAlert(title: "アラート表示", message: "削除しますか？")
    }
    
    
    
    func deleteAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](UIAlertAction) in
            guard let _ = self else{return}
            
                self!.appDelegate.dataController.delete(title: self!.book!.title!)
                self?.navigationController?.popViewController(animated: true)
            
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    
    //保存したあと
    //book一覧に戻るか、
    //編集を続ける
    func saveReport(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "book一覧へ", style: .default, handler: { [weak self](UIAlertAction) in
            guard let _ = self else{return}
                self?.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "編集を続ける", style: .cancel, handler: {[weak self](UIAlertAction) in
            guard let _ = self else{return}
        }))
        present(alertController, animated: true)
    }
    

}
