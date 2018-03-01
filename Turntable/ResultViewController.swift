
//
//  ResultViewController.swift
//  Turntable
//
//  Created by mini on 2017/11/13.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    lazy var resultLabel: UILabel = {
        let label :UILabel = UILabel.init()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(label)
        return label
    }()
    
    lazy var closeBtn: TTButton = {
        let btn = TTButton()
        btn.callback = {()-> Void in
            self.dismiss(animated: true, completion: {
                if (self.dismissCallback != nil){
                    self.dismissCallback()
                }
            })
        }
        
        
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var bgView: UIView = {
        let view : UIView = UIView()
        
        self.view.addSubview(view)
        return view
    }()
    
    var dismissCallback : (()->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.bgView.bounds = CGRect.init(x: 0, y: 0, width: 2000, height: 2000)
        self.bgView.center = CGPoint.init(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        self.bgView.layer.cornerRadius = 1000
        
//        self.isHeroEnabled = true
//        bgView.heroID = "resultBg"
        
        self.closeBtn.button.setImage(#imageLiteral(resourceName: "side"), for: .normal)
        
        resultLabel.text = "safiuaviufvlauvyfi"
        
        
        
        closeBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.height.equalTo(40)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
