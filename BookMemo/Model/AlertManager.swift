//
//  Alert.swift
//  BookMemo
//
//  Created by 井福弘基 on 2020/01/20.
//  Copyright © 2020 Hiroki Ifuku. All rights reserved.
//

import Foundation
import UIKit

protocol alertDelegate {
    func backToHome()
    func continueEditing()
    func deleteBook()
    func toCaptureViewController()
    func toSearchViewController()
}

extension alertDelegate {
    func backToHome() {}
    func continueEditing() {}
    func deleteBook() {}
    func toCaptureViewController() {}
    func toSearchViewController() {}
}

enum AlertType {
    case saveSucceed
    case removeWarning
    case selectSearchMethod
    case scanFailed
    case searchFailed
}

final class AlertManager {

    var type: AlertType
    var delegate: alertDelegate?

    init(alertType: AlertType) {
        type = alertType
    }

    func showAlert(title: String = "エラー", message: String = "") -> UIAlertController {
        switch type {
        case .saveSucceed:
            let alertController = UIAlertController(title: "保存しました", message: "編集を続けますか？BOOK一覧に戻りますか?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "book一覧へ", style: .default, handler: {(_) in
                self.delegate?.backToHome()
            }))
            alertController.addAction(UIAlertAction(title: "編集を続ける", style: .default, handler: {(_) in
                self.delegate?.continueEditing()
            }))
            return alertController
            
        case .removeWarning:
            let alertController = UIAlertController(title: "削除しますか？", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                self.delegate?.deleteBook()
            }))
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            return alertController
            
        case .selectSearchMethod:
            let alertController = UIAlertController(title: "メモの新規作成", message: "本の検索方法を選択してください", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "バーコードを読み取る", style: .default, handler: { (_) in
                self.delegate?.toCaptureViewController()
            }))
            alertController.addAction(UIAlertAction(title: "キーワードで検索する", style: .default, handler: { (_) in
                self.delegate?.toSearchViewController()
            }))
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            return alertController
            
        case .scanFailed:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "バーコードを読み取る", style: .default, handler: { (_) in
                self.delegate?.toCaptureViewController()
            }))
            alertController.addAction(UIAlertAction(title: "キーワードで検索する", style: .default, handler: { (_) in
                self.delegate?.toSearchViewController()
            }))
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (_) in
                self.delegate?.backToHome()
            }))
            return alertController
            
        case .searchFailed:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertController
        }
    }
}
