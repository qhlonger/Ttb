//
//  PieChart.swift
//  Turntable
//
//  Created by mini on 2017/11/12.
//  Copyright © 2017年 mini. All rights reserved.
//

import UIKit
import GRDB


protocol Copyable {
    func tCopy() -> Copyable
}



class PiePart : Record, Copyable{
    func tCopy() -> Copyable {
        let pie : PiePart = PiePart.init(title: self.title.copy() as! NSString, weight: self.weight, color: self.color.copy() as! UIColor)
        
        return pie
    }
    
    var weight : CGFloat!
    var title : NSString!
    var color : UIColor!
    var id : Int64!
    var pieid : Int64!
//    var percent : CGFloat!
    
    init( pieid:Int64, title:NSString, weight:CGFloat, color:UIColor) {
        self.pieid = pieid
        self.title = title
        self.weight = weight
        self.color = color
        super.init()
    }
    init(title:NSString, weight:CGFloat, color:UIColor) {
        self.title = title
        self.weight = weight
        self.color = color
        super.init()
    }
    override class var databaseTableName: String {
        return "pie"
    }
    required init(row: Row) {
        id = row["id"]
        title = row["title"]
        weight = row["weight"]
        pieid = row["pieid"]
        
        super.init(row:row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["title"] = title
        container["weight"] = weight
        container["pieid"] = pieid
    }
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    private static let names = ["Arthur", "Anita", "Barbara", "Bernard", "Craig", "Chiara", "David", "Dean", "Éric", "Elena", "Fatima", "Frederik", "Gilbert", "Georgette", "Henriette", "Hassan", "Ignacio", "Irene", "Julie", "Jack", "Karl", "Kristel", "Louis", "Liz", "Masashi", "Mary", "Noam", "Nicole", "Ophelie", "Oleg", "Pascal", "Patricia", "Quentin", "Quinn", "Raoul", "Rachel", "Stephan", "Susie", "Tristan", "Tatiana", "Ursule", "Urbain", "Victor", "Violette", "Wilfried", "Wilhelmina", "Yvon", "Yann", "Zazie", "Zoé"]
    
    class func randomName() -> NSString {
        return names[Int(arc4random_uniform(UInt32(names.count)))] as NSString
    }
    
    class func randomWeight() -> CGFloat {
        return CGFloat( Int(arc4random_uniform(10)))
    }
    class func randomID() -> Int64 {
        return Int64(arc4random_uniform(10))
    }
}
class Turntable: Record, Copyable {
    func tCopy() -> Copyable {
        var pies : [PiePart] = []
        for p in self.pies{
            pies.append(p.copy())
        }
        
        let turn : Turntable = Turntable.init(id: self.id, title: self.title.copy() as! NSString, pies:pies )
        return turn
    }
    
    
    
    
    var id : Int64!
    var title : NSString!
    
    var pies : [PiePart]!
    
    init(title:NSString) {
        self.title = title
        super.init()
    }
    
    init(id:Int64, title:NSString) {
        self.id = id
        self.title = title
        super.init()
    }
    init(id:Int64, title:NSString, pies:[PiePart]) {
        self.id = id
        self.title = title
        self.pies = pies
        super.init()
    }
    
    override class var databaseTableName: String {
        return "turntable"
    }
    required init(row: Row) {
        id = row["id"]
        title = row["title"]
        
        
        super.init(row:row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["title"] = title
    }
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    private static let names = ["Arthur", "Anita", "Barbara", "Bernard", "Craig", "Chiara", "David", "Dean", "Éric", "Elena", "Fatima", "Frederik", "Gilbert", "Georgette", "Henriette", "Hassan", "Ignacio", "Irene", "Julie", "Jack", "Karl", "Kristel", "Louis", "Liz", "Masashi", "Mary", "Noam", "Nicole", "Ophelie", "Oleg", "Pascal", "Patricia", "Quentin", "Quinn", "Raoul", "Rachel", "Stephan", "Susie", "Tristan", "Tatiana", "Ursule", "Urbain", "Victor", "Violette", "Wilfried", "Wilhelmina", "Yvon", "Yann", "Zazie", "Zoé"]
    
    class func randomName() -> NSString {
        return names[Int(arc4random_uniform(UInt32(names.count)))] as NSString
    }
}

class ImportItem : Record {
    
    var id : Int64!
    var title : NSString!
    var type : Int64!
    
    
    init( title:NSString, type:Int64) {
        self.title = title
        self.type = type
        super.init()
    }
    init(id:Int64, title:NSString, type:Int64) {
        self.id = id
        self.title = title
        self.type = type
        super.init()
    }
    override class var databaseTableName: String {
        return "importitem"
    }
    required init(row: Row) {
        id = row["id"]
        title = row["title"]
        type = row["type"]
        
        super.init(row:row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["title"] = title
        container["type"] = type
    }
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

class Pie: CAShapeLayer {
    init(center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat, color:UIColor, duration:CFTimeInterval, isAnimate:Bool) {
        super.init()
        
        self.fillColor = color.cgColor
        self.strokeColor = color.cgColor
        let p = UIBezierPath.init(arcCenter: center, radius: radius, startAngle:endAngle , endAngle: startAngle, clockwise: true)
        p.addLine(to: center)
        
        self.path = p.cgPath
        
        
        
        
        
        if isAnimate{
            let fillAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
            fillAnimation.duration = 0.2
            fillAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            fillAnimation.fillMode = kCAFillModeForwards
            fillAnimation.isRemovedOnCompletion = false
            fillAnimation.fromValue = 0
            fillAnimation.toValue = 1
            self.add(fillAnimation, forKey: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PieChart: UIView {

    
    var parts : [PiePart] = []
    
    
    
    var startAngles : [CGFloat] = []
    var centerAngles : [CGFloat] = []
    var endAngles   : [CGFloat] = []
    
    var count : CGFloat!
    var pieCentr : CGPoint!
    var pieRadius : CGFloat!
    var duration : CFTimeInterval!
    
    var countOfWeight : CGFloat!
    var colorChanged : ((_ color:UIColor)->Void)?
    
    
    
    override func layoutSubviews() {
//        let w = self.bounds.width
//        let btnWH : CGFloat  = w*0.3
//        let btnP : CGFloat = (w - btnWH) / 2
//        
//        
//        self.backgroundColor = .white
//        self.layer.cornerRadius = self.bounds.width / 2
//        self.layer.shadowOffset = CGSize.init(width: 3, height: 3)
//        self.layer.shadowRadius = 5
//        self.layer.shadowOpacity = 0.8
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addObserver(self, forKeyPath: "tansform", options: .new, context: nil)
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "transform" {
            doChangeColor()
        }
    }
    func doChangeColor()  {
        self.colorChanged!(self.getCurrentColor())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func removeAllShaper() {
        if self.startAngles.count != 0 {self.startAngles.removeAll()}
        if self.endAngles.count != 0 {self.endAngles.removeAll()}
        if self.centerAngles.count != 0 {self.centerAngles.removeAll()}
        if self.parts.count != 0 {self.parts.removeAll()}
        
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        self.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
    }
    
    func loadParts(parts:[PiePart]) {
        removeAllShaper()
        
        
        
//        let colors : [UIColor] = [.red, .cyan, .orange]
        
//        var i = 0
        for part in parts{
            
//            let colori = i % colors.count
            part.color = getRandomColor() //colors[colori]
//            i = i + 1
        }
        
        self.parts = parts
        initVars()
        addPieLayer()
        addText()
    }
    
    let colors = [  0x78C2C3, 0x78C2C3, 0xF96D00 ,0x40A798 ,
                    0xDF654A ,0xCC376D ,0xF75940 ,0xF7B633 ,
                    0xEE046C ,0x8AAE92 ,0x78C2C3 ,0xE46161 ,
                    0xE9007F ,0xEF7E56 ,0x259F6C ,0x3DC7BE ,
                    0x0FC9E7 ,0xCBF078 ,0xFFCD00 ,0xF54D42 ,
                    0x7CDFFF ,0x02C39A ,0x00DBE7 ,0x01AAC1 ,
                    0x43DDE6 ,0xFC5185 ,0xB04D5D ,0x40A798 ,
                    0xFFE037 ,0x1DCD9F ,0xFF395E ,0xC7E78B ,
                    0x709053 ,0xFF007B ,0xFACC2E ,0x27B1BE ,
                    0x1E56A0 ,0xFF007B ,0xFF8585 ,0xFCC314 ,
                    0x09A8FA ,0xBCFCC9 ,0x2EB872 ,0xF03861 ,
                    0xFC3A52 ,0x0E2431 ,0x2CA4BF ,0x415B90 ,
                    0xA6E4E7 ,0xA7D46F ,0xC4AFF0 ,0xDD105E ,
                    0x85FEDE ,0xFC5C9C ,0xA6ED8E ,0x28CC9E ,
                    0x0245A3 ,0x22EAAA ,0x86A6DF ,0x5068A9 ,
                    0xA0E418 ,0x40A798 ,0xA3DE83 ,0x09A599 ,
//        0x ,0x ,0x ,0x ,
        
                  ]
    func getRandomColor() -> UIColor {
//        let r : NSInteger = NSInteger(arc4random_uniform(150)+50)
//        let gb : NSInteger = 255 - r
//        let g : NSInteger = NSInteger(arc4random_uniform(UInt32(gb)))
//        let b : NSInteger = 255 - r - g
//
        
        let idx = NSNumber.init(value: colors.count - 1)
        let rgb = colors[Int(arc4random_uniform(idx.uint32Value))]
        
        
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
        
    }
    
    func initVars(){
        
        
        
        countOfWeight = 0
        for i in parts {
            countOfWeight = countOfWeight + i.weight
        }
        startAngles = []
        endAngles = []
        centerAngles = []
        duration = 0.2
        
        var angle = CGFloat.pi * 2
        
        for i in 0..<self.parts.count {
            startAngles.append(angle)
            
            //单份所占弧度
            let singleAngle = self.parts[i].weight / countOfWeight *  CGFloat.pi * 2
            centerAngles.append(angle-singleAngle/2)
            
            angle = angle - singleAngle
            endAngles.append(angle)
        }
    }
    
    
    func addPieLayer() {
        for i in 0..<self.parts.count {
            let pie : Pie = Pie.init(center: CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2),
                                     radius: self.bounds.width * 0.48,
                                     startAngle: startAngles[i],
                                     endAngle: endAngles[i],
                                     color: parts[i].color,
                                     duration: duration,
                                     isAnimate: true)
            self.layer.addSublayer(pie)
            
            
            
        }
        
    }
    func addText() {
        let labelW : CGFloat = 20
        let labelH : CGFloat = self.bounds.height * 0.45
//        let labelY : CGFloat = self.bounds.height * 0.05
//        let labelX : CGFloat = self.bounds.width * 0.5 - labelW/2
        
        for i in 0..<self.parts.count {
            
            let label = getLabel()
            
            label.text = self.parts[i].title! as String + "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
            NSLog(label.text!)
            
            label.layer.position = CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2)
            label.bounds = CGRect.init(x:0, y: 0, width: labelW, height: labelH)
            
            
            
            label.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
            label.transform = CGAffineTransform.init(rotationAngle: centerAngles[i] + 0.25 * CGFloat.pi * 2)
            
            if parts[i].weight / countOfWeight > 0.05 {
                self.addSubview(label)
            }
        }
    }
    
    func getCurrentColor() ->UIColor {
        let radius : CGFloat = CGFloat(atan2f(Float(self.transform.b), Float(self.transform.a)))
        let degree : CGFloat = radius * (180 / CGFloat.pi)
        for _ in 0..<self.startAngles.count{
            
            
        }
        return .white
    }
    
    func getLabel() -> UILabel {
        let label : UILabel = UILabel()
        label.layer.shadowOpacity = 0.8
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        label.layer.shadowRadius = 3
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
        
    }
    
    func addStartButton() {
        
    }
    func getResultByAngle(angle:CGFloat)->PiePart{
        var ag = getAngle(angle: angle+90)
        ag = ag / 180 * CGFloat.pi //+ CGFloat.pi*2
        var resI = 0
        for i in 0..<self.startAngles.count{
            
            if startAngles[i] > ag  && ag >= endAngles[i]{
                
                resI = i
                break
            }
            
        }
        return self.parts[self.startAngles.count-1-resI]
    }
    func getAngle(angle:CGFloat)->CGFloat{
        var ag = angle
        if ag >= 360 {
            ag = ag - 360
            
        }else if ag < 0 {
          ag = 360 - ag
        }else{
            return ag
        }
        return getAngle(angle: ag)
    }
    
    
    
    
//    override func draw(_ rect: CGRect) {
//        let w : CGFloat = rect.width
//        let h : CGFloat = rect.height
//
//
//
//
//
//        var percents : [CGFloat] = [1,2,3,4,5,6]
//        var colors   : [UIColor] = [UIColor.red,UIColor.green,UIColor.yellow,UIColor.cyan,UIColor.purple,UIColor.blue]
//        var titles   : [NSString] = ["ads","qwe","fas","fbdfb","dsfsd","dsfsdf"]
//
//        let ctx :CGContext  = UIGraphicsGetCurrentContext()!
//
//        let center : CGPoint = CGPoint.init(x: w/2, y: h/2)
//        let radius = w / 2
//
//        var startA : CGFloat = 0
//        var endA : CGFloat = CGFloat.pi
//        var angle : CGFloat = 0
//
//        var count : CGFloat = 0
//        for a in percents {
//            count = a + count
//        }
//
//        for i in 0..<percents.count {
//            startA = endA
//
//
//
//            angle = percents[i]  / count * CGFloat.pi * 2
//
//
//            endA = startA + angle
//
//
//            let path : UIBezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
//            path.addLine(to: center)
//            colors[i].set()
//            ctx.addPath(path.cgPath)
//            ctx.fillPath()
//
//            let style = NSMutableParagraphStyle()
//            style.alignment = NSTextAlignment.center
//            let attrs = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.paragraphStyle:style]
//            titles[i].draw(at: path.currentPoint, withAttributes: attrs)
//
//        }
//
//
//        self.backgroundColor = .clear
//
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.isOpaque = false
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
