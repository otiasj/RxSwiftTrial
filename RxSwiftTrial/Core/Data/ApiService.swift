//
//  ApiService.swift
//  RxSwiftTrial
//
//  A generic protocol for loading and saving
//
//  Created by Julien Saito on 4/13/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import RxSwift

protocol LoadService {
    associatedtype T
    associatedtype P
    
    /**
     * Load some data
     */
    func load(withParams: P) -> Observable<T>
}


protocol StoreService {
    associatedtype T
    associatedtype P
    
    /**
     * If this service can store Data then this method should be implemented
     * store the given value
     */
    func store(_ value: T, withParams: P)
    
}

protocol ClearService {
    associatedtype T
    associatedtype P
    
    /**
     * If this service can store Data then this method should be implemented.
     * Clear data if any is stored for the given params
     */
    func clear(_ swithParams: P)
}

protocol ApiService : LoadService, StoreService, ClearService {
    
}

