//
//  TestComponent.swift
//  RxSwiftTrial
//
//  The component tracks the lifecycle of objects instantiated in module
//  this is usefull in the case where we could have shared instances, between or accross features
//
//  Created by Julien Saito on 3/15/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

class TestComponent {
    
    private static var testModule: TestModule?
    
    func inject(testView: TestViewController) {
        TestComponent.testModule = TestModule(testView: testView)
        if let testModule = TestComponent.testModule {
            testView.testPresenter = testModule.provideTestPresenter()
        }
    }
}
