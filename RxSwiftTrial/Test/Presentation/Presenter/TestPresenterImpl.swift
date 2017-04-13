//
//  TestPresenterImpl.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import RxSwift

class TestPresenterImpl: TestPresenter
{
    let disposeBag = DisposeBag()
    var isLoading = false
    var testView: TestView
    var testDelegate: TestDelegate
    
    // MARK: lifecycle
    init(testView: TestView,
        testDelegate: TestDelegate) {
        self.testView = testView
        self.testDelegate = testDelegate
    }
    
    // MARK: - main presenter logic
    func load()
    {
        if (!isLoading) {
            isLoading = true
            testView.showLoading()
            print("Test loading...")
            testDelegate.load(params: ["Some parameter key": "Some parameter value"])
                .subscribe(
                    onNext: { testEntity in
                        print("onNext")
                        self.onResponse(testEntity)
                },
                    onError: { error in
                        print(error)
                        self.onError(error)
                },
                    onCompleted: {
                        print("Completed")
                        self.onComplete()
                },
                    onDisposed: {
                        print("Disposed")
                }
                )
                .addDisposableTo(disposeBag)
        } else {
            testView.showErrorMessage(ErrorMessage: "Already Loading")
        }
    }
    
    // MARK: - load Event handling
    func onResponse(_ testEntity: TestEntity) {
        testView.displayMessage(Message: "testEntity loaded")
        testView.navigateToLogin()
    }
    
    func onError(_ error: Error) {
        testView.hideLoading()
        testView.showErrorDialog(ErrorMessage: error.localizedDescription)
    }
    
    func onComplete()
    {
        testView.hideLoading()
        isLoading = false
    }
}
