//
//  SearchViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/10.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SearchViewController: UIViewController,UISearchBarDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleSearchButton: UIButton!
    @IBOutlet weak var authorSearchButton: UIButton!
    
    
    
    
    var books = [AcquiredBookData]()
    var searchKeyword:String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleSearchButton.layer.cornerRadius = 10.0
        authorSearchButton.layer.cornerRadius = 10.0
        
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationController?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        books.removeAll()
        enableButtons()
    }
    
    
    
    func enableButtons(){
        if searchBar.text!.isEmpty{
            titleSearchButton.isEnabled = false
            titleSearchButton.alpha = 0.3
            authorSearchButton.isEnabled = false
            authorSearchButton.alpha = 0.3
        }else{
            titleSearchButton.isEnabled = true
            titleSearchButton.alpha = 1.0
            authorSearchButton.isEnabled = true
            authorSearchButton.alpha = 1.0
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        enableButtons()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    @IBAction func searchWithTitle(_ sender: Any) {
        searchKeyword = searchBar.text
        if let keyword = searchKeyword{
            getBookData(searchKeyword: keyword, keywordType: keywordType.title)
            print("searchKeyword: \(keyword)")
        }
    }
    
    @IBAction func searchWithAuthor(_ sender: Any) {
        searchKeyword = searchBar.text
        if let keyword = searchKeyword{
            getBookData(searchKeyword: keyword, keywordType: keywordType.author)
            print("searchKeyword: \(keyword)")
        }
    }
    
    
    func getBookData(searchKeyword:String, keywordType:keywordType){
        
        let urlManager = UrlManager(keywordType: keywordType, keyword: searchKeyword)
        let url = urlManager.getURL()
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default).responseJSON{[weak self](response) in
            guard let _ = self else{return}
                
            switch response.result{
                case .success:
                    let json:JSON = JSON(response.data as Any)
                    print(json)
                    let resultCount = json["count"].int!
                    guard resultCount != 0 else {
                        print("本が見つかりませんでした（0 hit）")
                        return
                    }
                    let items = json["Items"]
                    for (i, _) in items.enumerated(){
                        var bookData:AcquiredBookData = AcquiredBookData()
                        bookData.title = items[i]["Item"]["title"].string!
                        bookData.author = items[i]["Item"]["author"].string!
                        bookData.publisher = items[i]["Item"]["publisherName"].string!
                        bookData.publishDate = items[i]["Item"]["salesDate"].string!
                        //イメージURLをデータ型にして代入
                        let imageURLString = items[i]["Item"]["largeImageUrl"].string!
                        if let imageUrl = URL(string: imageURLString){
                            do {
                                bookData.image = try Data(contentsOf: imageUrl)
                            }catch let error{
                                print(error)
                            }
                        }
                        print("データを取得：\(bookData.title)")
                        self!.books.append(bookData)
                        }
                    self!.performSegue(withIdentifier: "toSearchResult", sender: nil)
                case .failure(let error):
                    print(error)
                    break
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResult"{
            let nextVC = segue.destination as! SearchResultViewController
            nextVC.bookArray = books
        }
    }
    
    @IBAction func backTopPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    
}
