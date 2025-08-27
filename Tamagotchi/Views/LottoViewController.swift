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
import Toast

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


final class LottoViewController: BaseViewController {
    
    private let viewModel = LottoViewModel()
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
        let input = LottoViewModel.Input(
            roundText: inputTextField.rx.text,
            resultButtonTap: resultButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.numberLabelAttribute
            .drive(with: self, onNext: { owner, attributes in
                for (label, prop) in zip(self.numberLabels, attributes) {
                    label.text = prop.text
                    label.backgroundColor = prop.color
                }
            })
            .disposed(by: disposeBag)
            
        output.bonusLabelAttribute
            .drive(with: self, onNext: { owner, prop in
                owner.bonusLabel.text = prop.text
                owner.bonusLabel.backgroundColor = prop.color
            })
            .disposed(by: disposeBag)
            
        output.infoText
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
            
        output.isBonusVisible
            .drive(with: self, onNext: { owner, isVisible in
                owner.plusLabel.isHidden = !isVisible
                owner.bonusLabel.isHidden = !isVisible
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .subscribe(with: self, onNext: { owner, message in
                owner.showToast(message: message)
            })
            .disposed(by: disposeBag)
            
        output.showAlert
            .subscribe(with: self, onNext: { owner, message in
                self.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func showToast(message: String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(inputTextField)
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
