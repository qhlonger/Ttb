//
//  EditViewController.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift
class EditViewController: UIViewController {
    //MARK: Vars
    var turntable : Turntable!
    var isEdit : Bool = true
    
    
    lazy var closeBtn: TTButton = {
        let btn = TTButton()
        btn.image = #imageLiteral(resourceName: "close")
        
        btn.callback = {()->Void in
            self.close()
        }
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var deleteBtn: TTButton = {
        let btn = TTButton()
        btn.image = #imageLiteral(resourceName: "delete")
        btn.callback = {()->Void in
            self.deleteTurntable()
        }
        self.view.addSubview(btn)
        return btn
    }()
    
    
    lazy var doneBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Util.editBtnColor
        btn.setImage(#imageLiteral(resourceName: "save").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.setTitle(Util.locString(str: "save"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    
    
    
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = Util.locString(str: "edit")
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .center
//        title.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
//        title.layer.cornerRadius = 4
        self.view.addSubview(title)
        return title
    }()
    
    
    
    lazy var tableView : UITableView = {
        let tab = UITableView.init(frame: self.view.bounds, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.register(EditCell.self, forCellReuseIdentifier: "EditCell")
        tab.register(EditTitleCell.self, forCellReuseIdentifier: "EditTitleCell")
        tab.register(EditHeader.self, forHeaderFooterViewReuseIdentifier: "EditHeader")
        tab.register(EditFooter.self, forHeaderFooterViewReuseIdentifier: "EditFooter")
        tab.backgroundColor = Util.editTableViewBgColor
        tab.separatorStyle = .none
        tab.estimatedSectionFooterHeight = 0
        tab.estimatedSectionHeaderHeight = 0
        tab.allowsSelection = false
//        tab.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
//                tab.sectionFooterHeight = 5
//                tab.sectionHeaderHeight = 5
//        self.automaticallyAdjustsScrollViewInsets = false
        
        var footer : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 45))
//        var footerBtn : UIButton = UIButton.init(type: .custom)
////        footerBtn.layer.cornerRadius = 4
////        footerBtn.frame = CGRect.init(x: 15, y: 15, width: footer.bounds.width-30, height: 45)
//        footerBtn.frame = CGRect.init(x: 0, y: 0, width: 141, height: footer.bounds.height)
//        footerBtn.backgroundColor = UIColor.init(red: 0.31, green: 0.39, blue: 0.41, alpha: 1)
//        footerBtn.setTitle("导入", for: .normal)
//        footerBtn.addTarget(self, action: #selector(importItem), for: .touchUpInside)
//        footerBtn.layer.borderColor = UIColor.white.cgColor
//        footerBtn.layer.borderWidth = 1
//        footerBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        footer.addSubview(footerBtn)
//
//        var importBtn : UIButton = UIButton.init(type: .custom)
//        //        footerBtn.layer.cornerRadius = 4
//        //        footerBtn.frame = CGRect.init(x: 15, y: 15, width: footer.bounds.width-30, height: 45)
//        importBtn.frame = CGRect.init(x: 140, y: 0, width: footer.bounds.width-140, height: footer.bounds.height)
//        importBtn.backgroundColor = UIColor.init(red: 0.31, green: 0.39, blue: 0.41, alpha: 1)
//        importBtn.setTitle("+", for: .normal)
//        importBtn.addTarget(self, action: #selector(addPie), for: .touchUpInside)
//        importBtn.layer.borderColor = UIColor.white.cgColor
//        importBtn.layer.borderWidth = 1
//        importBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
//        footer.addSubview(importBtn)
        
        
        
        tab.tableFooterView = footer
        
        
        
        self.view.addSubview(tab)
        return tab
    }()
//MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.isEdit){
            self.turntable = currentTurntable.tCopy() as! Turntable
        }else{
            self.turntable = Turntable.init(title: "")
            self.turntable.pies = []
        }
        self.view.backgroundColor = Util.editTableViewBgColor
        self.view.clipsToBounds = true
        

        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(self.doneBtn.snp.top).offset(-20)
            make.top.equalTo(54+Util.topPadding)
        }
        
        closeBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.height.equalTo(40)
        })
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.closeBtn.snp.right).offset(20)
            make.right.equalTo(self.deleteBtn.snp.left).offset(-20)
            make.centerY.equalTo(self.closeBtn)
            make.height.equalTo(36)
        }
        doneBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-20)
            make.left.equalTo(20)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
    }
    func loadTurnTableData(){
        
    }
//MARK: Actions
    @objc func importItem(){
        let importVC : ImportViewController = ImportViewController()
        importVC.importAction = { (items:[NSString]) in
            for item in items{
                self.turntable.pies.append(PiePart.init(title: item, weight: 1, color: .red))
            }
            self.tableView.reloadData()
        }
        self.present(importVC, animated: true) {
            
        }
    }
    @objc private func close(){
        
        
        
        self.dismiss(animated: true) {
            
        }
    }
    @objc private func done(){
        
        
        
        
        if self.isEdit {//编辑
            
            selectedTurntable = self.turntable.tCopy() as! Turntable
            try! dbQueue.inTransaction { db in
                
                try self.turntable.update(db)
                //删除当前转盘所有项
                
                try db.execute("DELETE FROM pie WHERE pieid = ?", arguments: [self.turntable.id])
//                try PiePart.deleteAll(db, keys: [["pieid":self.turntable.id],])
                //插入所有项
                for pie in self.turntable.pies{
                    pie.pieid = self.turntable.id
                    try pie.insert(db)
                }
                
                return .commit
            }
            
            (UIApplication.shared.delegate as! AppDelegate).reloadTurntableList()
            
        }else{//新建
            
            
//            selectedTurntable = self.turntable.tCopy() as! Turntable
            
            try! dbQueue.inTransaction { db in
                //插入新转盘
                try self.turntable.insert(db)
                
                //查找刚刚插入的数据
                let statement = try db.makeSelectStatement("SELECT * FROM turntable order by id DESC")
                let current : Turntable = (try Turntable.fetchOne(statement))!
                
                //插入所有项
                for pie in self.turntable.pies{
                    pie.pieid = current.id
                    try pie.insert(db)
                }
                self.turntable.id = current.id
                
//                currentTurntable = self.turntable
                
                return .commit
            }
            selectedTurntable = self.turntable.tCopy() as! Turntable
            (UIApplication.shared.delegate as! AppDelegate).reloadTurntableList()
            
            
        }
        
        self.dismiss(animated: true) {
            
            
            
            
        }
    }
    
    @objc func addPie(){
        self.turntable.pies.append(PiePart.init(title: "", weight: 1, color:.red))
        self.tableView.reloadData()
    }
    @objc func deleteTurntable(){
        
        let alert : AlertVC =  AlertVC()
        self.definesPresentationContext = true
        
        alert.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        alert.modalPresentationStyle = .overCurrentContext
        

        
        alert.alertContent = Util.locString(str: "deletedetail")
        alert.alertTitle = Util.locString(str: "delete")
        alert.okAction = { ()->Void in
            if (self.turntable.id != nil) {
                
                try! dbQueue.inTransaction { db in
                    
                    
                    
                    try db.execute("DELETE FROM pie WHERE pieid = ?", arguments: [self.turntable.id])
                    try db.execute("DELETE FROM turntable WHERE id = ?", arguments: [self.turntable.id])
                    
                    
                    return .commit
                }
            }else{
                
            }
            
            (UIApplication.shared.delegate as! AppDelegate).reloadAllData()
            self.dismiss(animated: false) {
            }
        }
        self.present(alert, animated: false) {
            alert.showAnimation()
        }
        
        
        
        
    }
    
    

}











// MARK: TableView Delegate
extension EditViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return turntable.pies.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 45
        }
        return 60
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let CellID : String = "EditTitleCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! EditTitleCell
            cell.titleTf.text = self.turntable.title! as String
            cell.titleChanged = { (title:NSString) -> Void in
                self.turntable.title = title
            }
            
            return cell
        }else{
            let CellID : String = "EditCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! EditCell
            cell.backgroundColor = (indexPath.row % 2 == 0)  ? Util.editDarkRowColor : Util.editRowColor
            
            
            cell.titleChanged = {(title : NSString)-> Void in
                self.turntable.pies[indexPath.row].title = title
            }
            cell.weight = turntable.pies[indexPath.row].weight
            cell.subBtn.callback = {()->Void in
                cell.weight = self.turntable.pies[indexPath.row].weight - 1
                self.turntable.pies[indexPath.row].weight = cell.weight
            }
            cell.plusBtn.callback = {()->Void in
                cell.weight = self.turntable.pies[indexPath.row].weight + 1
                self.turntable.pies[indexPath.row].weight = cell.weight
            }
            
            
            
//            cell.colorView.backgroundColor = turntable.pies[indexPath.row].color
            
            cell.titleTf.text = turntable.pies[indexPath.row].title  as String
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            turntable.pies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return Util.locString(str: "delete")
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerID : String = "EditHeader"
        let header : EditHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! EditHeader
        
//        header.backgroundColor = .clear
        if section == 0 {
            header.titleLabel.text = "    " + Util.locString(str: "title")
        }else{
            header.titleLabel.text = "    " + Util.locString(str: "item")
        }
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerID : String = "EditFooter"
        let footer : EditFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerID) as! EditFooter
        
        
        footer.importAction =  {() -> Void in
            self.importItem()
        }
        footer.addAction =  {() -> Void in
            self.addPie()
        }
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
}
