//
//  MakeMemoViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/05.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import CoreData


class MakeMemoViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    var appDelegate:AppDelegate!
    
    var bookImage = UIImage()
    var bookData = AcquiredBookData()
    
    @objc func onClickCommitButton(sender: UIButton){
        if memoTextView.isFirstResponder{
            memoTextView.resignFirstResponder()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        bookTitleLabel.text = bookData.title
        authorLabel.text = bookData.author
        publisherLabel.text = bookData.publisher
        publishDateLabel.text = bookData.publishDate
        let bookImageURL = URL(string: self.bookData.imageURLString as String)!
        bookImageView.sd_setImage(with: bookImageURL,completed: { (image, error, _, _) in
            if error == nil{
                self.bookImage = image!
            }
        })
        memoTextView.layer.cornerRadius = 10.0
        memoTextView.layer.masksToBounds = true
        //キーボードに完了ボタンを追加
        let customBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        let commitButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-50, y: 0, width: 50, height: 40))
        commitButton.setTitle("完了", for: .normal)
        commitButton.setTitleColor(UIColor.blue, for: .normal)
        commitButton.addTarget(self, action: #selector(MakeMemoViewController.onClickCommitButton), for: .touchUpInside)
        customBar.addSubview(commitButton)
        memoTextView.inputAccessoryView = customBar
        memoTextView.keyboardType = .default
        memoTextView.delegate = self
        
        saveButton.layer.cornerRadius = 10.0
        
        
        

        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        
        let newBook = appDelegate.dataController.createBook()
        
        
        newBook.title = bookData.title
        newBook.author = bookData.author
        newBook.publisher = bookData.publisher
        newBook.publishDate = bookData.publishDate
        newBook.image = bookImage.jpegData(compressionQuality: 1)
        newBook.memo = memoTextView.text
        
        appDelegate.dataController.saveContext()
        
        performSegue(withIdentifier: "saveReport", sender: nil)
        
        
    }
    

   
}
