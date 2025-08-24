//
//  TamagotchiCollectionViewCell.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit
import SnapKit

final class TamagotchiCollectionViewCell: UICollectionViewCell {
    static let identifier = "TamagotchiCollectionViewCell"
    
    private let imageView = UIImageView()
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .tgCyan
        label.textAlignment = .center
        label.layer.borderColor = UIColor.tgCyan.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with tamagotchi: Tamagotchi) {
        imageView.image = UIImage(named: tamagotchi.type.baseImageName)
        nameLabel.text = tamagotchi.name
    }
}

extension TamagotchiCollectionViewCell: UIConfigurable {
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.horizontalEdges.equalTo(imageView)
        }
    }
    
    func configureView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        backgroundColor = .clear
        
    }
}

