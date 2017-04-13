//
//  TestPresenterTest.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/20/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxSwiftTrial

//Testing the presenter interactions with the view and the delegate
class TestPresenterTest: XCTestCase {
    
    class MockTestDelegate : TestDelegate {
        var loadCallCount = 0
        var mockValue = TestModel(from: TestEntity(loadedFrom: "mock value"))
        var mockObserver: AnyObserver<TestModel>?
        
        func load(params: NSDictionary) -> Observable<TestModel> {
            return Observable.create { observer in
                self.loadCallCount += 1
                self.mockObserver = observer
                return Disposables.create()
            }
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
    
    class MockTestView : TestView {
        var testPresenter: TestPresenter?
        var displayMessageCallCount = 0
        var showErrorDialogCallCount = 0
        var showErrorMessageCallCount = 0
        var navigateToLoginCallCount = 0
        var showLoadingCallCount = 0
        var hideLoadingCallCount = 0
        
        func displayMessage(Message : String) {
            displayMessageCallCount += 1
        }
        
        func showErrorDialog(ErrorMessage : String) {
            showErrorDialogCallCount += 1
        }
        
        func showErrorMessage(ErrorMessage : String) {
            showErrorMessageCallCount += 1
        }
        
        func navigateToLogin() {
            navigateToLoginCallCount += 1
        }
        
        func showLoading() {
            showLoadingCallCount += 1
        }
        
        func  hideLoading() {
            hideLoadingCallCount += 1
        }
    }
    
    var mockTestView : MockTestView?
    var mockTestDelegate : MockTestDelegate?
    var mockTestPresenter : TestPresenterImpl?
    
    override func setUp() {
        super.setUp()
        mockTestView = MockTestView()
        mockTestDelegate = MockTestDelegate()
        mockTestPresenter = TestPresenterImpl(testView: mockTestView!, testDelegate: mockTestDelegate!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //check that calling load will trigger the delegate successfully
    func testLoadCallsDelegate() {
        mockTestPresenter!.load()
        
        XCTAssert(mockTestDelegate?.loadCallCount == 1)
    }
    
    //Check that calling load with success will generate the proper view calls
    func testLoadSuccess() {
        mockTestPresenter!.load()
      
        //the view shows the loading
        XCTAssert(mockTestView!.showLoadingCallCount == 1)
        XCTAssert(mockTestView!.hideLoadingCallCount == 0)
        
        //Trigger the delegate callback
        mockTestDelegate!.triggerOnNext()
        
        //Verify the results
        XCTAssert(mockTestView!.hideLoadingCallCount == 1)
        XCTAssert(mockTestView!.displayMessageCallCount == 1)
        XCTAssert(mockTestView!.navigateToLoginCallCount == 1)
        XCTAssert(mockTestView!.showErrorMessageCallCount == 0)
        XCTAssert(mockTestView!.showErrorDialogCallCount == 0)
    }
    
    //Check that calling load with an error will generate the proper view error calls
    func testLoadError() {
        mockTestPresenter!.load()
        
        //the view shows the loading
        XCTAssert(mockTestView!.showLoadingCallCount == 1)
        XCTAssert(mockTestView!.hideLoadingCallCount == 0)
        
        //Trigger the delegate callback
        mockTestDelegate!.triggerOnError()
        
        //Verify the results
        XCTAssert(mockTestView!.hideLoadingCallCount == 1)
        XCTAssert(mockTestView!.displayMessageCallCount == 0)
        XCTAssert(mockTestView!.navigateToLoginCallCount == 0)
        XCTAssert(mockTestView!.showErrorMessageCallCount == 0)
        XCTAssert(mockTestView!.showErrorDialogCallCount == 1)

    }
    
    //Check that calling load twice will not trigger several loading calls
    func testLoadAlreadyLoadingError() {
        mockTestPresenter!.load()
        mockTestPresenter!.load()
        
        //the view shows the loading
        XCTAssert(mockTestView!.showLoadingCallCount == 1)
        XCTAssert(mockTestView!.hideLoadingCallCount == 0)
        XCTAssert(mockTestView!.showErrorMessageCallCount == 1)
        
        //Trigger the delegate callback
        mockTestDelegate!.triggerOnNext()
        
        //Verify the results
        XCTAssert(mockTestView!.hideLoadingCallCount == 1)
        XCTAssert(mockTestView!.displayMessageCallCount == 1)
        XCTAssert(mockTestView!.navigateToLoginCallCount == 1)
        XCTAssert(mockTestView!.showErrorMessageCallCount == 1)
        XCTAssert(mockTestView!.showErrorDialogCallCount == 0)
    }
    
}
