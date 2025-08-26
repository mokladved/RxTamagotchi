//
//  ViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    let settingButton = UIBarButtonItem(
        image: Constants.UI.symbolImage.profile,
        style: .plain,
        target: nil,
        action: nil)
    
    let chatImageView = {
        let imageView = UIImageView()
        imageView.image = .bubble
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let chatLabel = {
        let label = UILabel()
        label.textColor = .tgCyan
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let stateWrappedView = UIView()
    
    let tamagotchiImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = .tgCyan
        label.textAlignment = .center
        label.layer.borderColor = UIColor.tgCyan.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5
        return label
    }()
    
    let stateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = .tgCyan
        label.textAlignment = .center
        return label
    }()
    
    let riceTextField = UnderlineTextField()
    
    let riceButton = {
        let button = UIButton()
        button.dalkomStyle(
            title: Constants.UI.Title.eatRice,
            image: Constants.UI.symbolImage.rice
        )
        return button
    }()
    
    let waterTextField = UnderlineTextField()
    
    let waterButton = {
        let button = UIButton()
        button.dalkomStyle(
            title: Constants.UI.Title.drinkWater,
            image: Constants.UI.symbolImage.water
        )
        return button
    }()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(handleResetRequest), name: Notification.Name(Keys.didReset), object: nil)
    }
    
    override func configureHierarchy() {
        view.addSubview(chatImageView)
        chatImageView.addSubview(chatLabel)
        
        view.addSubview(stateWrappedView)
        stateWrappedView.addSubview(tamagotchiImageView)
        stateWrappedView.addSubview(nameLabel)
        stateWrappedView.addSubview(stateLabel)
        
        view.addSubview(riceTextField)
        view.addSubview(riceButton)
        view.addSubview(waterTextField)
        view.addSubview(waterButton)
    }
    
    override func configureLayout() {
        chatImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(120)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        stateWrappedView.snp.makeConstraints { make in
            make.top.equalTo(chatImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
        }
        
        tamagotchiImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(tamagotchiImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagotchiImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(30)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        riceButton.snp.makeConstraints { make in
            make.top.equalTo(stateWrappedView.snp.bottom).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }
        
        riceTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.trailing.equalTo(riceButton.snp.leading).offset(-8)
            make.centerY.equalTo(riceButton)
            make.height.equalTo(40)
        }
        
        waterButton.snp.makeConstraints { make in
            make.top.equalTo(riceButton.snp.bottom).offset(8)
            make.trailing.equalTo(riceButton)
            make.size.equalTo(riceButton)
        }
        
        waterTextField.snp.makeConstraints { make in
            make.leading.equalTo(riceTextField)
            make.trailing.equalTo(waterButton.snp.leading).offset(-8)
            make.centerY.equalTo(waterButton)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.rightBarButtonItem = settingButton
        
        riceTextField.attributedPlaceholder = NSAttributedString(string: Constants.UI.Message.giveMeRice, attributes: [.foregroundColor: UIColor.systemGray])
        riceTextField.textAlignment = .center
        
        waterTextField.attributedPlaceholder = NSAttributedString(string: Constants.UI.Message.giveMeWater, attributes: [.foregroundColor: UIColor.systemGray])
        waterTextField.textAlignment = .center
        
        navigationItem.backButtonTitle = ""
    }
    
    func bind() {
        let input = HomeViewModel.Input(
            riceAmountText: riceTextField.rx.text,
            waterAmountText: waterTextField.rx.text,
            riceButtonTap: riceButton.rx.tap,
            waterButtonTap: waterButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigationTitle.drive(navigationItem.rx.title).disposed(by: disposeBag)
        output.bubbleText.drive(chatLabel.rx.text).disposed(by: disposeBag)
        output.tamagotchiImage.drive(tamagotchiImageView.rx.image).disposed(by: disposeBag)
        output.nameText.drive(nameLabel.rx.text).disposed(by: disposeBag)
        output.statusText
            .drive(stateLabel.rx.text)
            .disposed(by: disposeBag)
        
        riceButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.riceTextField.text = ""
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        waterButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.waterTextField.text = ""
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .bind(with: self) { owner, _ in
                let settingVC = SettingViewController()
                owner.navigationController?.pushViewController(settingVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}

extension HomeViewController {
    @objc private func handleResetRequest() {
        
        if !(self.navigationController?.topViewController is ChangeTamagotchiViewController) {
            let changeVC = ChangeTamagotchiViewController()
            changeVC.title = Constants.UI.Title.selectTG
            
            self.navigationController?.pushViewController(changeVC, animated: true)
        }
    }
}
