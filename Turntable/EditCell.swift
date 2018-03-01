//
//  EditCell.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell, UITextFieldDelegate {

    
    
    var _weight : CGFloat?
    var weight : CGFloat?{
        set {
            if newValue! < 0 {
                return
            }else if newValue! < 1 {
                subBtn.button.isEnabled = false
            }else{
                subBtn.button.isEnabled = true
            }
            _weight = newValue
            weightTf.text = String.init(format: "%.0f", newValue!)
            
            
        }
        get {
            return _weight
        }
    }
    
    lazy var titleLabel : UILabel = {
        let title = UILabel.init()
        self.contentView.addSubview(title)
        return title
    }()
    lazy var colorView : UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = 20
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var titleTf: UITextField = {
        let tf : UITextField = UITextField.init()
        tf.delegate = self
        tf.addTarget(self, action: #selector(textChange(tf:)), for: .editingChanged)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.textAlignment = .left
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 4
        tf.placeholder = Util.locString(str: "inputitemtitle")
        
//        tf.layer.shadowOffset = CGSize.init(width: 3, height: 3)
//        tf.layer.shadowRadius = 5
//        tf.layer.shadowOpacity = 0.8
        
        tf.leftView = UIView.init(frame: CGRect.init(x: 5, y: 5, width: 5, height: 5 ))
        tf.leftViewMode = .always
        
//        tf.layer.masksToBounds = true
        self.contentView.addSubview(tf)
        return tf
    }()
    lazy var weightTf: UITextField = {
        let tf : UITextField = UITextField.init()
        tf.isUserInteractionEnabled = false
        tf.delegate = self
        tf.addTarget(self, action: #selector(textChange(tf:)), for: .editingChanged)
        tf.backgroundColor = .white
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = Util.editTextColor
        tf.text = "1"
        tf.layer.cornerRadius = 4
        
        
//        tf.layer.shadowOffset = CGSize.init(width: 3, height: 3)
//        tf.layer.shadowRadius = 5
//        tf.layer.shadowOpacity = 0.8
        
        
//        tf.layer.masksToBounds = true
        self.contentView.addSubview(tf)
        return tf
    }()
    lazy var plusBtn: TTButton = {
        let btn : TTButton = TTButton()
        btn.button.setTitle("+", for: .normal)
        btn.button.backgroundColor = Util.editBtnColor
        btn.button.setTitleColor(.white, for: .normal)
        btn.button.setTitleColor(.gray, for: .disabled)
        btn.isRound = false
        btn.callback = {()->Void in
            self.weight = self.weight! + 1
        }
        self.contentView.addSubview(btn)
        return btn
    }()
    
    
    
    lazy var subBtn : TTButton = {
        let btn : TTButton = TTButton()
        btn.button.setTitle("-", for: .normal)
        btn.button.backgroundColor = Util.editBtnColor
        btn.button.setTitleColor(.white, for: .normal)
        btn.button.setTitleColor(.gray, for: .disabled)
        btn.isRound = false
        btn.callback = {()->Void in
            self.weight = self.weight! - 1
        }
        self.contentView.addSubview(btn)
        return btn
    }()
    var titleChanged : ((_ text:NSString)->Void)!
    var weightChanged : ((_ text:NSString)->Void)!
    
    
    
    @objc func textChange(tf:UITextField){
        if tf == titleTf {
            if (self.titleChanged != nil) {
                self.titleChanged(tf.text! as NSString)
            }
        }else if tf == weightTf {
            if (self.weightChanged != nil) {
                self.weightChanged(tf.text! as NSString)
            }
        }
    }
    func refreshBtn() {
        
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .gray
        
//        self.colorView.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.centerY.equalTo(self.contentView)
//            make.width.height.equalTo(40)
//        }
        self.titleTf.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(self.subBtn.snp.left).offset(-15)
//            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.6)
        }
        self.subBtn.snp.makeConstraints { (make) in
            make.width.equalTo(self.subBtn.snp.height).multipliedBy(0.8)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.weightTf.snp.left).offset(-5)
        }
        self.weightTf.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(self.plusBtn.snp.left).offset(-5)
        }
        self.plusBtn.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.plusBtn.snp.height).multipliedBy(0.8)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.centerY.equalTo(self.contentView)
//            make.left.equalTo(self.weightTf.snp.left).offset(-10)
            make.right.equalTo(-15)
            
        }
//        self.contentView.snp.makeConstraints { (make) in
//            make.top.equalTo(5)
//            make.bottom.equalTo(-5)
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    override func layoutSubviews() {
//        let w : CGFloat = self.contentView.bounds.width
//        let h : CGFloat = self.contentView.bounds.height
//        self.titleLabel.frame = CGRect.init(x: 10, y: 0, width: w*0.6, height: h)
//        self.subBtn.frame = CGRect.init(x: self.titleLabel.bounds.maxX, y: , width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
