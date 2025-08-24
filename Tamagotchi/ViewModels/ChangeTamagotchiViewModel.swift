//
//  ChangeTamagotchiViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeTamagotchiViewModel {
    private let tamagochis: [Tamagotchi] = {
        var tamagotchis: [Tamagotchi] = [
            Tamagotchi(type: .ddakkum),
            Tamagotchi(type: .bangsil),
            Tamagotchi(type: .banjjak),
        ]
        
        for _ in 1...17 {
            tamagotchis.append(Tamagotchi())
        }
        
        return tamagotchis
    }()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let changed: PublishRelay<Tamagotchi>
    }
    
    struct Output {
        let tamagochis: Driver<[Tamagotchi]>
        let changeAlert: Driver<Tamagotchi>
        let didChange: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let changeAlertRelay = PublishRelay<Tamagotchi>()
        
        let tamagotchis = Observable.just(tamagochis)
            .asDriver(onErrorJustReturn: [])
        
        input.itemSelected
            .map { self.tamagochis[$0.item] }
            .filter { $0.type != .preparing }
            .bind(to: changeAlertRelay)
            .disposed(by: disposeBag)
        
        let didChange = input.changed
            .do(onNext: { [weak self] tamagotchi in
                self?.saveTamagotchiType(tamagotchi.type)
                UserDefaults.standard.setValue(true, forKey: Keys.isDone)
            })
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            tamagochis: tamagotchis,
            changeAlert: changeAlertRelay.asDriver(onErrorJustReturn: Tamagotchi(type: .ddakkum)),
            didChange: didChange
        )
    }
    
    private func saveTamagotchiType(_ type: TamagotchiType) {
        var tamagotchi = TamagotchiManager.shared.load()
        tamagotchi.type = type
        TamagotchiManager.shared.save(tamagotchi)
    }
}
