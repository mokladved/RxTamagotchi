//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

struct Tamagotchi {
    var riceCount = 0
    var dropletCount = 0
    var nickname = "대장"
    var level: Int {
        let initialLevel = 1
        let calculatedLevel = ((Double(riceCount) / 5.0) + (Double(dropletCount) / 2.0)) / 10.0
        let finalLevel = Int(calculatedLevel) + initialLevel
        
        if finalLevel >= 10 {
            return 10
        } else if finalLevel <= 1 {
            return 1
        } else {
            return finalLevel
        }
    }
}
