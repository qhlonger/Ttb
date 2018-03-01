//
//  EditHeader.swift
//  Turntable
//
//  Created by mini on 2017/11/16.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class EditHeader: UITableViewHeaderFooterView {
    lazy var titleLabel : UILabel = {
        let title : UILabel = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(title)
        return title
    }()
    
    override func layoutSubviews() {
        self.titleLabel.frame = self.bounds
    }
}
