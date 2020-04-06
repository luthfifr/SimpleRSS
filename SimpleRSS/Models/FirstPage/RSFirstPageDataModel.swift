//
//  RSFirstPageDataModel.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

struct RSFirstPageDataModel {
    var responseString: String?
    var status: RSResponseStatus
    var moyaError: MoyaError?

    init() {
        status = .failure
        moyaError = nil
        responseString = nil
    }
}
