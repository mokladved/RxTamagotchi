//
//  BoxOfficeTableViewCell.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

import UIKit
import SnapKit

final class BoxOfficeTableViewCell: UITableViewCell, UIConfigurable {
    
    static let identifier = "BoxOfficeTableViewCell"
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let openDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(openDateLabel)
    }
    
    func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(40)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(rankLabel.snp.top).offset(-4)
            make.leading.equalTo(rankLabel.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
    
    func configureView() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func configure(with movie: DailyBoxOffice) {
        rankLabel.text = movie.rank
        movieTitleLabel.text = movie.movieNm
    }
}
