//
//  AlertVC.swift
//  Turntable
//
//  Created by mini on 2017/11/16.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    lazy var mainView: UIView = {
        let v : UIView = UIView()
        v.layer.cornerRadius = 4
        v.backgroundColor = .white
        self.view.addSubview(v)
        return v
    }()
    lazy var titleLabel : UILabel = {
        let title : UILabel = UILabel()
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor.black
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        mainView.addSubview(title)
        return title
    }()
    lazy var txtLabel : UILabel = {
        let text : UILabel = UILabel()
        text.textAlignment = .center
//        text.backgroundColor = .red
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = UIColor.darkGray
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        mainView.addSubview(text)
        return text
    }()
    lazy var okBtn: UIButton = {
        let ok : UIButton = UIButton()
        ok.layer.cornerRadius = 4
        ok.backgroundColor = Util.mainViewBtnColor
        ok.addTarget(self, action: #selector(okDo), for: .touchUpInside)
        ok.setTitle(Util.locString(str: "confirm"), for: .normal)
        mainView.addSubview(ok)
        return ok
    }()
    lazy var cancalBtn: UIButton = {
        let cancel : UIButton = UIButton()
        cancel.layer.cornerRadius = 4
        cancel.backgroundColor = Util.mainViewBtnColor
        cancel.addTarget(self, action: #selector(cancelDo), for: .touchUpInside)
        cancel.setTitle(Util.locString(str: "cancel"), for: .normal)
        mainView.addSubview(cancel)
        return cancel
    }()
    
    @objc func okDo (){
        if (self.okAction != nil){
            self.okAction!()
        }
        doHide()
    }
    @objc func cancelDo(){
       doHide()
    }
    func doHide(){
        UIView.animate(withDuration: 0.25, animations: {
            self.mainView.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
            self.mainView.alpha = 0
        }) { (comp) in
            self.dismiss(animated: false) {
                
            }
        }
    }
    
    
    var okAction : (()->Void)?
    var _alertTitle : String!
    var alertTitle : String!{
        set{
            _alertTitle = newValue
            self.titleLabel.text = newValue
        }
        get{
            return _alertTitle
        }
    }
    var _alertContent : String!
    var alertContent : String!{
        set{
            _alertContent = newValue
            self.txtLabel.text = newValue
        }
        get{
            return _alertContent
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.mainView.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        self.mainView.alpha = 0
        self.titleLabel.text = self.alertTitle
        self.txtLabel.text = self.alertContent
        
//        self.titleLabel.text = "asgasgbasgoabs"
//        self.txtLabel.text = "215126161286"
    }
    override func viewDidLayoutSubviews() {
        self.mainView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(min(self.view.frame.width, self.view.frame.height) * 0.8)
            make.height.equalTo(self.mainView.snp.width).multipliedBy(0.7)
        }
        self.cancalBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.mainView).offset(15)
            make.bottom.equalTo(self.mainView).offset(-15)
            make.height.equalTo(40)
            make.width.equalTo(self.okBtn)
        }
        self.okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.mainView).offset(-15)
            make.bottom.equalTo(self.mainView).offset(-15)
            make.height.equalTo(self.cancalBtn)
            make.left.equalTo(self.cancalBtn.snp.right).offset(15)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.mainView).offset(15)
            make.right.equalTo(self.mainView).offset(-15)
            make.height.equalTo(40)
            make.top.equalTo(self.mainView).offset(15)
        }
        self.txtLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.mainView).offset(15)
            make.right.equalTo(self.mainView).offset(-15)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.bottom.equalTo(self.okBtn.snp.top).offset(-15)
            
        }
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.3) {
            self.mainView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.mainView.alpha = 1
        }
    }
    
    
    
    
    
    
}
