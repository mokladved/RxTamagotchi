//
//  BoxOfficeViewModel.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let dailyBoxOfficeList: Driver<[DailyBoxOffice]>
        let showToast: Driver<String>
        let showAlert: Driver<String> 
    }
    
    func transform(input: Input) -> Output {
        let showToast = PublishRelay<String>()
        let showAlert = PublishRelay<String>()
        
        let searchTrigger = input.searchButtonTap
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
        
        let boxOfficeResult = searchTrigger
            .flatMap { date -> Observable<Result<[DailyBoxOffice], Error>> in
                guard date.count == 8, Int(date) != nil else {
                    return .just(.failure(BoxOfficeError.invalidFormat))
                }
                return CustomObservable.fetchBoxOffice(date: date)
                    .retry(2)
                    .map { data in Result.success(data) }
                    .catch { error in
                        return Observable.just(Result.failure(error))
                    }
            }
            .share()
        let dailyBoxOfficeList = boxOfficeResult
            .compactMap { result -> [DailyBoxOffice]? in
                if case .success(let data) = result {
                    return data
                }
                return nil
            }
            .asDriver(onErrorJustReturn: [])
        
        
        boxOfficeResult
            .compactMap { result -> Error? in
                if case .failure(let error) = result {
                    return error
                }
                return nil
            }
            .subscribe(onNext: { error in
                guard let boxOfficeError = error as? BoxOfficeError else {
                    showToast.accept(error.localizedDescription)
                    return
                }
                
                
                switch boxOfficeError {
                case .networkDisconnected:
                    showAlert.accept(boxOfficeError.localizedDescription)
                case .invalidFormat, .apiError, .unknown:
                    showToast.accept(boxOfficeError.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            dailyBoxOfficeList: dailyBoxOfficeList,
            showToast: showToast.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다."),
            showAlert: showAlert.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        )
    }
}
