//
//  TRKeyChainHelper.swift
//  Traveler
//
//  Created by Ashutosh on 8/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


public enum KeychainError:ErrorType {
    case InvalidInput                      // If the value cannot be encoded as NSData
    case OperationUnimplemented         // -4 | errSecUnimplemented
    case InvalidParam                     // -50 | errSecParam
    case MemoryAllocationFailure         // -108 | errSecAllocate
    case TrustResultsUnavailable         // -25291 | errSecNotAvailable
    case AuthFailed                       // -25293 | errSecAuthFailed
    case DuplicateItem                   // -25299 | errSecDuplicateItem
    case ItemNotFound                    // -25300 | errSecItemNotFound
    case ServerInteractionNotAllowed    // -25308 | errSecInteractionNotAllowed
    case DecodeError                      // - 26275 | errSecDecode
    case Unknown(Int)                    // Another error code not defined
}


class TRKeyChainHelper: NSObject {
    
    static func mapResultCode(result:OSStatus) -> KeychainError? {
        switch result {
        case 0:
            return nil
        case -4:
            return .OperationUnimplemented
        case -50:
            return .InvalidParam
        case -108:
            return .MemoryAllocationFailure
        case -25291:
            return .TrustResultsUnavailable
        case -25293:
            return .AuthFailed
        case -25299:
            return .DuplicateItem
        case -25300:
            return .ItemNotFound
        case -25308:
            return .ServerInteractionNotAllowed
        case -26275:
            return .DecodeError
        default:
            return .Unknown(result.hashValue)
        }
    }
    
    class func addData(itemKey:String, itemValue:String) throws {
        guard let valueData = itemValue.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw KeychainError.InvalidInput
        }
        
        let queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey,
            kSecValueData as String: valueData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let resultCode:OSStatus = SecItemAdd(queryAdd as CFDictionaryRef, nil)
        
        if let err = mapResultCode(resultCode) {
            throw err
        } else {
            print("KeychainManager: Item added successfully")
        }
    }
 
    class func deleteData(itemKey:String) throws {
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey
        ]
        
        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionaryRef)
        
        if let err = mapResultCode(resultCodeDelete) {
            throw err
        } else {
            print("KeychainManager: Successfully deleted data")
        }
    }
    
    class func updateData(itemKey:String, itemValue:String) throws {
        guard let valueData = itemValue.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw KeychainError.InvalidInput
        }
        
        let updateQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey
        ]
        
        let updateAttributes : [String:AnyObject] = [
            kSecValueData as String: valueData
        ]
        
        if SecItemCopyMatching(updateQuery, nil) == noErr {
            let updateResultCode = SecItemUpdate(updateQuery, updateAttributes)
            if let err = mapResultCode(updateResultCode) {
                throw err
            } else {
                print("KeychainManager: Successfully updated data")
            }
        }
    }

    class func queryData (itemKey:String) throws -> AnyObject? {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let resultCodeLoad = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(queryLoad, UnsafeMutablePointer($0))
        }
        
        if let err = mapResultCode(resultCodeLoad) {
            throw err
        }
        
        guard let resultVal = result as? NSData, keyValue = NSString(data: resultVal, encoding: NSUTF8StringEncoding) as? String else {
            print("KeychainManager: Error parsing keychain result: \(resultCodeLoad)")
            return nil
        }
        
        return keyValue
    }
}