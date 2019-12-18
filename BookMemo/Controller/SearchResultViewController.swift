//
//  SearchResultViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/05.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookArray = [AcquiredBookData]()
    var selectedbook = AcquiredBookData()
    var appDelegate:AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //検索画面、またはバーコード読み取り画面に戻るとき、検索結果を削除
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is SearchViewController || viewController is CaptureViewController{
            bookArray.removeAll()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.setNeedsLayout()
//        let bookImageURL = URL(string: self.bookArray[indexPath.row].imageURLString as String)!
//        cell.imageView?.sd_setImage(with: bookImageURL,completed: { (image, error, _, _) in
//            if error == nil{
//                cell.setNeedsLayout()
//            }
//        })
        cell.imageView?.image = UIImage(data:bookArray[indexPath.row].image)
                
            
        cell.textLabel?.text = self.bookArray[indexPath.row].title
        cell.detailTextLabel?.text = self.bookArray[indexPath.row].author
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
                
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedbook = bookArray[indexPath.row]
        performSegue(withIdentifier: "toCreateMemo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateMemo"{
            let createMemoVC = segue.destination as! CreateViewController
            createMemoVC.bookData = selectedbook
        }
    }
    

    
}
