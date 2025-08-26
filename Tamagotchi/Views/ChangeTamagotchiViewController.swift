//
//  ChangeTamagotchiViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChangeTamagotchiViewController: BaseViewController {
    private var collectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let itemWidth = (UIScreen.main.bounds.width - (spacing * 4)) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        let insetSpacing = spacing * 0.8
        layout.sectionInset = UIEdgeInsets(top: insetSpacing, left: insetSpacing, bottom: insetSpacing, right: insetSpacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TamagotchiCollectionViewCell.self, forCellWithReuseIdentifier: TamagotchiCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let viewModel = ChangeTamagotchiViewModel()
    private let disposeBag = DisposeBag()
    
    
    private let changeConfirmed = PublishRelay<Tamagotchi>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tgBlue
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navBar = navigationController?.navigationBar {
            navBar.standardAppearance = UINavigationBar.appearance().standardAppearance
            navBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
        }
    }
    
    private func bind() {
        let input = ChangeTamagotchiViewModel.Input(
            itemSelected: collectionView.rx.itemSelected,
            changed: changeConfirmed
        )
        
        let output = viewModel.transform(input: input)
        
        output.tamagochis
            .drive(collectionView.rx.items(cellIdentifier: TamagotchiCollectionViewCell.identifier, cellType: TamagotchiCollectionViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        output.changeAlert
            .drive(onNext: { [weak self] tamagotchi in
                self?.showDetailPopup(for: tamagotchi)
            })
            .disposed(by: disposeBag)
        
        output.didChange
            .drive(with: self, onNext: { owner, _ in
                let homeVC = HomeViewController()
                owner.navigationController?.setViewControllers([homeVC], animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    // TODO: overCurrentContext로 구현하기 -> Done
    private func showDetailPopup(for tamagotchi: Tamagotchi) {
        let popupVC = TamagotchiDetailPopupViewController()
        popupVC.tamagotchi = tamagotchi
        
        popupVC.changeButtonTapped = { [weak self] in
            self?.changeConfirmed.accept(tamagotchi)
        }
        
        popupVC.modalPresentationStyle = .overCurrentContext
        present(popupVC, animated: true)
    }
}

private extension UIViewController {
    var isRootViewController: Bool {
        return navigationController?.viewControllers.first === self
    }
}

