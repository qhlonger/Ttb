//
//  ImportViewController.swift
//  Turntable
//
//  Created by mini on 2017/11/17.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {

    var truthItems : [NSString] = []
    var advItems : [NSString] = []
    var selItems : [NSString] = []
    var cusrItems : [NSString] = []
    
    
    
    var importAction : (([NSString]) -> Void)!
    
    var isChinaVersion : Bool = true
    
    lazy var segment: UISegmentedControl = {
        
        var items : [String] = [Util.locString(str: "selecteditem"),Util.locString(str: "truth"),Util.locString(str: "dare"),Util.locString(str: "isusing")]
        if !isChinaVersion {
            items = [Util.locString(str: "selecteditem"),Util.locString(str: "isusing")]
        }
        let seg : UISegmentedControl = UISegmentedControl.init(items:items)
        seg.addTarget(self, action: #selector(segClick(seg:)), for: .valueChanged)
        seg.tintColor = .white
        seg.selectedSegmentIndex  = 1
        self.view.addSubview(seg)
        return seg
    }()
    
    lazy var closeBtn: TTButton = {
        let btn = TTButton()
        btn.image =  #imageLiteral(resourceName: "close")
        btn.callback = {()->Void in
            self.close()
        }
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var shuffleBtn: TTButton = {
        let btn = TTButton()
        btn.image =  #imageLiteral(resourceName: "shuffle")
        btn.callback = {()->Void in
            self.shuffle()
        }
        self.view.addSubview(btn)
        return btn
    }()
    
    
    lazy var doneBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Util.editBtnColor
        btn.setImage(#imageLiteral(resourceName: "import").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.setTitle(Util.locString(str: "import"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var tableView : UITableView = {
        let tab = UITableView.init(frame: self.view.bounds, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        tab.backgroundColor = Util.editTableViewBgColor
        tab.separatorStyle = .none
        tab.estimatedSectionFooterHeight = 0
        tab.estimatedSectionHeaderHeight = 0
//        tab.allowsSelection = false
//        tab.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)

        
        
        
        
        
        self.view.addSubview(tab)
        return tab
    }()
    
    
    func getShuffleTruth() {
        
        var items : [NSString] = []
        try! dbQueue.inTransaction { db in
            let statement = try db.makeSelectStatement("SELECT * FROM importitem WHERE type = 1 ORDER BY RANDOM() LIMIT 20")
            let randomItems : [ImportItem] = (try ImportItem.fetchAll(statement))
            
            
            for item in randomItems{
                items.append(item.title)
            }
            
            return .commit
        }
        self.truthItems = items
        if(self.segment.selectedSegmentIndex == 1){
            tableView.reloadData()
        }
        
    }
    
    func getShuffleAdv() {
        var items : [NSString] = []
        try! dbQueue.inTransaction { db in
            let statement = try db.makeSelectStatement("SELECT * FROM importitem WHERE type = 2 ORDER BY RANDOM() LIMIT 20")
            let randomItems : [ImportItem] = (try ImportItem.fetchAll(statement))
            
            
            for item in randomItems{
                items.append(item.title)
            }
            
            return .commit
        }
        self.advItems = items
        if(self.segment.selectedSegmentIndex == 2){
            tableView.reloadData()
        }
    }
    func getAllUsedItem(){
        var items : [NSString] = []
        try! dbQueue.inTransaction { db in
            let statement = try db.makeSelectStatement("SELECT * FROM pie")
            let randomItems : [PiePart] = (try PiePart.fetchAll(statement))
            
            
            for item in randomItems{
                items.append(item.title)
            }
            
            return .commit
        }
        self.cusrItems = items
        if(self.segment.selectedSegmentIndex == 3){
            tableView.reloadData()
        }
    }
    
    func shuffle(){
        switch segment.selectedSegmentIndex {
        case 0:
            
            break
        case 1:
            getShuffleTruth()
            break
        case 2:
            getShuffleAdv()
            break
        case 3:
            
            break
        default:
            break
        }
    }
    func close(){
        self.dismiss(animated: true) {
            
        }
    }
    @objc func done(){
        if (importAction != nil) {
            importAction(self.selItems)
        }
        self.dismiss(animated: true) {
            
        }
    }
    @objc func segClick(seg:UISegmentedControl){
        self.tableView.reloadData()
        
        switch segment.selectedSegmentIndex {
        case 0:
            shuffleBtn.isHidden = true
            break
        case 1:
            shuffleBtn.isHidden = false
            break
        case 2:
            shuffleBtn.isHidden = false
            break
        case 3:
            shuffleBtn.isHidden = true
            break
        default:
            break
        }
    }
    func doAnimation(indexPath:IndexPath){
        let cell : ItemCell = tableView.cellForRow(at: indexPath) as! ItemCell
        
        let imageRet : UIImage
        UIGraphicsBeginImageContextWithOptions(cell.frame.size, false, 0.0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        imageRet = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let rectInTableView : CGRect = tableView.rectForRow(at: indexPath)
        
        let rect : CGRect = tableView.convert(rectInTableView, to: self.view)
        
        
        
        
        let screenShotView : UIImageView = UIImageView.init(frame: rect)
        screenShotView.image = imageRet
        self.view.addSubview(screenShotView)
        
        
        let segW : CGFloat =  segment.bounds.width / (isChinaVersion ? 4 : 2)
        let finalH : CGFloat = segW / (rect.width / rect.height)
        
        
//        UIView.animate(withDuration: 0.5, animations: {
//            screenShotView.frame = CGRect.init(x: self.segment.frame.minX, y: self.segment.frame.minY-finalH/2, width: self.segment.frame.width/4, height: finalH)
//            screenShotView.alpha = 0.4
//        }) { (comp) in
//            screenShotView.removeFromSuperview()
//        }
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            screenShotView.frame = CGRect.init(x: self.segment.frame.minX, y: self.segment.frame.midY-finalH/2, width: segW, height: finalH)
            screenShotView.alpha = 0.4
        }) { (comp) in
            screenShotView.removeFromSuperview()
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isChinaVersion = Util.locString(str: "start") == "开始"
    
        
        self.view.backgroundColor = Util.editTableViewBgColor
        
        getShuffleTruth()
        getShuffleAdv()
        getAllUsedItem()
        self.tableView.reloadData()
        
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
        shuffleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.height.equalTo(40)
        }
        segment.snp.makeConstraints { (make) in
            make.left.equalTo(self.closeBtn.snp.right).offset(20)
            make.right.equalTo(self.shuffleBtn.snp.left).offset(-20)
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
    

}


// MARK: TableView Delegate
extension ImportViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isChinaVersion {
            switch segment.selectedSegmentIndex {
            case 0:
                return self.selItems.count
            case 1:
                return self.truthItems.count
            case 2:
                return self.advItems.count
            case 3:
                return self.cusrItems.count
            default:
                return 0
            }
        }else{
            switch segment.selectedSegmentIndex {
            case 0:
                return self.selItems.count
            case 1:
                return self.cusrItems.count
            default:
                return 0
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.titleLabel.textColor = .white
        cell.backgroundColor = (indexPath.row % 2 == 0)  ? Util.editDarkRowColor : Util.editRowColor
        
        if isChinaVersion {
            switch segment.selectedSegmentIndex {
            case 0:
                cell.titleLabel.text = self.selItems[indexPath.row] as String
                break
            case 1:
                cell.titleLabel.text = self.truthItems[indexPath.row] as String
                break
            case 2:
                cell.titleLabel.text = self.advItems[indexPath.row] as String
                break
            case 3:
                cell.titleLabel.text = self.cusrItems[indexPath.row] as String
                break
            default:
                break
            }
        }else{
            switch segment.selectedSegmentIndex {
            case 0:
                cell.titleLabel.text = self.selItems[indexPath.row] as String
                break
            case 1:
                cell.titleLabel.text = self.cusrItems[indexPath.row] as String
                break
            default:
                break
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if isChinaVersion {
            switch segment.selectedSegmentIndex {
            case 0:
                self.selItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                break
            case 1:
                self.selItems.append(self.truthItems[indexPath.row])
                doAnimation(indexPath: indexPath)
                break
            case 2:
                self.selItems.append(self.advItems[indexPath.row])
                doAnimation(indexPath: indexPath)
                break
            case 3:
                self.selItems.append(self.cusrItems[indexPath.row])
                doAnimation(indexPath: indexPath)
                break
            default:
                return
            }
        }else{
            switch segment.selectedSegmentIndex {
            case 0:
                self.selItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                break
            case 1:
                self.selItems.append(self.cusrItems[indexPath.row])
                doAnimation(indexPath: indexPath)
                break
            default:
                return
            }
        }
        
        
        
        
        
        
        
    }
}









