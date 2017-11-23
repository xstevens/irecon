//
//  plist.swift
//  irecon
//
//  Created by Xavier Stevens on 11/17/17.
//  Copyright © 2017 Xavier Stevens. All rights reserved.
//

import Foundation

// find all property lists underneath a directory
func findPropertyLists(baseURL: URL) -> [URL] {
    var plistPaths: [URL] = []
    let fileManager = FileManager.default
    do {
        let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
        let enumerator = fileManager.enumerator(at: baseURL, includingPropertiesForKeys: resourceKeys, options: [], errorHandler: { (url, error) -> Bool in
            print("Directory enumeration error at \(url): ", error)
            return true
        })!
        for case let fileURL as URL in enumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if (!resourceValues.isDirectory! && fileURL.path.hasSuffix(".plist")) {
                plistPaths.append(fileURL)
            }
        }
    } catch {
        print(error)
    }
    
    return plistPaths
}

// read a property list and return it as a dictionary
func readPropertyList(plistUrl: URL) -> [String:Any] {
    var plistDict: [String:Any] = [:]
    do {
        let data = try Data(contentsOf:plistUrl)
        plistDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
    } catch {
        print(error)
    }
    
    return plistDict
}

// print a property list dictionary in XML format
func printPropertyListDictAsXml(plistDict: [String:Any]) {
    do {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        let xmlString = String(data: plistData, encoding: .utf8)!
        print("\(xmlString)")
    } catch {
        print(error)
    }
}
