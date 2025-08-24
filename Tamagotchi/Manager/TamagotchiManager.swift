//
//  TamagotchiManager.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TamagotchiManager {
    
    static let shared = TamagotchiManager()
    
    private let userDefaults = UserDefaults.standard

    private let riceKey = "riceCount"
    private let waterKey = "dropletCount"
    private let nicknameKey = "nickname"
    
    let currentTamagotchi: BehaviorRelay<Tamagotchi>
    
    private init() {
        let rice = userDefaults.integer(forKey: riceKey)
        let water = userDefaults.integer(forKey: waterKey)
        let nickname = userDefaults.string(forKey: nicknameKey) ?? "대장"
        let initialValue = Tamagotchi(riceCount: rice, dropletCount: water, nickname: nickname)
        
        self.currentTamagotchi = BehaviorRelay(value: initialValue)
        }

    func save(_ tamagotchi: Tamagotchi) {
        userDefaults.set(tamagotchi.riceCount, forKey: riceKey)
        userDefaults.set(tamagotchi.dropletCount, forKey: waterKey)
        userDefaults.set(tamagotchi.nickname, forKey: nicknameKey)
        
        currentTamagotchi.accept(tamagotchi)
    }
    
    func load() -> Tamagotchi {
        return currentTamagotchi.value
    }
    
    func reset() {
        userDefaults.removeObject(forKey: nicknameKey)
        userDefaults.removeObject(forKey: riceKey)
        userDefaults.removeObject(forKey: waterKey)
        
        let initialValue = Tamagotchi(riceCount: 0, dropletCount: 0, nickname: "대장")
        currentTamagotchi.accept(initialValue)
    }
}
