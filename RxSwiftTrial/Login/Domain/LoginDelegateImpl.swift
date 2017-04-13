//
//  LoginDelegateImpl.swift
//  RxSwiftTrial
//
//  Created by Julien Saito on 3/16/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

import RxSwift

class LoginDelegateImpl : LoginDelegate {
    
    func login() -> Observable<LoginEntity> {
        return Observable<LoginEntity>.just(LoginEntity())
    }
}
