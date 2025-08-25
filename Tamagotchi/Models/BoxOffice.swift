//
//  BoxOffice.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

import Foundation

struct BoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Decodable {
    let rank: String
    let movieNm: String
}
