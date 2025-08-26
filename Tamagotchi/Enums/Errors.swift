//
//  Errors.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

enum LottoError: Error {
    case invalid
    case networkDisconnected
    case apiError(Error)
    case unknown
    
    var description: String? {
        switch self {
        case .networkDisconnected:
            return "네트워크 연결이 끊겼습니다. "
        case .invalid:
            return "잘못된 회차 정보입니다."
        case .apiError(let error):
            return "API 통신에 문제가 생겼습니다. \(error.localizedDescription)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
