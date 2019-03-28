//
//  String+Ext.swift
//  frazeit
//
//  Created by Anh Vo on 8/2/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import Foundation

extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func stripHTML() -> String {
        var returnString = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        returnString = returnString.replacingOccurrences(of: "&nbsp;", with: "", options: .caseInsensitive, range: nil)
        returnString = returnString.replacingOccurrences(of: "\\\"", with: "", options: .caseInsensitive, range: nil)
        return returnString
    }
    
    func decodedString() -> String {
        let mutable = NSMutableString(string: self )
        CFStringTransform(mutable, nil, "Any-Hex/Java" as NSString, true)
        return (mutable as String)
    }
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
