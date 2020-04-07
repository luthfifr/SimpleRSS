//
//  RSFirstPageService.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import RxSwift
import Moya
import SwiftSoup

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
                response.status = .success
                response.responseString = responseString
                var items = [RSFirstPageDataModel.RSSItem]()
                if let elements = self.parse(responseString) {
                    response.title = elements.0
                    for element in elements.1 {
                        let currTitle = try element.getElementsByTag("title").text()
                        let currLink = try element.getElementsByTag("link").text()
                        let currPubDate = try element.getElementsByTag("pubDate").text()
                        let currGuid = try element.getElementsByTag("guid").text()
                        let currDescText = try element.getElementsByTag("description").text()
                        let currDescParsed = try SwiftSoup.parse(currDescText)
                        let imgSrc = try currDescParsed.getElementsByTag("img").attr("src")
                        let desctext = try currDescParsed.text()
                        let currDesc = RSFirstPageDataModel.RSSItemDescription(image: imgSrc, text: desctext)
                        let currItem = RSFirstPageDataModel.RSSItem(title: currTitle, link: currLink, pubDate: currPubDate, description: currDesc, guid: currGuid) //swiftlint:disable:this line_length
                        items.append(currItem)
                    }
                    response.items = items
                }

                return response
            })
            .mapFailures { error in
                return .failed(error)
            }
    }

    private func parse(_ page: String) -> (String, Elements)? {
        //swiftlint:disable:next line_length
        guard let doc = try? SwiftSoup.parse(page, "", Parser.xmlParser()), let items = try? doc.getElementsByTag("item"), let channelTitle = try? doc.getElementsByTag("title").first()?.text() else {
            return nil
        }
        return (channelTitle, items)
    }
}
