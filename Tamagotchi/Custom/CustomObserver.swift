//
//  CustomObserver.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/26/25.
//

import Foundation
import Alamofire
import RxSwift

final class CustomObservable {
    static func fetchBoxOffice(date: String) -> Observable<[DailyBoxOffice]> {
        return Observable.create { observer in
            let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            
            let parameters: [String: String] = [
                "key": APIKeys.apiKey,
                "targetDt": date
            ]

            let request = AF.request(url, method: .get, parameters: parameters)
                .responseDecodable(of: BoxOffice.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value.boxOfficeResult.dailyBoxOfficeList)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func fetchLotto(round: Int) -> Observable<Lotto> {
        return Observable.create { observer in
            let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
            
            let request = AF.request(url)
                .responseDecodable(of: Lotto.self) { response in
                    switch response.result {
                    case .success(let data):
                        if data.returnValue == "success" {
                            observer.onNext(data)
                            observer.onCompleted()
                        } else {
                            observer.onError(LottoError.invalid)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
