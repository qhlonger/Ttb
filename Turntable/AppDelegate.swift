//
//  AppDelegate.swift
//  Turntable
//
//  Created by mini on 2017/11/11.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GRDB

var dbQueue: DatabaseQueue!

var _allTurntables : [Turntable]!
var allTurntables : [Turntable]!{
    set{
        _allTurntables = newValue
        NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "UpdateTurnTable"), object: nil, userInfo: nil) as Notification)
    }
    get{
        return _allTurntables
    }
}

var _currentTurntable : Turntable!
var currentTurntable : Turntable!{
    set{
        _currentTurntable = newValue
    }
    get{
        return _currentTurntable
    }
}

var _selectedTurntable : Turntable!
var selectedTurntable : Turntable!{
    set{
        _selectedTurntable = newValue
        _currentTurntable = newValue
        NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "UpdateTurnTable"), object: nil, userInfo: nil) as Notification)
    }
    get{
        return _selectedTurntable
    }
}



@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //增加IOS 7的支持
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //可选
        NSLog("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func setupJpush() {
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                      categories: nil)
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }else {
            //categories 必须为nil
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue,
                                  categories: nil)
        }
        // 启动JPushSDK
        JPUSHService.setup(withOption: nil, appKey: "029a0fbb7f4c083c7f0f77be",
                           channel: "Publish Channel", apsForProduction: false)
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        
        try! setupDatabase(application)
        
        
        let nav = UINavigationController.init(rootViewController: ViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        
        
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().canAdjustAdditionalSafeAreaInsets = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 80
        
        
        Bmob.register(withAppKey: "306fec5898fff849f93f1c887dab0466")
        
        setupJpush()
        
        
        return true
    }
    private func setupDatabase(_ application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        dbQueue = try AppDatabase.openDatabase(atPath: databaseURL.path)
        
        // Be a nice iOS citizen, and don't consume too much memory
        // See https://github.com/groue/GRDB.swift/#memory-management
        dbQueue.setupMemoryManagement(in: application)
        
        reloadAllData()
    }
    

    
    func refreshTurntables(){
        try! dbQueue.inTransaction { db in
            let turns:[Turntable] = try Turntable.fetchAll(db)
            for turn in turns{
                let statement = try db.makeSelectStatement("SELECT * FROM pie WHERE pieid = ?")
                let pies:[PiePart] = try PiePart.fetchAll(statement,arguments: [turn.id])
                turn.pies = pies
            }
            allTurntables = turns
            return .commit
        }
    }
    
    @objc func reloadTurntableList(){
        refreshTurntables()
        
    }
    @objc func reloadAllData(){
        refreshTurntables()
        currentTurntable = allTurntables.first?.tCopy() as! Turntable
        selectedTurntable = allTurntables.first?.tCopy() as! Turntable
        
    }

}


protocol SelfAware: class {
    static func awake()
}
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate(capacity: typeCount)
    }
}
extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}

