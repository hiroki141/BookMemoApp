//
//  UIViewController+Extenrtion.swift
//  BookMemo
//
//  Created by 井福弘基 on 2020/05/20.
//  Copyright © 2020 Hiroki Ifuku. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func startIndicator() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        
        let grayOutView = UIView(frame: self.view.frame)
        grayOutView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        grayOutView.addSubview(loadingIndicator)
        self.view.addSubview(grayOutView)
    }
    
    func stopIndicator() {
        self.view.subviews.last?.removeFromSuperview()
    }

}
