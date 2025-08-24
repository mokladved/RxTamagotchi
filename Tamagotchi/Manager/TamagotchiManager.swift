//
//  TamagotchiManager.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

final class TamagotchiManager {
    private let userDefaults = UserDefaults.standard

    private let riceKey = "riceCount"
    private let waterKey = "dropletCount"
    private let nicknameKey = "nickname"

    func save(_ tamagotchi: Tamagotchi) {
        userDefaults.set(tamagotchi.riceCount, forKey: riceKey)
        userDefaults.set(tamagotchi.dropletCount, forKey: waterKey)
        userDefaults.set(tamagotchi.nickname, forKey: nicknameKey)
    }
    
    func load() -> Tamagotchi {
        let rice = userDefaults.integer(forKey: riceKey)
        let water = userDefaults.integer(forKey: waterKey)
        let nickname = userDefaults.string(forKey: nicknameKey) ?? "대장"
        return Tamagotchi(riceCount: rice, dropletCount: water, nickname: nickname)
    }
    
    func reset() {
        userDefaults.removeObject(forKey: nicknameKey)
        userDefaults.removeObject(forKey: riceKey)
        userDefaults.removeObject(forKey: waterKey)
    }
}
