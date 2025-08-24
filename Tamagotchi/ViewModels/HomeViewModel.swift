//
//  HomeViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel {
    private let tGManager = TamagotchiManager.shared
    private let tamagotchiState: BehaviorRelay<Tamagotchi>
    private let bubbleRelay: BehaviorRelay<String>
    
    struct Input {
        let riceAmountText: ControlProperty<String?>
        let waterAmountText: ControlProperty<String?>
        let riceButtonTap: ControlEvent<Void>
        let waterButtonTap: ControlEvent<Void>
        
    }
    
    struct Output {
        let navigationTitle: Driver<String>
        let bubbleText: Driver<String>
        let tamagotchiImage: Driver<UIImage?>
        let nameText: Driver<String>
        let levelText: Driver<String>
        let riceCountText: Driver<String>
        let waterCountText: Driver<String>
        let statusText: Driver<String>
        
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        let initialTamagotchi = tGManager.load()
        self.tamagotchiState = BehaviorRelay(value: initialTamagotchi)
        
        let firstMessage = Messages.shuffle(for: initialTamagotchi.nickname)
        self.bubbleRelay = BehaviorRelay(value: firstMessage)
        
        tamagotchiState
            .subscribe(with: self) { owner, tamagotchi in
                owner.tGManager.save(tamagotchi)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        input.riceButtonTap
            .withLatestFrom(input.riceAmountText.orEmpty)
            .map { text in
                Int(text) ?? 1
            }
            .subscribe(with: self) { owner, amount in
                var current = owner.tamagotchiState.value
                
                guard amount > 0, amount < 100 else {
                    owner.bubbleRelay.accept("밥알은 1~99개까지 먹을 수 있어요!")
                    return
                }
                
                current.riceCount += amount
                owner.tamagotchiState.accept(current)
                owner.bubbleRelay.accept(Messages.shuffle(for: current.nickname))
            }
            .disposed(by: disposeBag)
        
        
        input.waterButtonTap
            .withLatestFrom(input.waterAmountText.orEmpty)
            .map { text in Int(text) ?? 1 }
            .subscribe(with: self) { owner, amount in
                var current = owner.tamagotchiState.value
                
                guard amount > 0, amount < 50 else {
                    owner.bubbleRelay.accept("물방울은 1~49개까지 마실 수 있어요!")
                    return
                }
                
                current.dropletCount += amount
                owner.tamagotchiState.accept(current)
                owner.bubbleRelay.accept(Messages.shuffle(for: current.nickname))
            }
            .disposed(by: disposeBag)
        
        let navigationTitle = tamagotchiState
            .map { tamagotchi in
                "\(tamagotchi.nickname)님의 다마고치"
            }
            .asDriver(onErrorJustReturn: "")
        
        let tamagotchiImage = tamagotchiState
            .map { tamagotchi in
                UIImage(named: "2-\(tamagotchi.level)")
            }
            .asDriver(onErrorJustReturn: nil)
        
        let nameText = tamagotchiState
            .map { _ in "방실방실 다마고치" }
            .asDriver(onErrorJustReturn: "")
        
        let levelText = tamagotchiState
            .map { tamagotchi in
                "LV\(tamagotchi.level)"
            }
            .asDriver(onErrorJustReturn: "")
        
        let statusText = tamagotchiState
            .map { tamagotchi in
                "LV\(tamagotchi.level) • 밥알 \(tamagotchi.riceCount)개 • 물방울 \(tamagotchi.dropletCount)개"
            }
            .asDriver(onErrorJustReturn: "")
        
        let riceCountText = tamagotchiState
            .map { tamagotchi in
                "밥알 \(tamagotchi.riceCount)개" }
            .asDriver(onErrorJustReturn: "")
        
        let waterCountText = tamagotchiState
            .map { tamagotchi in
                "물방울 \(tamagotchi.dropletCount)개"
            }
            .asDriver(onErrorJustReturn: "")
        
        let bubbleText = bubbleRelay.asDriver()
        
        return Output(
            navigationTitle: navigationTitle,
            bubbleText: bubbleText,
            tamagotchiImage: tamagotchiImage,
            nameText: nameText,
            levelText: levelText,
            riceCountText: riceCountText,
            waterCountText: waterCountText,
            statusText: statusText
        )
    }
}

