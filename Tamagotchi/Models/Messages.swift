//
//  Messages.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import Foundation

struct Messages {
    private static let contents = [
        "%@님, 배고파요... 꼬르륵 소리가 나요. 밥 주세요!",
        "응가했어요, %@님! 지저분해요. 얼른 치워주세요~",
        "%@님이랑 노니까 세상에서 제일 재밌어요! 헤헤.",
        "콜록콜록... %@님, 저 아픈 것 같아요. 약이 필요해요.",
        "%@님, 저랑 좀 놀아주세요. 너무 심심해요... (ㅠ_ㅠ)",
        "기분 최고! %@님이 쓰다듬어 주셔서 행복 지수가 가득 찼어요!",
        "졸려요, %@님... 방 불 좀 꺼주시면 안 될까요? 코~ 잘 시간이에요.",
        "%@님! 제 몸이 빛나기 시작했어요! 혹시... 진화하는 걸까요?! 와아!",
        "삐졌어요! %@님이 계속 놀아주지 않아서 애정도가 떨어졌어요. 흥!",
        "%@님, 잘 잤어요? 오늘도 신나게 놀 준비 완료!",
        "깨끗하게 씻겨줘서 고마워요, %@님! 몸에서 향기가 나는 것 같아요.",
        "%@님이 주는 간식은 뭐든지 맛있어요! 또 주세요!",
        "화면이 어두워요... %@님, 혼자 두세요. 무서워요.",
        "%@님은 세상에서 제일 좋은 주인님이에요! 정말 정말 좋아요!",
        "뭐하고 놀까요, %@님? 제 심장이 두근두근 기대하고 있어요!",
    ]
    
    static func shuffle(for name: String) -> String {
        guard let randomContent = Messages.contents.randomElement() else {
            return ""
        }
        return String(format: randomContent, name)
    }
}
