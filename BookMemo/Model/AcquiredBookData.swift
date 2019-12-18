//
//  AcquiredBookData.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/09.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import Foundation

//APIで取得した本の情報を一時的に保持するためのクラス
class AcquiredBookData{
    var title = ""
    var author = ""
    var publisher = ""
    var publishDate = ""
    var image = Data()
}
