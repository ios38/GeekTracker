//
//  SafeView.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 10.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class SafeView: UIView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "GeekTracker \u{1F512}"
        self.titleLabel.font = .systemFont(ofSize: 24)
        self.titleLabel.textColor = .lightGray
        self.addSubview(self.titleLabel)

    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
