//
//  RSMainViewController.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 06/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import RxSwift

class RSMainViewController: UIViewController {
    private var viewModel: RSMainViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Initialization
    convenience init() {
        self.init(viewModel: nil)
    }

    init(viewModel: RSMainViewModel?) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = RSMainViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
