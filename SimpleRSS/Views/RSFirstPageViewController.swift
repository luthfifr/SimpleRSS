//
//  RSFirstPageViewController.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RSFirstPageViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var urlTextField: UITextField!
    private var submitButton: UIButton!

    private var viewModel: RSFirstPageViewModel!

    // MARK: - Initialization
    convenience init() {
        self.init(viewModel: RSFirstPageViewModel())
    }

    init(viewModel: RSFirstPageViewModel?) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = RSFirstPageViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        prepareSubmitButton()
        prepareTextField()
        setupEvents()
    }
}

extension RSFirstPageViewController {
    private func setupEvents() {
        viewModel
            .uiEvent
            .subscribe(onNext: { [weak self] event in
                guard let `self` = self else { return }
                switch event {
                case .openNextVC(let dataModel):
                    self.openNextVC(with: dataModel)
                case .openURLError(let error, let otherMsg):
                    self.showError(error, otherMsg)
                default: break
                }
            }).disposed(by: disposeBag)
    }

    private func setupUI() {
        setupButton()
        setupTextField()
    }

    private func setupTextField() {
        guard urlTextField == nil else { return }
        urlTextField = UITextField(frame: .zero)
        urlTextField.placeholder = "Input RSS Feed here..."
        urlTextField.borderStyle = .roundedRect
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .done
        urlTextField.clearButtonMode = .whileEditing
        urlTextField.translatesAutoresizingMaskIntoConstraints = false

        if !view.subviews.contains(urlTextField) {
            view.addSubview(urlTextField)
        }

        urlTextField.snp.makeConstraints({ make in
            make.bottom.equalTo(submitButton.snp.top).offset(-15)
            make.leading.equalTo(submitButton.snp.leading)
            make.trailing.equalTo(submitButton.snp.trailing)
        })
    }

    private func setupButton() {
        guard submitButton == nil else { return }
        submitButton = UIButton(frame: .zero)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .blue
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = true
        enableSubmit(false)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        if !view.subviews.contains(submitButton) {
            view.addSubview(submitButton)
        }

        submitButton.snp.makeConstraints({ make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    }

    private func enableSubmit(_ value: Bool) {
        submitButton.isUserInteractionEnabled = value
        submitButton.backgroundColor = value ? .blue : .darkGray
    }
}

extension RSFirstPageViewController {
    private func prepareTextField() {
        urlTextField
            .rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self,
                    let txt = self.urlTextField.text else { return }
                self.enableSubmit(!txt.isEmpty && txt.isValidURL)
            }).disposed(by: disposeBag)
    }

    private func prepareSubmitButton() {
        submitButton.rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self,
                    let txt = self.urlTextField.text else { return }
                self.viewModel.viewModelEvent.onNext(.open(url: txt))
            }).disposed(by: disposeBag)
    }

    private func openNextVC(with data: RSFirstPageDataModel) {
        let viewModel = RSMainViewModel()
        viewModel.dataModel = data
        let mainVC = RSMainViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(mainVC, animated: true)
    }

    private func showError(_ error: RSServiceError?, _ otherMsg: String?) {
        var alertModel = UIAlertModel(style: .alert)
        if let error = error {
            alertModel.message = error.responseString ?? String()
        } else if let msg = otherMsg {
            alertModel.message = msg
        }
        alertModel.title = "Request Data Failure"
        alertModel.actions = [UIAlertActionModel(title: "OK", style: .cancel)]
        self.showAlert(with: alertModel)
            .asObservable()
            .subscribe(onNext: { selectedActionIdx in
                #if DEBUG
                print("alert action index = \(selectedActionIdx)")
                #endif
            }).disposed(by: self.disposeBag)
    }
}
