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
}

final class AlertManager {

    var type: AlertType
    var delegate: alertDelegate?

    init(alertType: AlertType) {
        type = alertType
    }

    func showAlert() -> UIAlertController {
        switch type {
        case .saveSucceed:
            let alertController = UIAlertController(title: "保存しました", message: "編集を続けますか？BOOK一覧に戻りますか?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "book一覧へ", style: .default, handler: {(_) in
                self.delegate?.backToHome()
            }))
            alertController.addAction(UIAlertAction(title: "編集を続ける", style: .cancel, handler: nil))
            return alertController
            
        case .removeWarning:
            let alertController = UIAlertController(title: "アラート表示", message: "削除しますか？", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](_) in
                guard let _ = self else {return}
                self!.delegate?.deleteBook()
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
            let alertController = UIAlertController(title: "本が見つかりませんでした", message: "本の検索方法を選択してください", preferredStyle: .actionSheet)
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
            
        }
    }
}
