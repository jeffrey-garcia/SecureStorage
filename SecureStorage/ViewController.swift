//
//  ViewController.swift
//  SecureStorage
//
//  Created by jeffrey on 20/6/2018.
//  Copyright © 2018 jeffrey. All rights reserved.
//

import UIKit
import CoreData

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
                saveUuidToKeychain?.addTarget(self, action: #selector(saveToKeychain), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(6) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 6 is \(NSStringFromClass(object_getClass(view)!))")
                let getUuidToKeychain = view as? UIButton
                getUuidToKeychain?.addTarget(self, action: #selector(getFromKeychain), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(7) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 7 is \(NSStringFromClass(object_getClass(view)!))")
                let saveToDbBtn = view as? UIButton
                saveToDbBtn?.addTarget(self, action: #selector(saveToDb), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(8) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 8 is \(NSStringFromClass(object_getClass(view)!))")
                let getFromDbBtn = view as? UIButton
                getFromDbBtn?.addTarget(self, action: #selector(getFromDb), for: .touchUpInside)
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
    
    func saveToKeychain() {
        print("\(NSStringFromClass(object_getClass(self)!)) - saveToKeychain()")
        
        guard let uuid:String = getFromUserDefaults() else {
            return
        }
        
        let key:String = "encKey-\(uuid)"
        let encKey = generateEncKey()
        let data:Data = encKey.data(using: .utf8)!
        
        let queryForWrite: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            kSecValueData as String   : data
        ]
        
        // will produce error if not deleting up-front when the item exist in keychain
        SecItemDelete(queryForWrite as CFDictionary)

        let writeStatus: OSStatus = SecItemAdd(queryForWrite as CFDictionary, nil)
        if (writeStatus != errSecSuccess) {
            if let err = SecCopyErrorMessageString(writeStatus, nil) {
                print("error writing to keychain: \(err)")
            }
        } else {
            print("writing to keychain success: \(encKey)")
        }
    }
    
    func getFromKeychain() {
        print("\(NSStringFromClass(object_getClass(self)!)) - getFromKeychain()")
        
        guard let uuid:String = getFromUserDefaults() else {
            return
        }
        
        let key:String = "encKey-\(uuid)"
        
        let queryForRead: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item:CFTypeRef?
        
        // Search for the keychain items
        let readStatus: OSStatus = SecItemCopyMatching(queryForRead as CFDictionary, &item)
        if (readStatus == errSecSuccess) {
            if let retrievedData = item as? Data {
                let encKey = String(data: retrievedData, encoding: .utf8)
                print("retrieved value from keychain: \(encKey ?? "")")
            } else {
                print("no value retrieved from keychain.")
            }
        } else {
            if let err = SecCopyErrorMessageString(readStatus, nil) {
                print("error reading from keychain: \(err)")
            }
        }
    }
    
    func saveToDb() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // TODO: the DB name should be identical to the user id
        let entity = NSEntityDescription.entity(forEntityName: "DbCachedData", in: managedContext)
        
        let cachedData = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        // TODO: perform user-level data encryption using AES256, encrypt against the app's encKey + userId
        cachedData.setValue("some_value", forKey: "some_key")
        
        do {
            try managedContext.save()
            print("writing to DB success")
        } catch let error as NSError {
            print("error writing to DB: \(error), \(error.userInfo)")
        }
    }
    
    func getFromDb() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DbCachedData")
        
        do {
            let resultSet:[NSManagedObject] = try managedContext.fetch(fetchRequest)
            print("reading to DB success")
            
            for result in resultSet {
                if let value = result.value(forKey: "some_key") {
                    print("retrieved value: \(value)")
                    break
                }
            }
            
        } catch let error as NSError {
            print("error reading from DB: \(error), \(error.userInfo)")
        }
    }
    
}

