
//
//  EditFooter.swift
//  Turntable
//
//  Created by mini on 2017/11/19.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class EditFooter: UITableViewHeaderFooterView {
    
    var importAction : (()->Void)!
    var addAction : (()->Void)!
    
    
    
    lazy var importBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self, action: #selector(ipt), for: .touchUpInside)
        btn.backgroundColor = Util.get16Color(rgb: 0x8a99a5)
                btn.setTitle(Util.locString(str: "import"), for: .normal)
        
                btn.layer.borderColor = UIColor.white.cgColor
                btn.layer.borderWidth = 1
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(btn)
        return btn
    }()
    lazy var addBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = Util.get16Color(rgb: 0x8a99a5)
                btn.setTitle("+", for: .normal)
        
                btn.layer.borderColor = UIColor.white.cgColor
                btn.layer.borderWidth = 1
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        btn.addTarget(self, action: #selector(add), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    @objc func ipt(){
        if (importAction != nil) {
            importAction()
        }
    }
    @objc func add(){
        if (addAction != nil) {
            addAction()
        }
    }
    
    override func layoutSubviews() {
        let w : CGFloat = 140
        
        
        
        self.importBtn.frame = CGRect.init(x: 0, y: 0, width: w, height: self.bounds.height)
        self.addBtn.frame = CGRect.init(x: w-1, y: 0, width: self.bounds.width-w+1, height: self.bounds.height)
    }
    
    

}
