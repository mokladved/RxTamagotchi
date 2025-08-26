//
//  LottoViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

import UIKit
import RxSwift
import RxCocoa

struct LabelAttribute {
    let text: String
    let color: UIColor
}

final class LottoViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let roundText: ControlProperty<String?>
        let resultButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let numberLabelAttribute: Driver<[LabelAttribute]>
        let bonusLabelAttribute: Driver<LabelAttribute>
        let infoText: Driver<String>
        let isBonusVisible: Driver<Bool>
        let showToast: PublishRelay<String>
        let showAlert: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let showToast = PublishRelay<String>()
        let showAlert = PublishRelay<String>()
        let lottoResult = input.resultButtonTap
            .withLatestFrom(input.roundText.orEmpty)
            .map { Int($0) ?? 0 }
            .flatMap { round -> Observable<Lotto> in
                return CustomObservable.fetchLotto(round: round)
                    .retry(2)
                    .catch { error in
                        guard let lottoError = error as? LottoError else {
                            showToast.accept(LottoError.unknown.localizedDescription)
                            return Observable.just(Lotto.empty)
                        }
                        
                        switch lottoError {
                        case .networkDisconnected:
                            showAlert.accept(lottoError.localizedDescription)
                        case .invalid, .apiError, .unknown:
                            showToast.accept(lottoError.localizedDescription)
                        }
                        
                        return Observable.just(Lotto.empty)
                    }
            }
            .asDriver(onErrorJustReturn: Lotto.empty)

        let numberAttribute = lottoResult
            .map { lotto -> [LabelAttribute] in
                guard lotto.returnValue == "success" else {
                    return Array(repeating: LabelAttribute(text: "", color: .clear), count: 6)
                }
                return lotto.numbers.map { num in
                    return LabelAttribute(text: "\(num)", color: self.getColor(for: num))
                }
            }
        
        let bonusAttribute = lottoResult
            .map { lotto -> LabelAttribute in
                guard lotto.returnValue == "success" else {
                    return LabelAttribute(text: "", color: .clear)
                }
                return LabelAttribute(text: "\(lotto.bnusNo)", color: self.getColor(for: lotto.bnusNo))
            }
        
        let infoText = lottoResult
            .map { lotto in
                return lotto.returnValue == "success" ? "\(lotto.drwNo)회 당첨 번호" : "잘못된 회차입니다."
            }
        
        let isBonusVisible = lottoResult
            .map { $0.returnValue == "success" }
        
        return Output(
            numberLabelAttribute: numberAttribute,
            bonusLabelAttribute: bonusAttribute,
            infoText: infoText,
            isBonusVisible: isBonusVisible,
            showToast: showToast,
            showAlert: showAlert
        )
    }
    
    private func getColor(for number: Int) -> UIColor {
        switch number {
        case 1...10: return .systemYellow
        case 11...20: return .systemBlue
        case 21...30: return .systemRed
        case 31...40: return .systemGray
        default: return .systemGreen
        }
    }
}
