//
//  ViewController.swift
//  SecureStorage
//
//  Created by jeffrey on 20/6/2018.
//  Copyright © 2018 jeffrey. All rights reserved.
//

import UIKit
import CoreData

import CryptoSwift
import SAMKeychain

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initUI() {
        print("\(NSStringFromClass(object_getClass(self)!)) - initUI()")
        
        if let view = self.view.viewWithTag(1) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 1 is \(NSStringFromClass(object_getClass(view)!))")
                let generateUuidBtn = view as? UIButton
                generateUuidBtn?.addTarget(self, action: #selector(generateUuid), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(2) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 2 is \(NSStringFromClass(object_getClass(view)!))")
                let saveUuidToUserDefaults = view as? UIButton
                saveUuidToUserDefaults?.addTarget(self, action: #selector(saveToUserDefaults), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(3) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 3 is \(NSStringFromClass(object_getClass(view)!))")
                let getUuidFromUserDefaults = view as? UIButton
                getUuidFromUserDefaults?.addTarget(self, action: #selector(getFromUserDefaults), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(4) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 4 is \(NSStringFromClass(object_getClass(view)!))")
                let generateEncKeyBtn = view as? UIButton
                generateEncKeyBtn?.addTarget(self, action: #selector(generateEncKey), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(5) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 5 is \(NSStringFromClass(object_getClass(view)!))")
                let saveUuidToKeychain = view as? UIButton
                saveUuidToKeychain?.addTarget(self, action: #selector(saveToKeychain2), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(6) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 6 is \(NSStringFromClass(object_getClass(view)!))")
                let getUuidToKeychain = view as? UIButton
                getUuidToKeychain?.addTarget(self, action: #selector(getFromKeychain2), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(7) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 7 is \(NSStringFromClass(object_getClass(view)!))")
                let generateChecksumBtn = view as? UIButton
                generateChecksumBtn?.addTarget(self, action: #selector(get32BitChecksum), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(8) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 8 is \(NSStringFromClass(object_getClass(view)!))")
                let encryptStrBtn = view as? UIButton
                encryptStrBtn?.addTarget(self, action: #selector(encryptString), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(9) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 9 is \(NSStringFromClass(object_getClass(view)!))")
                let decryptStrBtn = view as? UIButton
                decryptStrBtn?.addTarget(self, action: #selector(decryptString), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(10) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 10 is \(NSStringFromClass(object_getClass(view)!))")
                let getFromDbBtn = view as? UIButton
                getFromDbBtn?.addTarget(self, action: #selector(getFromDb), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(11) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 11 is \(NSStringFromClass(object_getClass(view)!))")
                let saveToDbBtn = view as? UIButton
                saveToDbBtn?.addTarget(self, action: #selector(saveToDb), for: .touchUpInside)
            }
        }
    }
    
    func generateUuid() -> String {
        print("\(NSStringFromClass(object_getClass(self)!)) - generateUuid()")
        
        let uuid = UUID.init().uuidString
        print("uuid string: \(uuid)")
        
        return uuid
    }
    
    func saveToUserDefaults() {
        print("\(NSStringFromClass(object_getClass(self)!)) - saveToUserDefaults()")
        
        let userDefaults = UserDefaults.standard
        let uuid = self.generateUuid()
        userDefaults.set(uuid, forKey: "uuid")
        print("writing to user defaults success: \(uuid)")
    }
    
    func getFromUserDefaults() -> String? {
        print("\(NSStringFromClass(object_getClass(self)!)) - getFromUserDefaults()")
        
        let userDefaults = UserDefaults.standard
        if let uuid = userDefaults.object(forKey: "uuid") as? String {
            print("retrieved value from user defaults: \(uuid)")
            return uuid
        } else {
            print("no value retrieved from user defaults")
            return nil
        }
    }
    
    func generateEncKey() -> String {
        print("\(NSStringFromClass(object_getClass(self)!)) - generateKey()")

        // chop all - to make sure its 32 bit
        let uuid = UUID.init().uuidString.replacingOccurrences(of: "-", with: "")
        print("random key string: \(uuid)")
        
        return uuid
    }
    
//    func saveToKeychain() {
//        print("\(NSStringFromClass(object_getClass(self)!)) - saveToKeychain()")
//
//        guard let uuid:String = getFromUserDefaults() else {
//            return
//        }
//
//        let key:String = "encKey-\(uuid)"
//        let encKey = generateEncKey()
//        let data:Data = encKey.data(using: .utf8)!
//
//        let queryForWrite: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword as String,
//            kSecAttrAccount as String: key,
//            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
//            kSecValueData as String   : data
//        ]
//
//        // will produce error if not deleting up-front when the item exist in keychain
//        SecItemDelete(queryForWrite as CFDictionary)
//
//        let writeStatus: OSStatus = SecItemAdd(queryForWrite as CFDictionary, nil)
//        if (writeStatus != errSecSuccess) {
//            if let err = SecCopyErrorMessageString(writeStatus, nil) {
//                print("error writing to keychain: \(err)")
//            }
//        } else {
//            print("writing to keychain success: \(encKey)")
//        }
//    }
    
//    func getFromKeychain() {
//        print("\(NSStringFromClass(object_getClass(self)!)) - getFromKeychain()")
//
//        guard let uuid:String = getFromUserDefaults() else {
//            return
//        }
//
//        let key:String = "encKey-\(uuid)"
//
//        let queryForRead: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword as String,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String: kCFBooleanTrue,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//
//        var item:CFTypeRef?
//
//        // Search for the keychain items
//        let readStatus: OSStatus = SecItemCopyMatching(queryForRead as CFDictionary, &item)
//        if (readStatus == errSecSuccess) {
//            if let retrievedData = item as? Data {
//                let encKey = String(data: retrievedData, encoding: .utf8)
//                print("retrieved value from keychain: \(encKey ?? "")")
//            } else {
//                print("no value retrieved from keychain.")
//            }
//        } else {
//            if let err = SecCopyErrorMessageString(readStatus, nil) {
//                print("error reading from keychain: \(err)")
//            }
//        }
//    }
    
    func saveToKeychain2() {
        print("\(NSStringFromClass(object_getClass(self)!)) - saveToKeychain2()")
        
        guard let uuid:String = getFromUserDefaults() else {
            return
        }
        
        let key:String = "encKey-\(uuid)"
        let value = generateEncKey()
        
        if let bundleIdentifier =  Bundle.main.bundleIdentifier {
            SAMKeychain.setAccessibilityType(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            if SAMKeychain.setPassword(value, forService: String(describing: bundleIdentifier), account: key) == true {
                print("writing to keychain success: \(value)")
            } else {
                print("fail writing to keychain")
            }
        }
    }
    
    func getFromKeychain2() -> String? {
        print("\(NSStringFromClass(object_getClass(self)!)) - getFromKeychain2()")
        
        guard let uuid:String = getFromUserDefaults() else {
            return nil
        }
        let key:String = "encKey-\(uuid)"
        
        if let bundleIdentifier =  Bundle.main.bundleIdentifier {
            SAMKeychain.setAccessibilityType(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            if let value = SAMKeychain.password(forService: String(describing: bundleIdentifier), account: key) {
                print("retrieved value from keychain: \(value)")
                return value
            } else {
                print("fail reading from keychain")
            }
        }
        
        return nil
    }
    
    func get32BitChecksum() -> String? {
        print("\(NSStringFromClass(object_getClass(self)!)) - get32BitChecksum()")
        
        if let credential = self.getFromKeychain2() {
            if let sha256checksum = self.generateSha256ChecksumString(credential + "user_id") {
                // further reduce the checksum string from 64 bits lenght to 32 bits length by hashing it with MD5
                return self.generateMd5ChecksumString(sha256checksum)
            }
        }
        
        return nil
    }
    
    internal func generateSha256ChecksumString(_ inputString:String?) -> String? {
        print("\(NSStringFromClass(object_getClass(self)!)) - generateSha256ChecksumString()")
        
        let data:Data? = inputString?.data(using: .utf8)
        var checksum:String?
        checksum = data?.sha256().toHexString()
        print("SHA256 checksum generated: \(checksum ?? "")")
        
        return checksum
    }
    
    internal func generateMd5ChecksumString(_ inputString:String?) -> String? {
        print("\(NSStringFromClass(object_getClass(self)!)) - generateMd5ChecksumString()")
        
        let data:Data? = inputString?.data(using: .utf8)
        var checksum:String?
        checksum = data?.md5().toHexString()
        print("MD5 checksum generated: \(checksum ?? "")")
        
        return checksum
    }
    
    func encryptString() {
        print("\(NSStringFromClass(object_getClass(self)!)) - encryptString()")
        
        let temp:String = "some_value"
        
        do {
            try self.encrypt(temp)
        } catch {
            print("error encrypting data: \(error.localizedDescription)")
        }
    }
    
    func decryptString() {
        print("\(NSStringFromClass(object_getClass(self)!)) - decryptString()")
        
        let temp:String = "some_value"
        
        do {
            if let encryptedStr = try self.encrypt(temp) {
                try self.decrypt(encryptedStr)
            }
        } catch {
            print("error encrypting data: \(error.localizedDescription)")
        }
    }
    
    internal func encrypt(_ decipheredText:String) throws -> String? {
        if let encKey = self.get32BitChecksum() {
            do {
                let aes = try AES(key: encKey, iv: "", blockMode: .CBC, padding: PKCS7())
                let cipheredText = try aes.encrypt(Array(decipheredText.utf8))
                let base64_cipheredText = Data(bytes: cipheredText).base64EncodedString()
                print("encrytped string: \(base64_cipheredText)")
                return base64_cipheredText
                
            } catch {
                throw error
            }
        }
        return nil
    }
    
    internal func decrypt(_ base64_cipheredText:String) throws -> String? {
        if let encKey = self.get32BitChecksum() {
            do {
                let aes = try AES(key: encKey, iv: "", blockMode: .CBC, padding: PKCS7())
                if let base64_cipherData = Data(base64Encoded: base64_cipheredText) {
                    let decipheredData = try aes.decrypt(base64_cipherData.bytes)
                    let decipheredText = String(bytes:decipheredData, encoding:String.Encoding.utf8)
                    print("decrypted string: \(decipheredText ?? "")")
                    return decipheredText
                }
                
            } catch {
                throw error
            }
        }
        return nil
    }
    
    func saveToDb() {
        print("\(NSStringFromClass(object_getClass(self)!)) - saveToDb()")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // TODO: the DB name should be identical to the user id
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DbCachedData")
        
        do {
            let resultSet:[NSManagedObject] = try managedContext.fetch(fetchRequest)
            
            // TODO: perform user-level data encryption using AES256, encrypt against the app's encKey + userId
            if let cipheredText = try self.encrypt("some_value") {
                if let result = resultSet.first {
                    // DB is not empty, update the data
                    result.setValue(cipheredText, forKey: "some_key")
                } else {
                    // DB is empty, creating the data
                    // TODO: the DB name should be identical to the user id
                    let entity = NSEntityDescription.entity(forEntityName: "DbCachedData", in: managedContext)
                    let result = NSManagedObject(entity: entity!, insertInto: managedContext)
                    result.setValue(cipheredText, forKey: "some_key")
                }
                
                try managedContext.save()
                print("writing to DB success")
            }
        } catch let error as NSError {
            print("error writing from DB: \(error), \(error.userInfo)")
        }
        
//        // TODO: the DB name should be identical to the user id
//        let entity = NSEntityDescription.entity(forEntityName: "DbCachedData", in: managedContext)
//
//        let cachedData = NSManagedObject(entity: entity!, insertInto: managedContext)
//
//        do {
//            // TODO: perform user-level data encryption using AES256, encrypt against the app's encKey + userId
//            if let cipheredText = try self.encrypt("some_value") {
//                cachedData.setValue(cipheredText, forKey: "some_key")
//            }
//
//            try managedContext.save()
//            print("writing to DB success")
//
//        } catch let error as NSError {
//            print("error writing to DB: \(error), \(error.userInfo)")
//        }
    }
    
    func getFromDb() {
        print("\(NSStringFromClass(object_getClass(self)!)) - getFromDb()")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // TODO: the DB name should be identical to the user id
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DbCachedData")
        
        do {
            let resultSet:[NSManagedObject] = try managedContext.fetch(fetchRequest)
            
            if let result = resultSet.first {
                if let cipheredText = result.value(forKey: "some_key") as? String {
                    try self.decrypt(cipheredText)
                    print("reading from DB success")
                }
            } else {
                print("DB doesn't exist")
            }
            
        } catch let error as NSError {
            print("error reading from DB: \(error), \(error.userInfo)")
        }
    }
    
}

