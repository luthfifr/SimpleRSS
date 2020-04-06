//
//  RSMainViewModel.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 06/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import RxSwift

enum RSMainViewModelEvents: Equatable {
}

protocol RSMainViewModelType {
    var uiEvents: PublishSubject<RSMainViewModelEvents> { get }
    var viewModelEvents: PublishSubject<RSMainViewModelEvents> { get }
//    var responseData: USResponse? { get }
}

final class RSMainViewModel: RSMainViewModelType {
    let uiEvents = PublishSubject<RSMainViewModelEvents>()
    let viewModelEvents = PublishSubject<RSMainViewModelEvents>()
}
