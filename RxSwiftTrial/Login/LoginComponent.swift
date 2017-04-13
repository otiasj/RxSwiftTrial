//
//  LoginComponent.swift
//  RxSwiftTrial
//
//  The component tracks the lifecycle of objects instantiated in module
//
//  Created by Julien Saito on 3/15/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

class LoginComponent {
    
    private static var loginModule: LoginModule?
    
    func inject(loginView: LoginViewController) {
        LoginComponent.loginModule = LoginModule(loginView: loginView)
        if let loginModule = LoginComponent.loginModule {
            loginView.loginPresenter = loginModule.provideLoginPresenter()
        }
    }
}
