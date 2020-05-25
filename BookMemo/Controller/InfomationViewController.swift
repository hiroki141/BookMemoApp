//
//  InfomationViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2020/05/25.
//  Copyright © 2020 Hiroki Ifuku. All rights reserved.
//

import UIKit

class InfomationViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = version
        privacyPolicyLabel.text = "プライバシーポリシー"
        privacyPolicyLabel.isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == privacyPolicyLabel.tag {
                let urlString = "https://bookmemo-69fef.firebaseapp.com/privacyPolicy.html"
                let url = URL(string: urlString)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

