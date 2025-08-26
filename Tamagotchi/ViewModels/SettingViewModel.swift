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
        let resetConfirmed: PublishRelay<Void>
    }
    
    struct Output {
        let settingOptions: Driver<[SettingMenu]>
        let currentNickname: Driver<String>
        let nameSettingTapped: PublishRelay<Void>
        let changeTamagotchiTapped: PublishRelay<Void>
        let resetTapped: PublishRelay<Void>
        let didReset: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nameSettingTappedRelay = PublishRelay<Void>()
        let changeTamagotchiTappedRelay = PublishRelay<Void>()
        let resetTappedRelay = PublishRelay<Void>()
        
        let settingOptions = Observable.just(settingMenus)
            .asDriver(onErrorJustReturn: [])
        
        let nicknameDriver = TamagotchiManager.shared.currentTamagotchi
            .map { tamagotchi in
                tamagotchi.nickname }
            .asDriver(onErrorJustReturn: "")
        
        let selectedRow = input.cellSelected.map { indexPath in
            indexPath.row }
        
        let resetCompleteRelay = PublishRelay<Void>()
        
        input.resetConfirmed
            .subscribe(with: self) { owner, _ in
                
                TamagotchiManager.shared.reset()
                
                
                resetCompleteRelay.accept(())
            }
            .disposed(by: disposeBag)
        
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
            currentNickname: nicknameDriver,
            nameSettingTapped: nameSettingTappedRelay,
            changeTamagotchiTapped: changeTamagotchiTappedRelay,
            resetTapped: resetTappedRelay,
            didReset: resetCompleteRelay
        )
    }
    
    func resetData() {
        TamagotchiManager.shared.reset()
        let didReset = Notification.Name(Keys.didReset)
        NotificationCenter.default.post(name: didReset, object: nil)
    }
}
