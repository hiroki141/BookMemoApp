//
//  CreateViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/12.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController,UITextViewDelegate {
    
    var bookData = AcquiredBookData()
    var dataManager = DataManager(){}
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView! {
        didSet{
            memoTextView.layer.cornerRadius = 10.0
            memoTextView.layer.masksToBounds = true
            memoTextView.delegate = self
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    
    @objc func onClickCommitButton(sender: UIButton){
        if memoTextView.isFirstResponder{
            memoTextView.resignFirstResponder()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookImage.image = UIImage(data: bookData.image)
        titleLabel.text = bookData.title
        authorLabel.text = bookData.author
        publisherLabel.text = bookData.publisher
        
        
        //キーボードに完了ボタンを追加
        let customBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let commitButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-50, y: 0, width: 50, height: 44))
        commitButton.setTitle("完了", for: .normal)
        commitButton.setTitleColor(UIColor.blue, for: .normal)
        commitButton.addTarget(self, action: #selector(EditMemoViewController.onClickCommitButton), for: .touchUpInside)
        customBar.addSubview(commitButton)
        memoTextView.inputAccessoryView = customBar
        memoTextView.keyboardType = .default
        
        saveButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func saveAction(_ sender: Any) {
        //新しいデータの作成
        let book = dataManager.createBook()
        
        
        book.title = bookData.title
        book.author = bookData.author
        book.publisher = bookData.publisher
        book.publishDate = bookData.publishDate
        book.image = bookData.image
        book.memo = memoTextView.text
        
        dataManager.saveContext()
        print("新しいbookを保存しました")
        saveReport(title: "保存しました", message: "book一覧へ戻りますか？編集を続けますか？")
        
    }
    
    //保存したあと
    //book一覧に戻るか、
    //編集を続ける
    func saveReport(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "book一覧へ", style: .default, handler: { [weak self](UIAlertAction) in
            guard let _ = self else{return}
            self!.performSegue(withIdentifier: "toTopPage", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "編集を続ける", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    
    

   
}
