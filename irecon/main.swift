//
//  main.swift
//  irecon
//
//  Created by Xavier Stevens on 11/17/17.
//  Copyright © 2017 Xavier Stevens. All rights reserved.
//

import Foundation

func printUsage() {
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    print("usage: \(executableName) path")
}

if CommandLine.argc < 2 {
    printUsage()
    exit(1)
}

let args = CommandLine.arguments
let baseUrlAsString: String = "file://\(args[1])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
let baseUrl = URL(string: baseUrlAsString)!
let plistUrls = findPropertyLists(baseURL: baseUrl)
print("\n\n")
for url in plistUrls {
    let pld = readPropertyList(plistUrl: url)
    print("PLIST: \(url.path)")
    print("CONTENT: \n")
    printPropertyListDict(plistDict: pld)
    print("\n")
}
