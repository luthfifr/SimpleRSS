//
//  RSNetworkEvent.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum RSNetworkEvent<ResponseType> {
    case waiting
    case succeeded(ResponseType)
    case failed(RSServiceError)
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func parseResponse<T>(_ parse: @escaping (String) throws -> T) -> Observable<RSNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            let responseString = String(data: response.data, encoding: String.Encoding.utf8)!

            return try parse(responseString)
        })
    }

    func parseDataResponse<T>(_ parse: @escaping (Data) throws -> T) -> Observable<RSNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            return try parse(response.data)
        })
    }

    func parseResponse<T>(_ parse: @escaping (Response) throws -> T) -> Observable<RSNetworkEvent<T>> {
        return self
            .map { response -> RSNetworkEvent<T> in
                if response.is2xx() {
                    do {
                        return try .succeeded(parse(response))
                    } catch let error {
                        var serviceError = RSServiceError()
                        serviceError.responseString = error.localizedDescription

                        return .failed(serviceError)
                    }
                } else {
                    guard let responseString = String(data: response.data, encoding: String.Encoding.utf8) else {
                        return .failed(RSServiceError())
                    }

                    var serviceError = RSServiceError()
                    serviceError.status = .failure
                    serviceError.responseString = responseString

                    return .failed(serviceError)
                }
            }
            .asObservable()
            .startWith(.waiting)
    }
}

extension Observable where Element == RSNetworkEvent<Any> {
    func mapFailures<T>(_ failure: @escaping (RSServiceError) -> RSNetworkEvent<T>) -> Observable<RSNetworkEvent<T>> {
        return self
            .map { event -> RSNetworkEvent<T> in
                switch event {
                case .succeeded(let val):
                    guard let tval = val as? T else {
                        let serviceError = RSServiceError()
                        return .failed(serviceError)
                    }

                    return .succeeded(tval)

                case .waiting:
                    return .waiting

                case .failed(let error):
                    return failure(error)
                }
            }
    }
}

extension RSNetworkEvent: Equatable {
    public static func == (lhs: RSNetworkEvent, rhs: RSNetworkEvent) -> Bool {
        switch (lhs, rhs) {
        case (.waiting, .waiting):
            return true

        case (.succeeded, .succeeded):
            return true

        case (.failed(let errorLHS), .failed(let errorRHS)):
            return errorLHS == errorRHS

        default:
            return false
        }
    }
}
