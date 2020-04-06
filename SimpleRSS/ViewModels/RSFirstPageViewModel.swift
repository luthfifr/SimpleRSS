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
}

final class RSFirstPageViewModel {
    let viewModelEvent = PublishSubject<RSFirstPageViewModelEvent>()
    let uiEvent = PublishSubject<RSFirstPageViewModelEvent>()
    let disposeBag = DisposeBag()
}
