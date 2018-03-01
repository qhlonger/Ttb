//
//  EditTitleCell.swift
//  Turntable
//
//  Created by mini on 2017/11/16.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class EditTitleCell: UITableViewCell, UITextFieldDelegate {
    var titleChanged : ((_ title:NSString)-> Void)!
    
    lazy var titleTf: UITextField = {
        let tf : UITextField = UITextField.init()
        tf.delegate = self
        tf.addTarget(self, action: #selector(textChange(tf:)), for: .editingChanged)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = Util.locString(str: "inputtitle")
        tf.textAlignment = .left
        tf.font = UIFont.systemFont(ofSize: 14)
//        tf.layer.cornerRadius = 4
//
//
//        tf.layer.shadowOffset = CGSize.init(width: 3, height: 3)
//        tf.layer.shadowRadius = 5
//        tf.layer.shadowOpacity = 0.8
        
        tf.leftView = UIView.init(frame: CGRect.init(x: 5, y: 5, width: 5, height: 5 ))
        tf.leftViewMode = .always
        
        //        tf.layer.masksToBounds = true
        self.contentView.addSubview(tf)
        return tf
    }()
    
    @objc func textChange(tf:UITextField){
        if self.titleChanged != nil {
            self.titleChanged(tf.text! as NSString)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleTf.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
