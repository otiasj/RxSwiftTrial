//
//  TestView.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//
//

protocol TestView {
    var testPresenter: TestPresenter? { get set }
    
    func displayMessage(Message : String)
    func showErrorDialog(ErrorMessage : String)
    func showErrorMessage(ErrorMessage : String)
    func navigateToLogin()
    func showLoading()
    func hideLoading()
}
