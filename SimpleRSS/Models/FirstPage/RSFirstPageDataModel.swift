//
//  RSFirstPageDataModel.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import SwiftSoup

struct RSFirstPageDataModel {
    var responseString: String?
    var status: RSResponseStatus
    var moyaError: MoyaError?

    var title: String?
    var items: [RSSItem]?

    init() {
        status = .failure
        moyaError = nil
        responseString = nil
    }

    struct RSSItem {
        var title: String?
        var link: String?
        var pubDate: String?
        var description: RSSItemDescription?
        var guid: String?
    }

    struct RSSItemDescription {
        var image: String?
        var text: String?
    }
}
