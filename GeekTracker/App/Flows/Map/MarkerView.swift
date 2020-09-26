//
//  MarkerView.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 25.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import SnapKit

class MarkerView: UIView {
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSubviews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
}
