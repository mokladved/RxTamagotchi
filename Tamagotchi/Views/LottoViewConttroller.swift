//
//  LottoViewConttroller.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

struct Lotto: Decodable {
    let returnValue: String
    let drwNo: Int
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    
    var numbers: [Int] {
        return [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6]
    }
    
    static let empty = Lotto(returnValue: "fail", drwNo: 0, drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0)

}


final class LottoViewConttroller: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let inputTextField = UnderlineTextField()
    private let resultButton = UIButton()
    private let infoLabel = UILabel()
    private let resultStackView = UIStackView()
 
    private let numberLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
    private let plusLabel = UILabel()
    private let bonusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
    private func bind() {
        let roundNumber = resultButton.rx.tap
            .withLatestFrom(inputTextField.rx.text.orEmpty)
            .map { Int($0) }
            .filter { $0 != nil }
            .map { $0! }
            .share()

        let lottoResult = roundNumber
            .flatMap { round -> Observable<Lotto> in
                return CustomObservable.fetchLotto(round: round)
            }
            .asDriver(onErrorJustReturn: Lotto.empty)
        
        lottoResult
            .map { lotto -> String in
                return lotto.returnValue == "success" ? "\(lotto.drwNo)회 당첨 번호" : "잘못된 회차입니다."
            }
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        lottoResult
            .drive(with: self, onNext: { owner, lotto in
                if lotto.returnValue == "success" {
                    for (index, label) in self.numberLabels.enumerated() {
                        label.text = "\(lotto.numbers[index])"
                        label.backgroundColor = self.getColor(for: lotto.numbers[index])
                    }
                    
                    owner.bonusLabel.text = "\(lotto.bnusNo)"
                    owner.bonusLabel.backgroundColor = owner.getColor(for: lotto.bnusNo)
                    owner.plusLabel.isHidden = false
                    owner.bonusLabel.isHidden = false
                } else {
                    for label in (owner.numberLabels + [owner.bonusLabel]) {
                        label.text = ""
                        label.backgroundColor = .clear
                    }
                    owner.plusLabel.isHidden = true
                    owner.bonusLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
            
    }
    
    override func configureHierarchy() {
        view.addSubview(inputTextField)
        view.addSubview(resultButton)
        view.addSubview(infoLabel)
        view.addSubview(resultStackView)
        numberLabels.forEach { resultStackView.addArrangedSubview($0) }
        resultStackView.addArrangedSubview(plusLabel)
        resultStackView.addArrangedSubview(bonusLabel)
    }
    
    override func configureLayout() {
        inputTextField.snp.makeConstraints { make in  make.top.equalTo(view.safeAreaLayoutGuide).offset(20); make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20); make.height.equalTo(50)
        }
        
        resultButton.snp.makeConstraints { make in make.top.equalTo(inputTextField.snp.bottom).offset(20); make.horizontalEdges.equalTo(inputTextField)
            make.height.equalTo(40)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(40)
            make.leading.equalTo(inputTextField)
        }
    
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(inputTextField)
            make.height.equalTo(44)
        }
        
        for label in numberLabels {
            label.snp.makeConstraints { make in
                make.width.equalTo(label.snp.height)
            }
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.width.equalTo(bonusLabel.snp.height)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.width.equalTo(plusLabel.snp.height)
        }
        
        
    }
    
    override func configureView() {
        super.configureView()
        inputTextField.textAlignment = .center
        inputTextField.font = .systemFont(ofSize: 15, weight: .bold)
        inputTextField.keyboardType = .numberPad
        
        resultButton.setTitle("확인", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.backgroundColor = .systemBlue
        resultButton.layer.cornerRadius = 8
        
        infoLabel.font = .systemFont(ofSize: 15)
        
        resultStackView.axis = .horizontal
        resultStackView.alignment = .fill
        resultStackView.distribution = .equalSpacing
        
        for label in numberLabels + [bonusLabel] {
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.clipsToBounds = true
        }
        
        plusLabel.textAlignment = .center
        plusLabel.font = .systemFont(ofSize: 18)
        plusLabel.text = "+"
        plusLabel.isHidden = true
        
        bonusLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for label in (numberLabels + [bonusLabel]) {
            label.layer.cornerRadius = label.frame.height / 2
            print(label)
        }
    }
    
    private func getColor(for number: Int) -> UIColor {
        switch number {
        case 1...10:
            return .systemYellow
        case 11...20:
            return .systemBlue
        case 21...30:
            return .systemRed
        case 31...40:
            return .systemGray
        default:
            return .systemGreen
        }
    }
}
