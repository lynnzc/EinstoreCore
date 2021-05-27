//
//  File.swift
//  
//
//  Created by lynn on 2021/5/27.
//

import Foundation

struct PlistInfoIconEntry: Codable, Equatable {
    let CFBundleIconFiles: [String]?
}

struct PlistInfoIcon: Codable, Equatable {
    let CFBundlePrimaryIcon: PlistInfoIconEntry?
}

struct PlistInfo: Codable, Equatable {
    let CFBundleIdentifier: String?
    let CFBundleDisplayName: String?
    let CFBundleName: String?
    let CFBundleShortVersionString: String?
    let CFBundleVersion: String?
    let MinimumOSVersion: String?
    let UISupportedInterfaceOrientations: [String]?
    let UISupportedInterfaceOrientationsIpad: [String]?
    let UIRequiredDeviceCapabilities: [String]?
    let UIDeviceFamily: [Int]?
    let CFBundleIcons: PlistInfoIcon?
    let CFBundleIconsIpad: PlistInfoIcon?
    
    enum CodingKeys: String, CodingKey {
        case CFBundleIdentifier
        case CFBundleDisplayName
        case CFBundleName
        case CFBundleShortVersionString
        case CFBundleVersion
        case MinimumOSVersion
        case UISupportedInterfaceOrientations
        case UISupportedInterfaceOrientationsIpad = "UISupportedInterfaceOrientations~ipad"
        case UIRequiredDeviceCapabilities
        case UIDeviceFamily
        case CFBundleIcons
        case CFBundleIconsIpad = "CFBundleIcons~ipad"
    }
}
