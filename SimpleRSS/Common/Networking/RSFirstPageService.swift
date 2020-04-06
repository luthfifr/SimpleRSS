//
//  RSFirstPageService.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import RxSwift
import Moya

protocol RSFirstPageServiceType {
    func openURL(_ str: String) -> Observable<RSNetworkEvent<RSFirstPageDataModel>>
}

struct RSFirstPageService: RSFirstPageServiceType {
    private let provider: RSMoyaProvider<RSFirstPageTarget>

    init() {
        provider = RSMoyaProvider<RSFirstPageTarget>()
    }

    init(provider: RSMoyaProvider<RSFirstPageTarget>) {
        self.provider = provider
    }

    func openURL(_ str: String) -> Observable<RSNetworkEvent<RSFirstPageDataModel>> {
        return provider.rx.request(.openURL(str))
            .parseResponse({ (responseString: String) in
                var response = RSFirstPageDataModel()
                response.responseString = responseString

                return response
            })
            .mapFailures { error in
                return .failed(error)
            }
    }
}
