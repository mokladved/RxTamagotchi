//
//  SettingTableViewCell.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let currentNameLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tgBlue
        accessoryType = .disclosureIndicator
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: SettingMenu, name: String?) {
        iconImageView.image = UIImage(systemName: item.imageName)
        titleLabel.text = item.title
        
        currentNameLabel.text = name
        currentNameLabel.isHidden = (name == nil)
    }
}

extension SettingTableViewCell: UIConfigurable {
    func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(currentNameLabel)
    }
    
    func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        currentNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        iconImageView.tintColor = .tgCyan
        titleLabel.textColor = .tgCyan
        titleLabel.font = .systemFont(ofSize: 15)
        currentNameLabel.textColor = .lightGray
        currentNameLabel.font = .systemFont(ofSize: 15)
    }
}
