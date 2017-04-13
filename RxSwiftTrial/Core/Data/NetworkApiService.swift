//
//  NetworkApiService.swift
//  RxSwiftTrial
//
//  This is used to send requests
//
//  Created by Julien Saito on 4/13/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkApiService: LoadService {
    associatedtype T

    func createUrl(_ parameters: ([String: Any?])?) -> URL
    func createParameters() -> [String: Any]?
    func createHeaders() -> [String: String]

    func post(url: URL, headers: [String: String], parameters: [String: Any]?, observer: AnyObserver<T>)

    func parseResult(_ value: [String: Any?]) -> T
}

extension NetworkApiService {

    func post(url: URL, headers: [String: String], parameters: [String: Any]?, observer: AnyObserver<T>) {
        debugPrint("Requesting \(url)")

        Alamofire.request(url, method: HTTPMethod.post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON { response in

            let result = response.result

            if result.isSuccess {
                debugPrint("Received Response \(response)")
                let data = self.parseResult(response.value as! [String: Any?])
                observer.onNext(data)
                observer.onCompleted()
            } else {
                if let error = result.error {
                    observer.onError(error)
                } else {
                    observer.onError(NSError(domain: "Unknown network error", code: 500))
                }
            }
        }
    }

    func createDefaultHeaders() -> [String: String] {
        return ["default": "http headers here"]
    }
}
