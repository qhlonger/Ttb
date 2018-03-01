import GRDB

/// A type responsible for initializing the application database.
///
/// See AppDelegate.setupDatabase()
struct AppDatabase {
    
    /// Creates a fully initialized database at path
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        // Connect to the database
        // See https://github.com/groue/GRDB.swift/#database-connections
        dbQueue = try DatabaseQueue(path: path)
        
        // Use DatabaseMigrator to define the database schema
        // See https://github.com/groue/GRDB.swift/#migrations
        try migrator.migrate(dbQueue)
        
        return dbQueue
    }
    
    /// The DatabaseMigrator that defines the database schema.
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createPie") { db in
            try db.create(table: "pie") { t in
                t.column("id", .integer).primaryKey()
                t.column("pieid", .integer).notNull()
                t.column("title", .text).collate(.localizedCaseInsensitiveCompare)
                t.column("weight", .double).notNull()
            }
        }
        migrator.registerMigration("createTurntable") { db in
            try db.create(table: "turntable") { t in
                t.column("id", .integer).primaryKey()
                t.column("title", .text).collate(.localizedCaseInsensitiveCompare)
            }
        }
        
        migrator.registerMigration("createItem") { db in
            try db.create(table: "importitem") { t in
                t.column("id", .integer).primaryKey()
                t.column("title", .text).collate(.localizedCaseInsensitiveCompare)
                t.column("type", .integer)
            }
        }
        
        let pies : [PiePart] = [
            PiePart(pieid:1, title: "✊", weight: 1, color: .red),
            PiePart(pieid:1, title: "✌️", weight: 1, color: .red),
            PiePart(pieid:1, title: "👋", weight: 1, color: .red),
            
            
            PiePart(pieid:2, title: "A", weight: 1, color: .red),
            PiePart(pieid:2, title: "B", weight: 1, color: .orange),
            PiePart(pieid:2, title: "C", weight: 1, color: .red),
            PiePart(pieid:2, title: "D", weight: 1, color: .orange),
            
            PiePart(pieid:3, title: "1", weight: 1, color: .red),
            PiePart(pieid:3, title: "2", weight: 1, color: .orange),
            PiePart(pieid:3, title: "3", weight: 1, color: .red),
            PiePart(pieid:3, title: "4", weight: 1, color: .orange),
            PiePart(pieid:3, title: "5", weight: 1, color: .orange),
            PiePart(pieid:3, title: "6", weight: 1, color: .orange),
            PiePart(pieid:3, title: "7", weight: 1, color: .orange),
            PiePart(pieid:3, title: "8", weight: 1, color: .orange),
            PiePart(pieid:3, title: "9", weight: 1, color: .orange),
            PiePart(pieid:3, title: "10", weight: 1, color: .orange),
            ]
        let turns : [Turntable] = [
            Turntable(id:1, title:"✊✌️👋"),
            Turntable(id:2, title:"ABCD"),
            Turntable(id:3, title:"12345678910"),
        ]
        
        migrator.registerMigration("fillTurntable") { db in
            for i in 0..<turns.count {
                try turns[i].insert(db)
            }
        }

        migrator.registerMigration("fillPie") { db in
            for i in 0..<pies.count {
                try pies[i].insert(db)
            }
        }
        
        migrator.registerMigration("fillItem") { db in
            let path : String = Bundle.main.path(forResource: "options.json", ofType: nil)!
            let data : Data = try NSData.init(contentsOfFile: path) as Data
            var dict : [String:AnyObject] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
            let trueths : [String] = dict["true"] as! [String]
            let advs : [String] = dict["adv"] as! [String]
            
            for i in trueths{
                try ImportItem.init(title: i as NSString, type: 1) .insert(db)
            }
            for i in advs{
                try ImportItem.init(title: i as NSString, type: 2) .insert(db)
            }
            
            
        }
        
        return migrator
    }
    
    
    func deleteTurntableWithId(id:Int64)  {
        try! dbQueue.inTransaction { db in
            
            
            
            
            
            let turns:[Turntable] = try Turntable.fetchAll(db)
            
            
            for turn in turns{
                
                let statement = try db.makeSelectStatement("SELECT * FROM pie WHERE pieid = ?")
                
                let pies:[PiePart] = try PiePart.fetchAll(statement,arguments: [turn.id])
                turn.pies = pies
            }
            
            allTurntables = turns
            currentTurntable = turns.first
            selectedTurntable = turns.first
            
            return .commit
        }
    }
    
    
    
}
