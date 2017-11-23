//
//  keychain.swift
//  irecon
//
//  Created by Xavier Stevens on 11/17/17.
//  Copyright © 2017 Xavier Stevens. All rights reserved.
//

import Foundation
import SQLite
//import SQLite3

func findKeychain(baseURL: URL?) -> URL? {
    // Determine if we're on iOS device by looking for:
    //      /var/Keychains/keychain-2.db
    // If we don't find it then search a user specified directory for keychain db
    let iosKeychainDbPath = URL(string: "/var/Keychains/keychain-2.db")!
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: iosKeychainDbPath.path) {
        return iosKeychainDbPath
    } else if baseURL != nil {
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
            let enumerator = fileManager.enumerator(at: baseURL!, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: { (url, error) -> Bool in
                print("Directory enumeration error at \(url): ", error)
                return true
            })!
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                if (!resourceValues.isDirectory! && (fileURL.path.hasSuffix("keychain-2.db") || fileURL.path.hasSuffix("keychain-2-debug.db"))) {
                    return fileURL
                }
            }
        } catch {
            print(error)
        }
    }
    
    return nil
 }

//func openDatabase(dbPath: String) -> OpaquePointer? {
//  var db: OpaquePointer? = nil
//  if sqlite3_open(dbPath, &db) == SQLITE_OK {
//    print("Successfully opened connection to database at \(dbPath)")
//    return db
//  } else {
//    print("Unable to open database.")
//    PlaygroundPage.current.finishExecution()
//  }
//}
//
//func queryEntitlements(db: OpaquePointer?) {
//    let query = "SELECT DISTINCT agrp FROM genp UNION SELECT DISTINCT agrp FROM inet;"
//    var queryStmt: OpaquePointer? = nil
//    if sqlite3_prepare_v2(db, query, -1, &queryStmt, nil) == SQLITE_OK {
//        if sqlite3_step(queryStmt) == SQLITE_ROW {
//            let col0 = sqlite3_column_text(statement, 0)!
//            let entitlement = String(cString: col0)
//            print("\(entitlement)")
//        } else {
//            print("Query returned no results.")
//        }
//    } else {
//        print("Query statement could not be prepared.")
//    }
//    sqlite3_finalize(queryStmt)
//}
//
//func closeDatabase(db: OpaquePointer?) {
//    sqlite3_close(db)
//}


func queryEntitlements(dbPath: String) -> [String] {
    var entitlements: [String] = []
    do {
        let db = try Connection(dbPath)
        for row in try db.prepare("SELECT DISTINCT agrp FROM genp UNION SELECT DISTINCT agrp FROM inet") {
            entitlements.append("\(row[0]!)")
        }
    } catch {
        print(error)
    }
    
    return entitlements
}

func printEntitlementsAsXml(entitlements: [String]) {
    var xmlTemplate = """
    <?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
    <plist version=\"1.0\">
        <dict>
            <key>keychain-access-groups</key>
            <array>

    """
    for entitlement in entitlements {
        xmlTemplate.append("\t\t<string>\(entitlement)</string>\n")
    }
    xmlTemplate.append("""
            </array>
        </dict>
    </plist>
    """)
    print(xmlTemplate)
}
