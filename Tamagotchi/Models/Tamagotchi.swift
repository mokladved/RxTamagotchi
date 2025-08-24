//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

struct Tamagotchi {
    var type: TamagotchiType = .ddakkum
    
    init(type: TamagotchiType = .preparing) {
        self.type = type
    }
    
    var riceCount = 0
    var dropletCount = 0
    var nickname = "대장"
    
    var level: Int {
        let score = (riceCount / 5) + (dropletCount / 2)
        
        switch score {
        case ..<20:
            return 1
        case 20..<100:
            return score / 10
        default:
            return 10
        }
    }
    
    var imageName: String {
        let id: Int
        switch self.type {
        case .ddakkum:
            id = 1
        case .bangsil:
            id = 2
        case .banjjak:
            id = 3
        case .preparing:
            return Constants.UI.Title.noImage
        }
        
        return level < 10 ? "\(id)-\(level)" : "\(id)-9"
    }
    
    var name: String {
        return type.name
    }
}
