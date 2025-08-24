//
//  NameSettingViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameSettingViewController: BaseViewController {
    
    private let nameTextField = {
        let textField = UnderlineTextField()
        textField.textColor = .tgCyan
        textField.font = .systemFont(ofSize: 14)
        return textField
    }()
    
    
    private let saveButton = {
        let button = UIBarButtonItem(title: Constants.UI.Title.save, style: .done, target: NicknameSettingViewController.self, action: nil)
        button.tintColor = .tgCyan
        return button
    }()
    
    private let viewModel = NicknameSettingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(nameTextField)
    }
    
    override func configureLayout() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func bind() {
        let input = NicknameSettingViewModel.Input(
            nicknameText: nameTextField.rx.text,
            saveButtonTapped: saveButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentNickname
            .map { nickname in
                "\(nickname)님 이름 정하기" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.currentNickname
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isNicknameValid
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        output.didSave
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

