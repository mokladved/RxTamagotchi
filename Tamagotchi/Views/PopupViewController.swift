//
//  PopupViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

import UIKit
import SnapKit

final class TamagotchiDetailPopupViewController: UIViewController {
    var tamagotchi: Tamagotchi?
    var changeButtonTapped: (() -> Void)?

    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private let popupView = {
        let view = UIView()
        view.backgroundColor = .tgBlue
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let tamagotchiImageView = UIImageView()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .tgCyan
        label.textAlignment = .center
        label.layer.borderColor = UIColor.tgCyan.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .tgCyan
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .tgCyan.withAlphaComponent(0.8)
        return view
    }()
    
    private lazy var cancelButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.tgCyan, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeButton = {
        let button = UIButton()
        button.setTitle("선택하기g", for: .normal)
        button.setTitleColor(.tgCyan, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(changeButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configure()
    }
    
    private func configureHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(popupView)
        
        popupView.addSubview(tamagotchiImageView)
        popupView.addSubview(nameLabel)
        popupView.addSubview(descriptionLabel)
        popupView.addSubview(dividerView)
        popupView.addSubview(cancelButton)
        popupView.addSubview(changeButton)
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        tamagotchiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagotchiImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
    }
    
    private func configure() {
        guard let tamagotchi else {
            return
        }
        
        tamagotchiImageView.image = UIImage(named: tamagotchi.type.baseImageName)
        nameLabel.text = tamagotchi.name
        descriptionLabel.text = tamagotchi.type.description
    }

    
    @objc private func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func changeButtonDidTapped() {
        dismiss(animated: true) { [weak self] in
            self?.changeButtonTapped?()
        }
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.tgCyan, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
