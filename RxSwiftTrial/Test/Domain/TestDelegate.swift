//
//  TestDelegate.swift
//  RxSwiftTrial
//
//  The delegate is in charge of loading data using ApiServices
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import RxSwift

protocol TestDelegate {
    //An Asynchronous load
    func load(params: [String: Any?]) -> Observable<TestModel>
}
