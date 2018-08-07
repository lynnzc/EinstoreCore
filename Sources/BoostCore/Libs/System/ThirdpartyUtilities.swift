//
//  ThirdpartyUtilities.swift
//  BoostCore
//
//  Created by Ondrej Rafaj on 07/08/2018.
//

import Foundation


/// Paths to third-party/non-swift command line utilities
public class ThirdpartyUtilities {
    
    /// Defualt singleton accessor
    public static let `default` = ThirdpartyUtilities()
    
    
    /// Normalize binary PNG from .ipa
    public static var normalizePNG: URL {
        return System.default.binUrl.appendingPathComponent("normalize.py")
    }
    
    /// Path to the APK extractor
    public static var apkExtractorUrl: URL {
        var url: URL = System.default.binUrl
        url.appendPathComponent("apktool_2.3.1.jar")
        return url
    }
    
    /// XML to JSON Converter
    public static var xml2jsonUrl: URL {
        var url: URL = System.default.binUrl
        url.appendPathComponent("xml2json.py")
        return url
    }
    
}