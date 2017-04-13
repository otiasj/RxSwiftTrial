//
//  TestEntity.swift
//  RxSwiftTrial
//
//  This class holds the data loaded from the services
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

class TestEntity {
    
    //This is just for explaining the purpose of this class
    //Delete this and replace with the variable needed by your feature
    let someValue: String
    
    init(loadedFrom: String) {
        someValue = loadedFrom
    }
    
    init(copy: TestEntity) {
        someValue = copy.someValue
    }
}
