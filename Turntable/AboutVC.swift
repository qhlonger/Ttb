
//
//  AboutVC.swift
//  Turntable
//
//  Created by mini on 2017/12/31.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class AboutVC: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Util.leftBgColor
        
        closeBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.height.equalTo(40)
        })
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.closeBtn)
            make.left.equalTo(self.closeBtn.snp.right)
            make.height.equalTo(self.closeBtn)
        }
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(54+Util.topPadding)
        }
        self.webView.loadRequest(URLRequest.init(url: URL.init(string: "http://sqdao4.xyz/app_manage/zpsupport")!))
        
    }
    
    lazy var closeBtn : TTButton = {
        let btn : TTButton = TTButton()
        btn.image = #imageLiteral(resourceName: "close")
        btn.callback =  {() -> Void in
            self.dismiss(animated: true, completion: {
                
            })
        }
        self.view.addSubview(btn)
        return btn
    }()
    lazy var titleLabel: UILabel = {
        let title : UILabel = UILabel()
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        title.text = Util.locString(str: "about")
        self.view.addSubview(title)
        return title
    }()
    
    lazy var webView: UIWebView = {
        let web : UIWebView = UIWebView()
        web.delegate = self
        self.view.addSubview(web)
        return web
    }()
    
    

    

}
