//
//  BoxOfficeViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire
import Toast

final class BoxOfficeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = BoxOfficeViewModel()
    private let dailyBoxOfficeList = BehaviorRelay<[DailyBoxOffice]>(value: [])
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        view.backgroundColor = .clear
        view.rowHeight = 50
        view.separatorStyle = .singleLine
        return view
    }()
    
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.titleView = searchBar
        
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.tintColor = .systemBlue
        searchBar.backgroundImage = UIImage()
    }
    
    private func bind() {
        let input = BoxOfficeViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        output.dailyBoxOfficeList
            .drive(tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        
        output.showToast
            .drive(with: self, onNext: { owner, message in
                owner.showToast(message: message)
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        
        output.showAlert
            .drive(with: self, onNext: { owner, message in
                owner.showAlert(message: message)
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func showToast(message: String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
