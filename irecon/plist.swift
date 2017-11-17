//
//  plist.swift
//  irecon
//
//  Created by Xavier Stevens on 11/17/17.
//  Copyright © 2017 Xavier Stevens. All rights reserved.
//

import Foundation

func findPropertyLists(baseURL: URL) -> [URL] {
    var plistPaths: [URL] = []
    let fileManager = FileManager.default
    do {
        let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
        let enumerator = fileManager.enumerator(at: baseURL, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: { (url, error) -> Bool in
            print("directory enumeration error at \(url): ", error)
            return true
        })!
        for case let fileURL as URL in enumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if (!resourceValues.isDirectory! && fileURL.path.hasSuffix(".plist")) {
                print("plist found: \(fileURL.path)")
                plistPaths.append(fileURL)
            }
        }
    } catch {
        print(error)
    }
    
    return plistPaths
}


func readPropertyList(plistUrl: URL) -> [String:Any] {
    var plistDict: [String:Any] = [:]
    do {
        let data = try Data(contentsOf:plistUrl)
        plistDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
        // do something with the dictionary
    } catch {
        print(error)
    }
    
    return plistDict
}


func printPropertyListDict(plistDict: [String:Any]) {
//    if let jsonData = try? JSONSerialization.data(withJSONObject: plistDict, options: .prettyPrinted) {
//        print("\(jsonData)")
//    }
    do {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        let xmlString = String(data: plistData, encoding: .utf8)!
        print("\(xmlString)")
    } catch {
        print(error)
    }
//    for (k,v) in plistDict {
//        print("\t\(k.utf8) = \(v)")
//    }
}
