//
//  TestDelegateTest.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/21/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxSwiftTrial

//Testing the presenter interactions with the view and the delegate
class TestDelegateTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    //A fake cache service
    class MockTestCacheApiService : TestCacheApiService {
        var loadCallCount = 0
        var storeCallCount = 0
        var clearCallCount = 0
        var mockValue = TestEntity(loadedFrom: "mock cache entity")
        var mockObserver: AnyObserver<TestEntity>?
        
        override func load(withParams: NSDictionary?) -> Observable<TestEntity> {
            return Observable.create { observer in
                self.loadCallCount += 1
                self.mockObserver = observer
                return Disposables.create()
            }
        }
        
        func store(_ value: TestEntity, withParams: NSDictionary?) {
            storeCallCount += 1
        }
        
        func clear(withParams: NSDictionary?) {
            clearCallCount += 1
        }
        
        //trigger a fake value
        func triggerOnNext() {
            if let mockObserver = mockObserver {
                mockObserver.onNext(self.mockValue)
                mockObserver.onCompleted()
            }
        }
        
        func triggerEmptyResult() {
            if let mockObserver = mockObserver {
                mockObserver.onCompleted()
            }
        }
        
        //trigger a fake error
        func triggerOnError() {
            if let mockObserver = mockObserver {
                mockObserver.onError(NSError(domain: "Some error", code: 404))
            }
        }
    }
    
    //A fake network api service
    class MockTestNetworkApiService : TestNetworkApiService {
        var loadCallCount = 0
        var storeCallCount = 0
        var clearCallCount = 0
        var mockValue = TestEntity(loadedFrom: "mock network entity")
        var mockObserver: AnyObserver<TestEntity>?
        
        override func load(withParams: NSDictionary) -> Observable<TestEntity> {
            return Observable.create { observer in
                self.loadCallCount += 1
                self.mockObserver = observer
                return Disposables.create()
            }
        }
        
        func store(_ value: TestEntity, withParams: NSDictionary) {
            storeCallCount += 1
        }
        
        func clear(withParams: NSDictionary) {
            clearCallCount += 1
        }
        
        //trigger a fake value
        func triggerOnNext() {
            if let mockObserver = mockObserver {
                mockObserver.onNext(self.mockValue)
                mockObserver.onCompleted()
            }
        }
        
        //trigger a fake error
        func triggerOnError() {
            if let mockObserver = mockObserver {
                mockObserver.onError(NSError(domain: "Some error", code: 404))
            }
        }
    }
    
    var mockTestDelegate : TestDelegate?
    var mockTestCacheApiService : MockTestCacheApiService?
    var mockTestNetworkApiService : MockTestNetworkApiService?
    
    override func setUp() {
        super.setUp()
        useDefaultSchedulers = true
        mockTestCacheApiService = MockTestCacheApiService()
        mockTestNetworkApiService = MockTestNetworkApiService()
        mockTestDelegate = TestDelegateImpl(testCacheApiService: mockTestCacheApiService!, testNetworkApiService: mockTestNetworkApiService!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //check that calling load will receive both an observable from cache and network api servcices
    func testLoadCallsDelegate() {
        let onNextIsCalled = expectation(description: "onNext is called")
        var receivedEntity: TestEntity?
        
        mockTestDelegate!.load(params: [:])
            .subscribe(
                onNext: { entity in
                    XCTAssertNotNil(entity)
                    XCTAssertEqual(entity.getEntityOrigin(), "This Entity was loaded from mock cache entity")
                    receivedEntity = entity
            },
                onError: { error in
                     XCTFail("there should be no error in this test case")
            },
                onCompleted: {
                    onNextIsCalled.fulfill()
            },
                onDisposed: {
                    print("Test Disposed")
            }
            )
            .addDisposableTo(disposeBag)
        
        mockTestCacheApiService?.triggerOnNext() //trigger the cache service response
        mockTestNetworkApiService?.triggerOnNext() //trigger the network service response
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Time out during test!")
            XCTAssertNotNil(receivedEntity)
            XCTAssertEqual(self.mockTestCacheApiService?.loadCallCount, 1)
            XCTAssertEqual(self.mockTestNetworkApiService?.loadCallCount, 0)
        }
        
    }
    
    //check that calling load we receive the result from network
    func testWithNoCache() {
        let onNextIsCalled = expectation(description: "onNext is called")
        var receivedEntity: TestEntity?
        
        mockTestDelegate!.load(params: [:])
            .subscribe(
                onNext: { entity in
                    XCTAssertNotNil(entity)
                    XCTAssertEqual(entity.getEntityOrigin(), "This Entity was loaded from mock network entity")
                    receivedEntity = entity
            },
                onError: { error in
                    XCTFail("there should be no error in this test case")
            },
                onCompleted: {
                    onNextIsCalled.fulfill()
            },
                onDisposed: {
                    print("Test Disposed")
            }
            )
            .addDisposableTo(disposeBag)
        
        mockTestCacheApiService?.triggerEmptyResult() //trigger an empty cache service response
        mockTestNetworkApiService?.triggerOnNext() //trigger the network service response
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Time out during test!")
            XCTAssertNotNil(receivedEntity)
            XCTAssertEqual(self.mockTestCacheApiService?.loadCallCount, 1)
            XCTAssertEqual(self.mockTestNetworkApiService?.loadCallCount, 1)
        }
    }

    //check a cache error is propagated
    func testWithCacheError() {
        let onNextIsCalled = expectation(description: "onError is called")
        
        mockTestDelegate!.load(params: [:])
            .subscribe(
                onNext: { entity in
                    XCTFail("there should be no result in this test case")
            },
                onError: { error in
                    //received error from cache
                    onNextIsCalled.fulfill()
            },
                onCompleted: {
            },
                onDisposed: {
                    print("Test Disposed")
            }
            )
            .addDisposableTo(disposeBag)
        
        mockTestCacheApiService?.triggerOnError()
        mockTestNetworkApiService?.triggerOnNext()
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Time out during test!")
            XCTAssertEqual(self.mockTestCacheApiService?.loadCallCount, 1)
            XCTAssertEqual(self.mockTestNetworkApiService?.loadCallCount, 0)
        }
    }
    
    //check a network error is propagated
    func testWithNetworkError() {
        let onNextIsCalled = expectation(description: "onError is called")
        
        mockTestDelegate!.load(params: [:])
            .subscribe(
                onNext: { entity in
                    XCTFail("there should be no result in this test case")
            },
                onError: { error in
                    //received error from cache
                    onNextIsCalled.fulfill()
            },
                onCompleted: {
            },
                onDisposed: {
                    print("Test Disposed")
            }
            )
            .addDisposableTo(disposeBag)
        
        mockTestCacheApiService?.triggerEmptyResult()
        mockTestNetworkApiService?.triggerOnError()
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Time out during test!")
            XCTAssertEqual(self.mockTestCacheApiService?.loadCallCount, 1)
            XCTAssertEqual(self.mockTestNetworkApiService?.loadCallCount, 1)
        }
    }
}
