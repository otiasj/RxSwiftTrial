//
//  TestNetworkApiService.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import RxSwift

class TestNetworkApiService: LoadService {
    typealias T = TestEntity
    typealias P = [String: Any?]

    /**
     * Load some data from the network
     */
    func load(withParams: [String: Any?]) -> Observable<TestEntity>{
        //FIXME this is returning a mock response
        return Observable<TestEntity>.just(TestEntity(loadedFrom: "Network"))
    }
    
}
