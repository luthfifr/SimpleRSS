//
//  RSMainViewController.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 06/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class RSMainViewController: UIViewController {
    typealias Cell = RSMainCollectionViewCell
    private var viewModel: RSMainViewModel!
    private let disposeBag = DisposeBag()

    private var collectionView: UICollectionView!

    private let cellID = String(describing: Cell.self)
    private let cellPadding: CGFloat = 16
    private let cellHeight: CGFloat = 436

    // MARK: - Initialization
    convenience init() {
        self.init(viewModel: RSMainViewModel())
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

        title = "RSS Reader"
        view.backgroundColor = .white

        setupEvents()
        setupUI()
    }
}

extension RSMainViewController {
    private func setupUI() {
        setupCollectionView()
    }

    private func setupEvents() {
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: cellID)

        if !view.subviews.contains(collectionView) {
            view.addSubview(collectionView)
        }

        collectionView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}

extension RSMainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        return cell
    }
}

extension RSMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.setData()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
}

extension RSMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-cellPadding, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellPadding, left: 0, bottom: cellPadding, right: 0)
    }
}
