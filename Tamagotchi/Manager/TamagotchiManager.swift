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

    
    let currentTamagotchi: BehaviorRelay<Tamagotchi>
    
    private init() {
        let rice = userDefaults.integer(forKey: Keys.rice)
        let water = userDefaults.integer(forKey: Keys.water)
        let nickname = userDefaults.string(forKey: Keys.nickname) ?? "대장"
        let typeRawValue = userDefaults.string(forKey: Keys.type) ?? TamagotchiType.ddakkum.rawValue
        let type = TamagotchiType(rawValue: typeRawValue) ?? .ddakkum
    
        var initialValue = Tamagotchi(type: type)
        initialValue.riceCount = rice
        initialValue.dropletCount = water
        initialValue.nickname = nickname
                
        self.currentTamagotchi = BehaviorRelay(value: initialValue)
    }

    func save(_ tamagotchi: Tamagotchi) {
        userDefaults.set(tamagotchi.type.rawValue, forKey: Keys.type)
        userDefaults.set(tamagotchi.riceCount, forKey: Keys.rice)
        userDefaults.set(tamagotchi.dropletCount, forKey: Keys.water)
        userDefaults.set(tamagotchi.nickname, forKey: Keys.nickname)
        
        currentTamagotchi.accept(tamagotchi)
    }
    
    func load() -> Tamagotchi {
        return currentTamagotchi.value
    }
    
    func reset() {
        userDefaults.removeObject(forKey: Keys.type)
        userDefaults.removeObject(forKey: Keys.nickname)
        userDefaults.removeObject(forKey: Keys.rice)
        userDefaults.removeObject(forKey: Keys.water)
        userDefaults.removeObject(forKey: Keys.isDone)
        
        let initialValue = Tamagotchi(type: .ddakkum)
        currentTamagotchi.accept(initialValue)
    }
}
