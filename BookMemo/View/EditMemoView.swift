//
//  EditMemoView.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/10.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit

class EditMemoView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed("view", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

}
