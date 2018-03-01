//
//  DrawerCell.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {

    
    
    lazy var titleLabel: UILabel = {
        let title = UILabel.init()
        title.textColor = Util.leftTextColor
        title.textAlignment = .center
        self.addSubview(title)
        return title
    }()
    lazy var selView: UIView = {
        let sel = UIView.init()
        sel.isHidden = true
        sel.backgroundColor = Util.editBtnColor
        self.addSubview(sel)
        return sel
    }()
    
    var _sel : Bool = false
    var sel : Bool{
        set{
            _sel = newValue
            self.selView.isHidden = !newValue
        }
        get{
            return _sel
        }
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.top.equalTo(0)
//            make.bottom.equalTo(0)
//            make.width.equalTo(Util.sideWidth-20)
//        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(Util.sideWidth-20)
            
//            make.left.equalTo(0)
//            make.top.equalTo(5)
//            make.bottom.equalTo(-5)
//            make.right.equalTo(0)
        }
        
        selView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
  
}
