//
//  TTButton.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class TTButton: UIView {
    lazy var button : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.layer.masksToBounds = true
        
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    lazy var bgView : UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        
        bg.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        bg.layer.shadowRadius = 5
        bg.layer.shadowOpacity = 0.8
        
        self.addSubview(bg)
        return bg
    }()
    
    var _image : UIImage?
    var image : UIImage?{
        set{
            _image = newValue
            self.button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        }
        get{
            return _image
        }
    }
    var isRound : Bool = true
    var callback : (()->Void)?
    var paddingRatio : CGFloat = 0
    
    override func layoutSubviews() {
        self.bgView.frame = self.bounds
        let padding : CGFloat = self.bounds.width * self.paddingRatio
        self.button.frame = CGRect.init(x: padding, y: padding, width: self.bounds.width-2*padding, height: self.bounds.height-2*padding)
        if self.isRound{
            self.bgView.layer.cornerRadius =  min(self.bounds.width,self.bounds.height)/2
            self.button.layer.cornerRadius = self.button.bounds.width/2
        }else{
            self.bgView.layer.cornerRadius =  4
            self.button.layer.cornerRadius = 4
        }
    }
    @objc private func btnAction(){
        if (callback != nil) {
            callback!()
        }
    }
    
    override init(frame: CGRect) {
        self.callback = nil
        super.init(frame: frame)
        
        self.bgView.backgroundColor =  Util.mainViewBtnColor
        self.button.tintColor = .white
        self.bgView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
