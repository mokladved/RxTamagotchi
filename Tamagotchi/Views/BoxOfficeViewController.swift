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

class BoxOfficeViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    let dailyBoxOfficeList = BehaviorRelay<[DailyBoxOffice]>(value: [])
    
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
    
    func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .filter { date in
                let isValid = (date.count == 8 && Int(date) != nil)
                if !isValid {
                    print("올바른 날짜 형식을 입력하세요.")
                }
                return isValid
            }
            .flatMap { date -> Observable<[DailyBoxOffice]> in
                return CustomObservable.fetchBoxOffice(date: date)
                    .catch { error in
                        print("에러: \(error.localizedDescription)")
                        return .empty() 
                    }
            }
            .bind(to: dailyBoxOfficeList)
            .disposed(by: disposeBag)

        dailyBoxOfficeList
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
