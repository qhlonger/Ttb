//
//  Util.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit
import GRDB

class Util: NSObject {
    
    
    
    static var topPadding: CGFloat {
        if isIpX(){
            return 45
        }
        return 30
    }
    static var sideWidth: CGFloat {
        return 200
    }
    static func get16Color(rgb: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    static func locString(str:String) -> String {
        return Bundle.main.localizedString(forKey: str, value: "", table: nil)
    }
    

    
    
    static var mainViewBgColor = Util.get16Color(rgb: 0x31444D)
    static var mainViewBtnColor = Util.get16Color(rgb: 0x19E3D4)
    static var mainViewCenterColor = Util.get16Color(rgb: 0x31444D)
    static var  mainViewEgdeColor = Util.get16Color(rgb: 0xffffff)
    
    
    static var leftBgColor = Util.get16Color(rgb: 0x31444D)
    static var leftTableViewBgColor = Util.get16Color(rgb: 0x31444D)
    static var leftRowColor = Util.get16Color(rgb: 0x35494F)
    static var leftDarkRowColor = Util.get16Color(rgb: 0x25393F)
    static var leftBtnColor = Util.get16Color(rgb: 0x19E3D4)
    static var leftTextColor = Util.get16Color(rgb: 0xffffff)
    
    static var editNavColor = Util.get16Color(rgb: 0x31444D)
    static var editRowColor = Util.get16Color(rgb: 0x31444D)
    static var editDarkRowColor = Util.get16Color(rgb: 0x31444D)
    static var editTableViewBgColor = Util.get16Color(rgb: 0x31444D)
    static var editBtnColor = Util.get16Color(rgb: 0x19E3D4)
    static var editTextColor = Util.get16Color(rgb: 0x000000)
    
    
    
    static func isIpX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    func initDatabase(){
//        let dbQueue = try DatabaseQueue(path:"/data/turntable.sqlite")
//
//
//        try dbQueue.inDatabase({ (db) -> T in
//
//
//
//        })
        
        
//        try dbQueue.inDatabase { db in
//            try db.execute(
//                """
//                    CREATE TABLE pie (
//                    id INTEGER PRIMARY KEY,
//                    title TEXT,
//                    weight FLOAT)
//                """
//            )
//
//            try db.execute(
//                "INSERT INTO pie(title, weight)"
//            )
//
//        }
        
    
        

    }
    
//    func saveTurntable(turntable:[PiePart]){
//        let dbQueue = try DatabaseQueue(path:"/data/turntable.sqlite")
//
//        
//        
//            try dbQueue.inDatabase { db in
//                
//                try db.execute(
//                    "DELETE FROM pie WHERE id = "
//                )
//                
//                for pie in turntable{
//                    try db.execute(
//                        """
//                            INSERT INTO pie(title, weight)
//                            VALUES(?,?)
//                        """,arguments:[pie.title, pie.weight]
//                    )
//                
//                }
//                
//                
////                let
//            }
//        
//    }
    
    
}


protocol Singleton : class {
    static var sharedInstance:Self{get}
}



