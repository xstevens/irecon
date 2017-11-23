//
//  main.swift
//  irecon
//
//  Created by Xavier Stevens on 11/17/17.
//  Copyright © 2017 Xavier Stevens. All rights reserved.
//

import Foundation
import Rainbow

func printUsage() {
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    print("Usage: \(executableName) PATH")
}

if CommandLine.arguments.count != 2 {
    printUsage()
    exit(1)
}

let args = CommandLine.arguments
let baseUrlAsString: String = "file://\(args[1])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
let baseUrl = URL(string: baseUrlAsString)!

// find plist files
print("Searching for .plist files ... \n")
let plistUrls = findPropertyLists(baseURL: baseUrl)
if plistUrls.count > 0 {
    for url in plistUrls {
        print("Found: \(url)\n")
    }
    // fetch each plist and print to stdout in XML format
    for url in plistUrls {
        let pld = readPropertyList(plistUrl: url)
        print("[PLIST]:".yellow + " \(url.path)".white)
        print("[CONTENT]: \n".yellow)
        printPropertyListDictAsXml(plistDict: pld)
        print("\n")
    }
} else {
    print("No plist files found.")
}

// discover keychain.db
print("Searching for keychain-2.db ... \n")
let keychainDbPath: URL? = findKeychain(baseURL: baseUrl)
if keychainDbPath != nil {
    print("Found: \(keychainDbPath!.path)\n")
    // get entitlements and print to stdout as XML
    let entitlements = queryEntitlements(dbPath: keychainDbPath!.path)
    print("[KEYCHAIN.DB]:".yellow + "\(keychainDbPath!.path)".white)
    print("[ENTITLEMENTS]:\n".yellow)
    printEntitlementsAsXml(entitlements: entitlements)
    print("\n")
}
