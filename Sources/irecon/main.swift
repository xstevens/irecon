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
    print("usage: \(executableName) path")
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
for url in plistUrls {
    print("Found: \(url)")
}
print("\n")

// fetch each plist and print to stdout in XML format
for url in plistUrls {
    let pld = readPropertyList(plistUrl: url)
    print("[PLIST]:".yellow + " \(url.path)".white)
    print("[CONTENT]: \n".yellow)
    printPropertyListDict(plistDict: pld)
    print("\n")
}
