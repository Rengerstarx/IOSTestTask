//
//  ParsCities.swift
//  TestTask
//
//  Created by sergey on 11/14/23.
//

import Foundation
import Moya


class ParsCities{
        
    func parser() -> [City] {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else {
            print("Error with path")
            return []
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Error with data")
            return []
        }
        
        var array = [City]()
        do {
            let decoder = JSONDecoder()
            array = try decoder.decode([City].self, from: data)
        } catch {
            print("Ошибка разбора JSON: \(error)")
        }
        
        return array
    }
    
    func parsCrypto(completion: @escaping (Any) -> Void){
        let provide = MoyaProvider<MyCryptoAPI>()
        provide.request(.getDataAll(market: true)) { result in
            switch result {
            case let .success(response):
                do {
                    //print(response.request?.url?.absoluteString)
                    let decoder = JSONDecoder()
                    let crypto = try decoder.decode([Crypto].self, from: response.data)
                    //print(crypto[0])
                    completion(crypto)
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
    
    func getCoinInfo(id id: String, completion: @escaping (Any) -> Void){
        let provide = MoyaProvider<MyCryptoAPI>()
        provide.request(.getData(coin: id)) { result in
            switch result {
            case let .success(response):
                do {
                    print(response.request?.url?.absoluteString)
                    let decoder = JSONDecoder()
                    let crypto = try decoder.decode([Crypto].self, from: response.data)
                    completion(crypto)
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
