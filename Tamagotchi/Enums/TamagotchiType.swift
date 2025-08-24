//
//  TamagotchiType.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

enum TamagotchiType: String, CaseIterable {
    case ddakkum
    case bangsil
    case banjjak
    case preparing
    
    var baseImageName: String {
        switch self {
        case .ddakkum: 
            return "1-6"
        case .bangsil:
            return "2-6"
        case .banjjak:
            return "3-6"
        case .preparing:
            return "noImage"
        }
    }
    
    var name: String {
        switch self {
        case .ddakkum:
            return "따끔따끔 다마고치"
        case .bangsil:
            return "방실방실 다마고치"
        case .banjjak:
            return "반짝반짝 다마고치"
        case .preparing:
            return "준비중이에요"
        }
    }
}
