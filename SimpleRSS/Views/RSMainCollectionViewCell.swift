//
//  RSMainCollectionViewCell.swift
//  SimpleRSS
//
//  Created by Luthfi Fathur Rahman on 06/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class RSMainCollectionViewCell: UICollectionViewCell {

    private var containerView: UIView!
    private var roundedCornerView: UIView!
    private var imgView: UIImageView!
    private var labelTitle: UILabel!
    private var labelDate: UILabel!
    private var labelDesc: UILabel!

    // MARK: - Initialization
    convenience init() {
        self.init()
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

// MARK: - Private methods
extension RSMainCollectionViewCell {
    private func setupViews() {
        setupContainerView()
        setupRoundedCornerView()
        setupImageView()
        setupLabelTitle()
        setupLabelDate()
        setupLabelDesc()
    }

    private func setupContainerView() {
        guard containerView == nil else { return }

        containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 2.5

        if !contentView.subviews.contains(containerView) {
            contentView.addSubview(containerView)
        }

        containerView.snp.makeConstraints({ make in
            make.leading
                .equalTo(contentView.snp.leading).offset(16)
            make.trailing
                .equalTo(contentView.snp.trailing).offset(-16)
            make.top
                .equalTo(contentView.snp.top).offset(16)
            make.bottom
                .equalTo(contentView.snp.bottom).offset(-16)
        })
    }

    private func setupRoundedCornerView() {
        guard roundedCornerView == nil else { return }
        roundedCornerView = UIView(frame: .zero)
        roundedCornerView.backgroundColor = .white
        roundedCornerView.layer.cornerRadius = 5
        roundedCornerView.layer.masksToBounds = true

        if !containerView.subviews.contains(roundedCornerView) {
            containerView.addSubview(roundedCornerView)
        }

        roundedCornerView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }

    private func setupImageView() {
        guard imgView == nil else {
            return
        }

        imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false

        if !roundedCornerView.subviews.contains(imgView) {
            roundedCornerView.addSubview(imgView)
        }

        imgView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(262)
        })
    }

    private func setupLabelTitle() {
        guard labelTitle == nil else {
            return
        }

        labelTitle = UILabel(frame: .zero)
        labelTitle.backgroundColor = .clear
        labelTitle.textColor = .black
        labelTitle.font = UIFont.systemFont(ofSize: 15)
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .left
        labelTitle.translatesAutoresizingMaskIntoConstraints = false

        if !roundedCornerView.subviews.contains(labelTitle) {
            roundedCornerView.addSubview(labelTitle)
        }

        labelTitle.snp.makeConstraints({ make in
            make.top.equalTo(imgView.snp.bottom).offset(15)
            make.leading.equalTo(roundedCornerView.snp.leading).offset(16)
            make.trailing.equalTo(roundedCornerView.snp.trailing).offset(-16)
        })
    }

    private func setupLabelDate() {
        guard labelDate == nil else {
            return
        }

        labelDate = UILabel(frame: .zero)
        labelDate.backgroundColor = .clear
        labelDate.textColor = UIColor.black.withAlphaComponent(0.5)
        labelDate.font = UIFont.systemFont(ofSize: 10)
        labelDate.numberOfLines = 0
        labelDate.textAlignment = .left
        labelDate.translatesAutoresizingMaskIntoConstraints = false

        if !roundedCornerView.subviews.contains(labelDate) {
            roundedCornerView.addSubview(labelDate)
        }

        labelDate.snp.makeConstraints({ make in
            make.top.equalTo(labelTitle.snp.bottom).offset(5)
            make.leading.equalTo(labelTitle.snp.leading)
            make.trailing.equalTo(labelTitle.snp.trailing)
        })
    }

    private func setupLabelDesc() {
        guard labelDesc == nil else {
            return
        }

        labelDesc = UILabel(frame: .zero)
        labelDesc.backgroundColor = .clear
        labelDesc.textColor = UIColor.black.withAlphaComponent(0.75)
        labelDesc.font = UIFont.systemFont(ofSize: 12)
        labelDesc.numberOfLines = 0
        labelDesc.textAlignment = .left
        labelDesc.translatesAutoresizingMaskIntoConstraints = false

        if !roundedCornerView.subviews.contains(labelDesc) {
            roundedCornerView.addSubview(labelDesc)
        }

        labelDesc.snp.makeConstraints({ make in
            make.top.equalTo(labelDate.snp.bottom).offset(10)
            make.leading.equalTo(labelTitle.snp.leading)
            make.trailing.equalTo(labelTitle.snp.trailing)
            make.bottom.equalToSuperview().offset(-16)
        })
    }
}

// MARK: - Public methods
extension RSMainCollectionViewCell {
    func setData(with data: RSFirstPageDataModel.RSSItem) {
        imgView.sd_setImage(with: URL(string: data.description?.image ?? String())) { [weak self] image, error, _, _ in
            guard let `self` = self else { return }
            if let error = error {
                #if DEBUG
                print("download article image error: \(error.localizedDescription)")
                #endif
            }

//            if image == nil {
//                self.bannerImgView.image = UIImage(named: "banner-hci")
//            }
        }
        labelTitle.text = data.title ?? String()
        labelDate.text = data.pubDate ?? String()
        labelDesc.text = data.description?.text ?? String()
    }
}
