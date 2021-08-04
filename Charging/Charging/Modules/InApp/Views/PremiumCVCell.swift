//
//  PremiumCVCell.swift
//  Drama_iOS
//
//  Created by Nguyễn Hải Âu on 3/29/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit

class PremiumCVCell: UICollectionViewCell {
    
    static let identifier2 = "PremiumCVCell"
    
    let titleLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "One Week"
        l.textColor = .white
        l.font = .systemFont(ofSize: 13)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    let priceLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "1.99$"
        l.textColor = .white
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 2 : 0
            self.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        }
    }
    
}
