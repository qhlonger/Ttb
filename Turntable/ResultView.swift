//
//  ResultView.swift
//  Turntable
//
//  Created by mini on 2017/11/18.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class ResultView: UIView {
    lazy var titleLabel : UILabel = {
        let title : UILabel = UILabel.init()
        title.textColor = .white
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        self.addSubview(title)
        return title
    }()
    lazy var closeBtn : TTButton = {
        let btn : TTButton = TTButton()
        btn.image = #imageLiteral(resourceName: "close")
        btn.tintColor = .white
        btn.callback = {()->Void in
            self.hide()
        }
        self.addSubview(btn)
        return btn
    }()
    
    var _title : NSString!
    var  title : NSString!{
        set{
            _title = newValue
            titleLabel.text = newValue as String?
        }
        get{
            return _title
        }
    }
    var _showLayout : (()->Void)!
    var showLayout : (()->Void)!
    
    var _hideLayout : (()->Void)!
    var hideLayout : (()->Void)!{
        set{
            _hideLayout = newValue
            newValue()
        }
        get{
            return _hideLayout
        }
    }
    
    func show(){
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.showLayout()
        }) { (comp) in
            
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.hideLayout()
        }) { (comp) in
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
//        self.alpha = 0
    }
    override func layoutSubviews() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(Util.topPadding + 50)
            make.bottom.equalTo(-Util.topPadding - 50)
        }
        closeBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(Util.topPadding)
            make.width.height.equalTo(40)
        })
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
