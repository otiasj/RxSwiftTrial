//
//  Preferences.swift
//  RxSwiftTrial
//
//  This is used to save objects to preferences
//
//  Created by Julien Saito on 4/13/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import Foundation

open class Preferences : NSObject
{
    open class var sharedInstance: Preferences
    {
        struct Static
        {
            static let instance = Preferences()
        }
        
        return Static.instance
    }
    
    open override func value(forKey key: String) -> Any?
    {
        return UserDefaults.standard.value(forKey: key)
    }
    
    open override func setValue(_ value: Any?, forKey key: String)
    {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    open func removeValue(forKey key: String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    
    open func registerUserDefaults()
    {
        // create app defaults
        let appDefault: [String : AnyObject] = [:]
        UserDefaults.standard.register(defaults: appDefault)
    }
    
    open func saveChanges()
    {
        UserDefaults.standard.synchronize()
    }
}
