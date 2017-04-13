//
//  TestModule.swift
//  RxSwiftTrial
//
//  This class is in charge of initializing and creating instances for this feature
//
//  Created by Julien Saito on 3/15/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

class TestModule {
    
    //the instances
    private let testView: TestView
    private let testPresenter: TestPresenter
    private let testDelegate: TestDelegate
    
    //Be careful in the order of the creation of instances
    init(testView: TestView) {
        self.testView = testView
        self.testDelegate = TestModule.provideTestDelegate()
        self.testPresenter = TestPresenterImpl(testView: testView, testDelegate: testDelegate)
    }
    
    func provideTestPresenter() -> TestPresenter {
       return testPresenter
    }
    
    internal static func provideTestDelegate() -> TestDelegateImpl {
        return TestDelegateImpl(testCacheApiService: provideTestCacheApiService(), testNetworkApiService: provideTestNetworkApiService())
    }
    
    internal static func provideTestCacheApiService() -> TestCacheApiService {
        return TestCacheApiService()
    }
    
    internal static func provideTestNetworkApiService() -> TestNetworkApiService {
        return TestNetworkApiService()
    }
    
}
