//
//  Constants.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit

enum Constants {
    enum UI {
        enum Title {
            static let rice = "drop.circle"
            static let water = "leaf.circle"
            static let profile = "person.crop.circle"
            static let eatRice = "밥먹기"
            static let drinkWater = "물먹기"
            static let setting = "설정"
            static let setName = "내 이름 설정하기"
            static let pencil = "pencil"
            static let moon = "moon.fill"
            static let clockwise = "arrow.clockwise"
            static let changeTG = "다마고치 변경하기"
            static let reset = "데이터 초기화"
            static let save = "저장"
            static let noImage = "noimage"
            static let select = "선택하기"
            static let cancel = "취소"
            static let selectTG = "다마고치 선택하기"
            static let tamagotchi = "Tamagotchi"
            static let lotto = "Lotto"
            static let boxOffice = "Box Office"
            static let game = "gamecontroller.fill"
            static let numbers = "numbers.rectangle.fill"
            static let movie = "movieclapper.fill"
        }
        
        enum symbolImage {
            static let rice = UIImage(systemName: Title.rice)
            static let water = UIImage(systemName: Title.water)
            static let profile = UIImage(systemName: Title.profile)
            static let pencil = UIImage(systemName: Title.pencil)
            static let moon = UIImage(systemName: Title.moon)
            static let clockwise = UIImage(systemName: Title.clockwise)
            static let game = UIImage(systemName: Title.game)
            static let numbers = UIImage(systemName: Title.numbers)
            static let movie = UIImage(systemName: Title.movie)
        }
        
        enum Message {
            static let giveMeRice = "밥주세용"
            static let giveMeWater = "물주세용"
            static let reset = "정말 다시 처음부터 시작하실 건가용?"
            static let yes = "웅!"
            static let no = "아냐!"
            static let riceLimit = "밥알은 1~99개까지 먹을 수 있어요!"
            static let waterLimit = "물방울은 1~49개까지 마실 수 있어요!"
            
        }
    }
}
