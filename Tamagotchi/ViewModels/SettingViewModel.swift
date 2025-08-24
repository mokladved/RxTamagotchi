//
//  SettingViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    private let settingMenus: [SettingMenu] = [
        SettingMenu(title: Constants.UI.Title.setName, imageName: Constants.UI.Title.pencil),
        SettingMenu(title: Constants.UI.Title.changeTG, imageName: Constants.UI.Title.moon),
        SettingMenu(title: Constants.UI.Title.reset, imageName: Constants.UI.Title.clockwise)
    ]
    
    struct Input {
        let cellSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let settingOptions: Driver<[SettingMenu]>
        let nameSettingTapped: PublishRelay<Void>
        let changeTamagotchiTapped: PublishRelay<Void>
        let resetTapped: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nameSettingTappedRelay = PublishRelay<Void>()
        let changeTamagotchiTappedRelay = PublishRelay<Void>()
        let resetTappedRelay = PublishRelay<Void>()
        
        let settingOptions = Observable.just(settingMenus)
            .asDriver(onErrorJustReturn: [])
        
        let selectedRow = input.cellSelected.map { indexPath in
            indexPath.row }
        
        selectedRow
            .filter { row in
                row == 0 }
            .map { _ in () }
            .bind(to: nameSettingTappedRelay)
            .disposed(by: disposeBag)
        
        
        selectedRow
            .filter { row in
                row == 1 }
            .map { _ in () }
            .bind(to: changeTamagotchiTappedRelay)
            .disposed(by: disposeBag)
        
        selectedRow
            .filter { row in
                row == 2 }
            .map { _ in () }
            .bind(to: resetTappedRelay)
            .disposed(by: disposeBag)
        
        return Output(
            settingOptions: settingOptions,
            nameSettingTapped: nameSettingTappedRelay,
            changeTamagotchiTapped: changeTamagotchiTappedRelay,
            resetTapped: resetTappedRelay
        )
    }
    
    func resetData() {
        TamagotchiManager.shared.reset()
    }
}
