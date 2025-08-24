//
//  TamagotchiManager.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

final class TamagotchiManager {

    private let riceKey = "riceCount"
    private let waterKey = "dropletCount"
    private let nicknameKey = "nickname"

    func save(_ tamagotchi: Tamagotchi) {
        UserDefaults.standard.set(tamagotchi.riceCount, forKey: riceKey)
        UserDefaults.standard.set(tamagotchi.dropletCount, forKey: waterKey)
        UserDefaults.standard.set(tamagotchi.nickname, forKey: nicknameKey)
    }
    
    func load() -> Tamagotchi {
        let rice = UserDefaults.standard.integer(forKey: riceKey)
        let water = UserDefaults.standard.integer(forKey: waterKey)
        let nickname = UserDefaults.standard.string(forKey: nicknameKey) ?? "대장"
        return Tamagotchi(riceCount: rice, dropletCount: water, nickname: nickname)
    }
}
