//
//  ViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/05.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var booksTableView: UITableView!
    
    var appDelegate:AppDelegate!
    var books = [Book]()
    var selectedBook = Book()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        booksTableView.delegate = self
        booksTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        books = appDelegate.dataController.fetchBooks()
        booksTableView.reloadData()
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.imageView?.image = UIImage(data:books[indexPath.row].image!)
        cell.textLabel?.text = books[indexPath.row].title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = books[indexPath.row].author
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = books[indexPath.row]
        
        performSegue(withIdentifier: "toEditMemo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditMemo"{
            let editMemoVC = segue.destination as! EditMemoViewController
            editMemoVC.book = selectedBook
        }
    }
    
    
    @IBAction func newCreate(_ sender: Any) {
        alert(title: "メモの新規作成", message: "本の情報を取得します。")
        
    }
    
    func alert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "バーコードを読み取る", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "toCapture", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "キーワードで検索する", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "toSearch", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    

}

