//
//  NameSettingViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameSettingViewModel {
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let saveButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isNicknameValid: Driver<Bool>
        let didSave: Driver<Void>
        let currentNickname: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let didSaveRelay = PublishRelay<Void>()
        let currentNickname = TamagotchiManager.shared.currentTamagotchi
            .map { tamagotchi in
                tamagotchi.nickname }
            .asDriver(onErrorJustReturn: "대장")
        
        let isNameValid = input.nicknameText
            .orEmpty
            .map { text in
                return (2...6).contains(text.count)
            }
            .asDriver(onErrorJustReturn: false)
        
        
        input.saveButtonTapped
            .withLatestFrom(input.nicknameText.orEmpty)
            .bind(with: self) { owner, name in
                owner.saveNickname(name)
                didSaveRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            isNicknameValid: isNameValid,
            didSave: didSaveRelay.asDriver(onErrorJustReturn: ()),
            currentNickname: currentNickname
        )
    }
    
    
    private func saveNickname(_ nickname: String) {
        var tamagotchi = TamagotchiManager.shared.load()
        tamagotchi.nickname = nickname
        TamagotchiManager.shared.save(tamagotchi)
    }
}
