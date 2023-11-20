//
//  ParsWeather.swift
//  TestTask
//
//  Created by sergey on 11/15/23.
//

import Foundation
import Moya

class ParsWeather{
    
    func pars(lati: Double?, long: Double?, completion: @escaping (Any) -> Void){
        let provide = MoyaProvider<MyWeatherAPI>()
        provide.request(.getData(lati: lati!, long: long!, appid: "230f63b39a63039e7ec484a09f31728a")) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(Weather.self, from: response.data)
                    completion(weather)
                }
                catch {
                    print("Error: No Parseble")
                    completion("Parse error")
                }
            case .failure(_):
                print("Error: Network conection")
                completion("Network error")
                
            }
        }
    }
}
