//
//  RSServiceError.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

enum RSResponseStatus: String {
    case success
    case failure
}

struct RSServiceError {
    var responseString: String?
    var status: RSResponseStatus
    var error: MoyaError?

    init() {
        status = .failure
        error = nil
        responseString = nil
    }
}

extension RSServiceError: Equatable {
    public static func == (lhs: RSServiceError, rhs: RSServiceError) -> Bool {
        return lhs.responseString == rhs.responseString &&
            lhs.status == rhs.status
    }
}
