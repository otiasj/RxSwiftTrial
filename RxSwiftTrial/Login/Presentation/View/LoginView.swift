//
//  LoginView.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/16/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//
//

protocol LoginView {
    var loginPresenter: LoginPresenter? { get set }
    
    func displayMessage(Message : String)
    func showErrorDialog(ErrorMessage : String)
    func showErrorMessage(ErrorMessage : String)
    func navigateToMain()
    
}
