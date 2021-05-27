//
//  Dictionary+Plist.swift
//  EinstoreCore
//
//  Created by Ondrej Rafaj on 15/01/2018.
//

import Foundation
import Vapor
//#if os(Linux)
import SwiftShell
//#endisf



extension Dictionary where Key == String {
    
    static func fill(fromPlist url: URL) throws -> [String: Any]? {
        do {
            var format: PropertyListSerialization.PropertyListFormat = .binary
            guard let plistData: Data = try? Data.init(contentsOf: url) else {
                throw ExtractorError.errorParsePlist
            }
            let plist = try? PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String: Any]
            return plist
        } catch {
            print("Error occured while reading from the plist file")
            throw ExtractorError.errorParsePlist
        }
    }
    
}

