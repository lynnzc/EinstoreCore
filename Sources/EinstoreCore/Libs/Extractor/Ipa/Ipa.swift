//
//  Ipa.swift
//  App
//
//  Created by Ondrej Rafaj on 09/12/2017.
//

import Foundation
import Vapor
import SwiftShell
import ApiCore
import Normalized


class Ipa: BaseExtractor, Extractor {
    
    var payload: URL {
        var url = self.archive
        url.appendPathComponent("Payload")
        // TODO: Secure this a bit more?
        if let buildName: String = try! FileManager.default.contentsOfDirectory(atPath: url.path).first {
            url.appendPathComponent(buildName)
        }
        return url
    }
    
    // MARK: Processing
    
    func process(teamId: DbIdentifier, on req: Request) throws -> Future<Build> {
        #if os(macOS)
        let unzip = "unzip"
        #elseif os(Linux)
        let unzip = "/usr/bin/unzip"
        #endif
        run(unzip, "-o", self.file.path, "-d", self.archive.path)
        
        do {
            try self.parse()
        } catch {
            throw ExtractorError.invalidAppContent
        }
        return try self.app(platform: .ios, teamId: teamId, on: req)
    }
    
}

// MARK: - Parsing

extension Ipa {
    
    private func parseProvisioning() throws {
        var embeddedFile: URL = payload
        embeddedFile.appendPathComponent("embedded.mobileprovision")
        // TODO: Fix by decoding the provisioning file!!!!
        guard let provisioning = try? String(contentsOfFile: embeddedFile.path, encoding: String.Encoding.utf8) else {
            return
        }
        if provisioning.contains("ProvisionsAllDevices") {
            infoData["provisioning"] = "enterprise"
        }
        else if provisioning.contains("ProvisionedDevices") {
            infoData["provisioning"] = "adhoc"
        }
        else {
            infoData["provisioning"] = "appstore"
        }
    }
    
    private func parsePlistInfo(_ plist: PlistInfo) throws {
        // Bundle ID
        guard let bundleId = plist.CFBundleIdentifier else {
            throw ExtractorError.invalidAppContent
        }
        appIdentifier = bundleId
        
        // Name
        var appName: String? = plist.CFBundleDisplayName
        if appName == nil {
            appName = plist.CFBundleName
        }
        guard appName != nil else {
            throw ExtractorError.invalidAppContent
        }
        self.appName = appName
        
        // Versions
        versionLong = plist.CFBundleShortVersionString
        versionShort = plist.CFBundleVersion 
        
        // Other plist data
        if let minOS = plist.MinimumOSVersion {
            infoData["minOS"] = minOS
        }
        if let orientationPhone = plist.UISupportedInterfaceOrientations {
            infoData["orientationPhone"] = orientationPhone
        }
        if let orientationTablet = plist.UISupportedInterfaceOrientationsIpad {
            infoData["orientationTablet"] = orientationTablet
        }
        if let deviceCapabilities = plist.UIRequiredDeviceCapabilities {
            infoData["deviceCapabilities"] = deviceCapabilities
        }
        if let deviceFamily = plist.UIDeviceFamily {
            infoData["deviceFamily"] = deviceFamily
        }
    }
    
    func checkPlistIcons(_ iconInfo: PlistInfoIcon, files: [String]) throws {
        guard let primaryIcon = iconInfo.CFBundlePrimaryIcon else {
            return
        }
        guard let icons = primaryIcon.CFBundleIconFiles else {
            return
        }
        
        for icon: String in icons {
            for file: String in files {
                if file.contains(icon) {
                    var fileUrl: URL = payload
                    fileUrl.appendPathComponent(file)
                    if let iconData = try? Data(contentsOf: fileUrl) {
                        if iconData.count > (self.iconData?.count ?? 0) {
                            self.iconData = iconData
                        }
                    }
                }
            }
        }
        
        if let iconData = iconData {
            do {
                if let normalized = try? Normalize.getNormalizedPNG(data: iconData) {
                    self.iconData = normalized
                }
            } catch {
                print(error)
            }
        }
    }
    
    func parsePlistIcon(_ plist: PlistInfo) throws {
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: payload.path) else {
            return
        }
        if let iconInfo = plist.CFBundleIcons {
            try checkPlistIcons(iconInfo, files: files)
        }
        if let iconsInfoTablet = plist.CFBundleIconsIpad {
            try checkPlistIcons(iconsInfoTablet, files: files)
        }
    }
    
    func parse() throws {
        try parseProvisioning()
        
        var embeddedFile: URL = payload
        embeddedFile.appendPathComponent("Info.plist")
        do {
            if let attributes = try? FileManager.default.attributesOfItem(atPath: embeddedFile.path) {
                if let modified = attributes[FileAttributeKey.modificationDate] as? Date {
                    built = modified
                }
            }
        } catch {
            throw ExtractorError.errorParseModified
        }
        
        do {
            guard let plistData = try? Data(contentsOf: embeddedFile) else {
                throw ExtractorError.errorParsePlist
            }
            guard let plist = try? PropertyListDecoder().decode(PlistInfo.self, from: plistData) else {
                throw ExtractorError.errorParsePlist
            }
            
            try parsePlistInfo(plist)
            try parsePlistIcon(plist)
        } catch {
            print("Error occured while reading from the plist file")
            throw ExtractorError.errorParsePlist
        }
    }
}
