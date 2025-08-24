//
//  SettingViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {
    
    private let tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = 50
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let viewModel = SettingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = Constants.UI.Title.setting
    }
    
    private func bind() {
        let input = SettingViewModel.Input(
            cellSelected: tableView.rx.itemSelected
        )
        
        let output = viewModel.transform(input: input)
        
        output.settingOptions
            .drive(tableView.rx.items(cellIdentifier: SettingTableViewCell.identifier, cellType: SettingTableViewCell.self)) { row, element, cell in
                
                if row == 0 {
                    let currentName = TamagotchiManager.shared.load().nickname
                    cell.configure(with: element, name: currentName)
                } else {
                    cell.configure(with: element, name: nil)
                }
            }
            .disposed(by: disposeBag)
        
        output.currentNickname
            .drive(with: self) { owner, nickname in
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = owner.tableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.updateNickname(nickname)
                }
            }
            .disposed(by: disposeBag)
        
        output.nameSettingTapped
            .bind(with: self) { owner, _ in
                 let nicknameSettingVC = NicknameSettingViewController()
                 owner.navigationController?.pushViewController(nicknameSettingVC, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        output.changeTamagotchiTapped
            .bind(with: self) { owner, _ in
                let changeVC = ChangeTamagotchiViewController()
                changeVC.title = Constants.UI.Title.changeTG
                changeVC.didSelect = { [weak owner] in
                    owner?.navigationController?.popViewController(animated: true)
                }
                
                owner.navigationController?.pushViewController(changeVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.resetTapped
            .bind(with: self) { owner, _ in
                owner.showResetAlert()
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func showResetAlert() {
        let alert = UIAlertController(title: Constants.UI.Title.reset, message: Constants.UI.Message.reset, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: Constants.UI.Message.yes, style: .default) { [weak self] _ in
            self?.viewModel.resetData()
        }
        
        let cancelAction = UIAlertAction(title:  Constants.UI.Message.no, style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
