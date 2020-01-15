//
//  URL.swift
//  BookMemo
//
//  Created by 井福弘基 on 2020/01/13.
//  Copyright © 2020 Hiroki Ifuku. All rights reserved.
//

import Foundation

enum keywordType {
    case isbn
    case title
    case author
}

class UrlManager{
    var type:keywordType
    var keyword:String
    
    init(keywordType:keywordType, keyword:String){
        type = keywordType
        self.keyword = keyword
    }
    
    func getURL() -> String {
        switch type {
        case .isbn:
            let url = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&isbn=\(keyword)&hits=10&applicationId=1043569448607728611"
            return url
        case .title:
            let urlString = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title=\(keyword)&hits=10&applicationId=1043569448607728611"
            let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return url
        case .author:
            let urlString = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&author=\(keyword)&hits=10&applicationId=1043569448607728611"
            let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return url
        }
    }
}
