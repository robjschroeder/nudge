//
//  osVersion.swift
//  Nudge
//
//  Created by Erik Gomez on 2/5/21.
//

import AppKit
import Foundation
import SystemConfiguration

struct osUtils {
    // https://gist.github.com/joncardasis/2c46c062f8450b96bb1e571950b26bf7
    func getSystemConsoleUsername() -> String {
        var uid: uid_t = 0
        var gid: gid_t = 0
        return SCDynamicStoreCopyConsoleUser(nil, &uid, &gid) as String? ?? ""
    }

    // https://ourcodeworld.com/articles/read/1113/how-to-retrieve-the-serial-number-of-a-mac-with-swift
    func getSerialNumber() -> String {
        var serialNumber: String? {
            let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
            
            guard platformExpert > 0 else {
                return nil
            }
            
            guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
                return nil
            }
            
            IOObjectRelease(platformExpert)

            return serialNumber
        }
        
        return serialNumber ?? ""
    }

    func getMajorOSVersion() -> Int {
        return ProcessInfo().operatingSystemVersion.majorVersion
    }

    func getMinorOSVersion() -> Int {
        return ProcessInfo().operatingSystemVersion.minorVersion
    }

    func getPatchOSVersion() -> Int {
        return ProcessInfo().operatingSystemVersion.patchVersion
    }

    // Why is there not a combined String for this?
    func getOSVersion() -> String {
        return String(getMajorOSVersion()) + "." + String(getMinorOSVersion()) + "." + String(getPatchOSVersion())
    }

    // Adapted from https://stackoverflow.com/a/25453654
    func versionEqual(current_version: String, new_version: String) -> Bool {
        return current_version.compare(new_version, options: .numeric) == .orderedSame
    }
    func versionGreaterThan(current_version: String, new_version: String) -> Bool {
        return current_version.compare(new_version, options: .numeric) == .orderedDescending
    }
    func versionGreaterThanOrEqual(current_version: String, new_version: String) -> Bool {
        return current_version.compare(new_version, options: .numeric) != .orderedAscending
    }
    func versionLessThan(current_version: String, new_version: String) -> Bool {
        return current_version.compare(new_version, options: .numeric) == .orderedAscending
    }
    func versionLessThanOrEqual(current_version: String, new_version: String) -> Bool {
        return current_version.compare(new_version, options: .numeric) != .orderedDescending
    }
}