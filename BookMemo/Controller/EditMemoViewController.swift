//
//  EditMemoViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/08.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit

class EditMemoViewController: UIViewController, UITextViewDelegate {

    var book: Book? = Book()
    var dataManager = DataManager {}

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView! {
        didSet {
            memoTextView.layer.cornerRadius = 10.0
            memoTextView.layer.masksToBounds = true
            memoTextView.font = UIFont.systemFont(ofSize: 16.0)
            memoTextView.delegate = self
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 10.0
        }
    }

    @objc func onClickCommitButton(sender: UIButton) {
        if memoTextView.isFirstResponder {
            memoTextView.resignFirstResponder()
        }
    }

    var makeABullet = false
    let bulletButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-105, y: 0, width: 50, height: 44))

    @objc func onClickBulletButton(sender: UIButton) {
        if makeABullet == false {
            makeABullet = true
            bulletButton.tintColor = .blue

            let location = memoTextView.selectedRange.location
            let previousOneCharacter = (memoTextView.text as NSString).substring(with: NSRange(location: location-1, length: 1))

            // メモの先頭、または直前で改行しているところから始めるとき、そのまま点を打つ
            if previousOneCharacter == "\n" || memoTextView.text == ""{
                memoTextView.insertText(" \u{2022}  ")

                //　それ以外の時、改行してから点を打つ
            } else {
                memoTextView.insertText("\n \u{2022}  ")
            }
        } else {
            makeABullet = false
            bulletButton.tintColor = .white
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

        //キーボードに完了ボタンを追加
        let commitButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-50, y: 0, width: 50, height: 44))
        commitButton.setTitle("完了", for: .normal)
        commitButton.setTitleColor(UIColor.blue, for: .normal)
        commitButton.addTarget(self, action: #selector(EditMemoViewController.onClickCommitButton), for: .touchUpInside)

        let bulletImage = UIImage(named: "bullet.png")?.withRenderingMode(.alwaysTemplate)
        bulletButton.setImage(bulletImage, for: .normal)
        bulletButton.tintColor = .white
        bulletButton.addTarget(self, action: #selector(EditMemoViewController.onClickBulletButton), for: .touchUpInside)

        let customBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        customBar.backgroundColor = .systemGray2
        customBar.addSubview(commitButton)
        customBar.addSubview(bulletButton)

        memoTextView.inputAccessoryView = customBar
        memoTextView.keyboardType = .default
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //　箇条書きを作成
        if makeABullet == true {
            if text == "\n"{
                memoTextView.insertText("\n \u{2022}  ")
                return false
            } else {
                return true
            }
        }
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

extension EditMemoViewController: alertDelegate {

    func backToHome() {
        self.navigationController?.popViewController(animated: true)
    }

    func deleteBook() {
        self.dataManager.delete(title: self.book!.title!)
        self.navigationController?.popViewController(animated: true)
    }
}
