//
//  RSFirstPageTarget.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

enum RSFirstPageTarget {
    case openURL(_ str: String)
}

extension RSFirstPageTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .openURL(let str):
            return URL(string: str) ?? URL(string: "")!
        }
    }

    var path: String {
        switch self {
        case .openURL:
            return String()
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .openURL:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .openURL:
            return Data()
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
