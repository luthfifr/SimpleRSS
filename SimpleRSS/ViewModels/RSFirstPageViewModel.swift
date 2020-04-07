//
//  RSFirstPageViewModel.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import RxSwift

enum RSFirstPageViewModelEvent {
    case open(url: String)
    case openNextVC(data: RSFirstPageDataModel)
}

final class RSFirstPageViewModel {
    let viewModelEvent = PublishSubject<RSFirstPageViewModelEvent>()
    let uiEvent = PublishSubject<RSFirstPageViewModelEvent>()

    private let disposeBag = DisposeBag()
    private var service: RSFirstPageService!

    init() {
        self.service = RSFirstPageService()
        setupEvents()
    }

    init(service: RSFirstPageService) {
        self.service = service
        setupEvents()
    }
}

// MARK: - Private methods
extension RSFirstPageViewModel {
    private func setupEvents() {
        viewModelEvent.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .open(let url):
                self.openURL(with: url)
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func openURL(with url: String) {
        service
            .openURL(url)
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else { return }
                switch response {
                case .waiting: break
                case .succeeded(let dataModel):
                    guard let responseStr = dataModel.responseString, !responseStr.contains("html") else {
                        print("the webpage is HTML, not XML")
                        return
                    }
                    self.uiEvent.onNext(.openNextVC(data: dataModel))
                case .failed(let error):
                    print(error.error?.errorDescription ?? String())
                }
            }).disposed(by: disposeBag)
    }
}
