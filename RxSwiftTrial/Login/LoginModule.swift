//
//  LoginModule.swift
//  RxSwiftTrial
//
//  This class is in charge of initializing and creating instances for this feature
//
//  Created by Julien Saito on 3/15/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

class LoginModule {
    
    //the instances
    private let loginView: LoginView
    private let loginPresenter: LoginPresenter
    private let loginDelegate: LoginDelegate
    
    //Be careful in the order of the creation of instances
    init(loginView: LoginView) {
        self.loginView = loginView
        self.loginDelegate = LoginDelegateImpl()
        self.loginPresenter = LoginPresenterImpl(loginView: loginView, loginDelegate: loginDelegate)
    }
    
    func provideLoginPresenter() -> LoginPresenter {
       return loginPresenter
    }
    
}
