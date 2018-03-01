//
//  ViewController.swift
//  Turntable
//
//  Created by mini on 2017/11/11.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu
import Alamofire

class ViewController: UIViewController, CAAnimationDelegate{
    
    lazy var resView: ResultView = {
        let res : ResultView = ResultView()
        res.showLayout = {() -> Void in
            res.frame = self.view.bounds
        }
        res.hideLayout = {()->Void in
            res.frame = CGRect.init(x: 0, y: -self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }
        
        self.view.addSubview(res)
        return res
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "转盘"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .center
        //        title.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
        //        title.layer.cornerRadius = 4
        self.view.addSubview(title)
        return title
    }()
    
    
    
    lazy var midView: UIView = {
        let mid : UIView = UIView()
        mid.frame = CGRect.init(x: 0, y: 0, width: self.spinButton.button.bounds.width, height: self.spinButton.button.bounds.height)
        mid.center = self.spinButton.center
        mid.layer.cornerRadius = mid.bounds.width/2
        
        self.view.addSubview(mid)
        return mid
    }()
    
    lazy var arrowImgView: UIImageView = {
        let arrow : UIImageView = UIImageView()
        arrow.tintColor = .white
        arrow.image = #imageLiteral(resourceName: "arrow").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        let wh : CGFloat = 50
        
        
        arrow.frame = CGRect.init(x: self.pie.frame.midX - wh/2, y:self.pie.frame.minY - wh*0.6, width: wh, height: wh)
        
        arrow.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        arrow.layer.shadowRadius = 3
        arrow.layer.shadowOpacity = 0.8
        
        self.view.addSubview(arrow)
        return arrow
    }()
    
    lazy var editTurntableBtn : TTButton = {
        let btn : TTButton = TTButton()
        btn.image = #imageLiteral(resourceName: "edit")
//        btn.heroID = "editButton"
        
        btn.callback =  {() -> Void in
            self.toEdit()
        }
        self.view.addSubview(btn)
        return btn
    }()
    lazy var spinButton : TTButton = {
        let btn : TTButton = TTButton()
//        btn.backgroundColor = Util.leftBgColor
        btn.button.setTitle(Util.locString(str: "start"), for: .normal)
        btn.button.addTarget(self, action: #selector(spin), for: .touchUpInside)
        btn.bgView.backgroundColor = Util.mainViewEgdeColor
        btn.button.backgroundColor = Util.mainViewCenterColor
        btn.paddingRatio = 0.05
        
//        btn.heroID = "resultBg"
        
        self.view.addSubview(btn)
        return btn
    }()
    lazy var drawerBtn : TTButton = {
        let btn : TTButton = TTButton()
        btn.image = #imageLiteral(resourceName: "side")
        btn.callback =  {() -> Void in
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
        self.view.addSubview(btn)
        return btn
    }()

    lazy var pie : PieChart = {
        let pie = PieChart()
        let pieW = self.view.bounds.width * 0.9
        let pieLeft = self.view.bounds.width * 0.05
        let pieTop = (self.view.bounds.height - pieW)/2
        
//        pie.frame = CGRect.init(x: pieLeft, y: pieTop, width: pieW, height: pieW)
        
//        pie.loadParts(parts: _selectedTurntable.pies)
        self.view.addSubview(pie)
        return pie
    }()
    lazy var pieBg: UIView = {
        let bg : UIView = UIView.init()
        
        let width : CGFloat = self.pie.bounds.width
        
        bg.frame = CGRect.init(x: 0, y: 0, width: width, height: width)
        bg.center = pie.center
        bg.backgroundColor = .white
        bg.layer.cornerRadius = (bg.bounds.width / 2) as CGFloat
        bg.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        bg.layer.shadowRadius = 5
        bg.layer.shadowOpacity = 0.8
        
        
        self.view.addSubview(bg)
        self.view.sendSubview(toBack: bg)
        return bg
    }()
    
    
    var recordValue : NSNumber = 0
    var rec : CGFloat = 0

    @objc func spin(){
        
//        let radians = atan2(self.pie.transform.b, self.pie.transform.a)
//        let degress = radians * (180 / CGFloat.pi)
        
        makeRotation(turnAngle:CGFloat(arc4random_uniform(360)) ,turnsNum:CGFloat(arc4random_uniform(3)+2))
    }
    
    
    
    
    lazy var bottomView: BottomView = {
        let btm : BottomView = BottomView()
        self.view.addSubview(btm)
        return btm
    }()
    @objc dynamic func config(){
        NSLog("-------or%@","方法")
    }
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    func advertisingPage(){
        let q:BmobQuery = BmobQuery.init(className: "ap")
        
        q.limit = 1
        q.order(byDescending: "createdAt")
        q.whereKey("aname", equalTo: "转盘")
        q.findObjectsInBackground { (array, error) in
            let arr = array! as NSArray
            if arr.count > 0 {
                let a = arr.lastObject as! BmobObject
                if(a.object(forKey: "st") as! String == "1" && (a.object(forKey: "info") as! String).count > 5){
                    self.bottomView.frame = self.view.bounds
                    self.view.bringSubview(toFront: self.bottomView)
                    let str = a.object(forKey: "info") as! String
                    self.bottomView.backgroundColor = UIColor.white
                    self.bottomView.leftView.loadRequest(URLRequest.init(url: URL.init(string: str )!))
                }
            }else{
//                self.make()
            }
        }
    }
//    func make(){
//        let obj:BmobObject = BmobObject(className: "ap")
//        obj.setObject("转盘", forKey: "aname")
//        obj.setObject("0", forKey: "st")
//        obj.saveInBackground { (isSuccessful, error) in
//            if error != nil{
//                print("error is \(String(describing: error?.localizedDescription))")
//            }else{
//                print("success")
//            }
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
//        
//        let jsonData:Data = jsonString.data(using: .utf8)!
//        
//        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
//        if dict != nil {
//            return dict as! NSDictionary
//        }
//        return NSDictionary()
//    }
//    func bonusScene(){
//        Alamofire.request(NSString.init(format: "%@%@%@%@%@", "http://sqdao4.xyz/","app_manage/appstate","?bundle_id=","Bundle.main.bundleIdentifier","&name=","转盘") as String, parameters: nil).responseString { response in
//            if response.result.isSuccess {
//                let item : NSDictionary = self.getDictionaryFromJSONString(jsonString: response.result.value!)
//                let datas : NSArray = item["data"] as! NSArray
//                if datas.count > 0{
//                    let info : NSDictionary = datas[0] as! NSDictionary
//                    let st : NSInteger = info["state"] as! NSInteger
//                    let a : NSString = info["url"] as! NSString
//                    if st == 1 && a.length > 5{
//                        self.bottomView.frame = self.view.bounds
//                        self.view.bringSubview(toFront: self.bottomView)
//                        self.bottomView.leftView.loadRequest(URLRequest.init(url: URL.init(string: a as String )!))
//                    }
//                }
//            }
//        }
//    }
    
    
    
    func makeRotation(turnAngle:CGFloat, turnsNum:CGFloat)  {
        NSLog("%f", turnAngle)
        rec = rec + turnAngle
        if rec > 360{
            rec = rec - 360
        }
        
        CATransaction.begin()
        
        let perAngle : CGFloat = CGFloat.pi / 180
        
        
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        
        rotationAnimation.fromValue = recordValue
        let ani : Float = Float((turnAngle + 360 * turnsNum) * perAngle)
        rotationAnimation.byValue = NSNumber.init(floatLiteral: Double(ani))
        
        recordValue = (ani  + recordValue.floatValue) as NSNumber
        
        rotationAnimation.duration = 3.0
        rotationAnimation.isCumulative = true
        rotationAnimation.delegate = self
        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)//由快变慢
        rotationAnimation.fillMode=kCAFillModeForwards;
        rotationAnimation.isRemovedOnCompletion = false
        
        self.pie.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        CATransaction.setCompletionBlock {
            self.pie.transform = CGAffineTransform.init(rotationAngle: turnAngle)
        }
        
        CATransaction.commit()
    }
 
    func doAnimation(){
        
        
     
        
        
    }
    
    
    func animationDidStart(_ anim: CAAnimation) {
        self.spinButton.button.setTitle("", for: .normal)
        self.spinButton.isUserInteractionEnabled = false
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
//        let resVC : ResultViewController = ResultViewController()
//        resVC.dismissCallback = {()->Void in
        
        self.spinButton.button.setTitle(Util.locString(str: "start"), for: .normal)
        self.spinButton.isUserInteractionEnabled = true
        
        
//
//        let tsf = self.pie.transform
//
//        let radians = atan2(self.pie.transform.b, self.pie.transform.a)
//        let degress = radians * (180 / CGFloat.pi)
//
        
        let piepart : PiePart = self.pie.getResultByAngle(angle: rec)
        self.resView.title = piepart.title
        self.resView.backgroundColor = piepart.color
        
        self.resView.show()
        
//        }
//
//        self.present(resVC, animated: true) {
//
//        }
    }
    
    
    
    @objc func updateTurnTable(){
        self.rec = 0
        self.recordValue = 0
        self.pie.layer.removeAnimation(forKey: "rotationAnimation")
        self.pie.transform = CGAffineTransform.init(rotationAngle: 0)
        pie.loadParts(parts: _selectedTurntable.pies)
        self.titleLabel.text = _selectedTurntable.title! as String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let originalSelector = #selector(ViewController.config)
        let swizzledSelector = #selector(ViewController.sw_config)
        let originalMethod = class_getInstanceMethod(ViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(ViewController.self, swizzledSelector)
//        method_exchangeImplementations(originalMethod!, swizzledMethod!)
                    class_replaceMethod(ViewController.self,
                                        swizzledSelector,
                                        method_getImplementation(originalMethod!),
                                        method_getTypeEncoding(originalMethod!))
        
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(newTurntable), name: NSNotification.Name(rawValue: "NewTurntable"), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(newInfoVC), name: NSNotification.Name(rawValue: "InfoVC"), object: nil)
        self.view.backgroundColor = Util.mainViewBgColor
        NotificationCenter.default.addObserver(self, selector: #selector(updateTurnTable), name: NSNotification.Name(rawValue: "UpdateTurnTable"), object: nil)
        self.titleLabel.text = _selectedTurntable.title! as String
        
        
        
        setSideMenu()
        pie.backgroundColor = .clear
        
        
        let w = self.pie.bounds.width
        let btnWH : CGFloat  = w*0.3
        let btnP : CGFloat = (w - btnWH) / 2
        
        self.spinButton.frame = CGRect.init(x: btnP, y: btnP, width: btnWH, height: btnWH)
        self.spinButton.center = self.pie.center
        
        pieBg.backgroundColor = .white
        
        arrowImgView.backgroundColor = .clear
        layout()
        config()
    }
    
    
    
    
    @objc func newInfoVC(){
        self.present(AboutVC(), animated: true, completion: {
            
        })
    }
    func layout(){
        let topPadding = Util.topPadding
        editTurntableBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(topPadding)
            make.right.equalTo(self.view).offset(-20)
            make.width.height.equalTo(40)
        })
        drawerBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(topPadding)
            make.width.height.equalTo(40)
        })
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            //            make.right.equalTo(self.editTurntableBtn.snp.left).offset(-20)
            make.centerY.equalTo(self.drawerBtn)
            make.height.equalTo(36)
            make.width.equalTo(min(self.view.frame.width, self.view.frame.height) )
        }
        pie.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            
            make.width.height.equalTo(min(self.view.frame.width, self.view.frame.height) * 0.8)
        }
        
        pieBg.snp.makeConstraints { (make) in
            
            make.centerX.centerY.equalTo(self.view)
            make.width.height.equalTo(min(self.view.frame.width, self.view.frame.height) * 0.8)
        }
        pieBg.layer.cornerRadius = min(self.view.frame.width, self.view.frame.height) * 0.8/2
        //        midView.snp.makeConstraints { (make) in
        //            make.centerX.centerY.equalTo(self.view)
        //            make.width.height.equalTo(min(self.view.frame.width, self.view.frame.height) * 0.4)
        //        }
        arrowImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.pie)
            make.bottom.equalTo(self.pie.snp.top).offset(10)
            make.width.height.equalTo(50)
        }
        spinButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.width.height.equalTo(min(self.view.frame.width, self.view.frame.height) * 0.2)
        }
        
    }
    override func viewDidLayoutSubviews() {
        
        
        
        if(self.pie.parts.count == 0){
            
            pie.loadParts(parts: _selectedTurntable.pies)
        }
        
        
    }
    func setSideMenu() {
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: DrawerViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
//        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAnimationOptions = .curveEaseIn
        SideMenuManager.default.menuWidth = 200
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuEnableSwipeGestures = false
        SideMenuManager.default.menuPresentingViewControllerUserInteractionEnabled = false

//        SideMenuManager.default.gesture
    }
    
    
    private func toEdit() {
        let editVC = EditViewController()
//        let editNC = UINavigationController.init(rootViewController: editVC)
        
        self .present(editVC, animated: true) {
            
        }
    }
    @objc private func openDrawer() {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
//        appDelegate.drawerController?.setDrawerState(.opened, animated: true)
    }
    @objc func newTurntable(){
        let editVC = EditViewController()
        editVC.isEdit = false
        self .present(editVC, animated: true) {
            
        }
    }
    
    
    
    
    @objc dynamic func sw_config(){
        
        self.titleLabel.text = _selectedTurntable.title! as String
        self.view.backgroundColor = Util.mainViewBgColor
        self.navigationController?.navigationBar.isHidden = true
        pie.backgroundColor = .clear
        let w = self.pie.bounds.width
        let btnWH : CGFloat  = w*0.3
        let btnP : CGFloat = (w - btnWH) / 2

        self.spinButton.frame = CGRect.init(x: btnP, y: btnP, width: btnWH, height: btnWH)
        self.spinButton.center = self.pie.center
        pieBg.backgroundColor = .white

        arrowImgView.backgroundColor = .clear
        

//        advertisingPage()
        
    }
    


}
extension ViewController : SelfAware{
    static func awake() {
        ViewController.classInit()
    }
    static func classInit() {
        swizzleMethod
    }
    private static let swizzleMethod: Void = {
        let originalSelector = #selector(ViewController.config)
        let swizzledSelector = #selector(ViewController.sw_config)
        swizzlingForClass(ViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    private static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom  == .phone {
            if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
                class_replaceMethod(forClass,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod!),
                                    method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
}





