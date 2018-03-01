//
//  ItemCell.swift
//  Turntable
//
//  Created by mini on 2017/11/17.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    lazy var titleLabel : UILabel = {
        let title = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(title)
        return title
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        }
//        self.titleLabel.frame = CGRect.init(x: 15, y: 0, width: self.bounds.width-30, height: self.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
