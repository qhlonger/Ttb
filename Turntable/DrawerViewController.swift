//
//  DrawerViewController.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

    lazy var tableView : UITableView = {
        let tab = UITableView.init(frame: self.view.bounds, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.register(DrawerCell.self, forCellReuseIdentifier: "DrawerCell")
        tab.backgroundColor = Util.leftBgColor
        tab.separatorStyle = .none
        tab.estimatedSectionFooterHeight = 0
        tab.estimatedSectionHeaderHeight = 0
//        tab.sectionFooterHeight = 0
//        tab.sectionHeaderHeight = 0
        self.automaticallyAdjustsScrollViewInsets = false
        tab.contentInset = .zero
        self.view.addSubview(tab)
        return tab
    }()
    lazy var infoBtn : TTButton = {
        let btn : TTButton = TTButton()
//        btn.image = #imageLiteral(resourceName: "side")
        btn.button.setTitle("i", for: .normal)
        btn.callback =  {() -> Void in
            
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "InfoVC"), object: nil, userInfo: nil) as Notification)
            })
            
        }
        self.bottomView.addSubview(btn)
        return btn
    }()
    lazy var addBtn : TTButton = {
        let btn = TTButton()
        btn.button.backgroundColor = Util.mainViewBtnColor
        btn.image = #imageLiteral(resourceName: "add")
        btn.callback = {()->Void in
            self.dismiss(animated: true, completion: {
                
                NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "NewTurntable"), object: nil, userInfo: nil) as Notification)
            })
        }
        self.bottomView.addSubview(btn)
        return btn
    }()
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = Util.locString(str: "switch")
        
        title.numberOfLines = 0
        title.textColor =  Util.leftTextColor
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        self.topView.addSubview(title)
        return title
    }()
    
    lazy var topView :UIView = {
       let view = UIView()
        
        
        
        view.layer.shadowOffset = CGSize.init(width: -1, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.8
        
        view.backgroundColor = Util.leftBgColor
        
        
        self.view.addSubview(view)
        return view
    }()
    lazy var bottomView : UIView = {
        let view = UIView()
        
        view.layer.shadowOffset = CGSize.init(width: -1, height: -3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.8
        view.backgroundColor = Util.leftBgColor
        
        self.view.addSubview(view)
        
        return view
    }()
    
    
    @objc func updateTurnTable(){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTurnTable), name: NSNotification.Name(rawValue: "UpdateTurnTable"), object: nil)
        self.view.bringSubview(toFront: self.topView)
        self.view.bringSubview(toFront: self.bottomView)
        self.view.sendSubview(toBack: self.tableView)
        
        self.view.backgroundColor = Util.leftBgColor
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            
            make.left.equalTo(self.view)
            make.width.equalTo(Util.sideWidth)
        })
        
        self.topView.snp.makeConstraints { (make) in
            
            make.height.equalTo(100+Util.topPadding)
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(Util.sideWidth)
        }
        self.bottomView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(self.view)
            make.height.equalTo(140)
            
            make.left.equalTo(self.view)
            make.width.equalTo(Util.sideWidth)
        }
        self.addBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Util.sideWidth/2)
            make.centerX.centerY.equalTo(bottomView)
        }
        self.titleLabel.snp.makeConstraints { (make) in
//            make.height.equalTo(100)
            make.top.equalTo(Util.topPadding)
            make.left.right.bottom.equalTo(topView)
        }
        self.infoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.bottomView).offset(10)
            make.bottom.equalTo(self.bottomView).offset(-10)
            make.width.height.equalTo(36)
        }
    }
    
    var selectIndex = 0
}


extension DrawerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellID : String =  "DrawerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! DrawerCell
        cell.sel = selectIndex == indexPath.row
        
        cell.titleLabel.text = allTurntables[indexPath.row].title! as String
//        cell.setSelected(allTurntables[indexPath.row].id == selectedTurntable.id, animated: false)
        cell.backgroundColor = (indexPath.row % 2 == 0)  ? Util.leftRowColor : Util.leftDarkRowColor
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTurntables.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTurntable = allTurntables[indexPath.row]
        selectIndex = indexPath.row
        tableView.reloadData()
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
}
