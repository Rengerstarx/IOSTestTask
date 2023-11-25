import Foundation
import Moya

class Parser {
    func getWeather(lati: Double?, long: Double?, completion: @escaping (Weather?,String?) -> Void) {
        let provide = MoyaProvider<MyWeatherAPI>()
        provide.request(.getData(lati: lati!, long: long!, appid: "230f63b39a63039e7ec484a09f31728a")) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(Weather.self, from: response.data)
                    completion(weather, nil)
                } catch {
                    print("Error: No Parseble")
                    completion(nil, "Parse error")
                }
            case .failure(_):
                print("Error: Network conection")
                completion(nil, "Network error")
            }
        }
    }
    
    func getCities() -> [City] {
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
    
    func getAllCoins(completion: @escaping ([Crypto]?,String?) -> Void){
        let provide = MoyaProvider<MyCryptoAPI>()
        provide.request(.getDataAll(market: true)) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let crypto = try decoder.decode([Crypto].self, from: response.data)
                    completion(crypto,nil)
                } catch {
                    print("Error: No Parseble")
                    completion(nil,"Parse error")
                }
            case .failure(_):
                print("Error: Network conection")
                completion(nil,"Network error")
            }
        }
    }
    
    func getOneCoin(id id: String, completion: @escaping ([Crypto]?, String?) -> Void) {
        let provide = MoyaProvider<MyCryptoAPI>()
        provide.request(.getData(coin: id)) { result in
            switch result {
            case let .success(response):
                do {
                    print(response.request?.url?.absoluteString)
                    let decoder = JSONDecoder()
                    let crypto = try decoder.decode([Crypto].self, from: response.data)
                    completion(crypto, nil)
                } catch {
                    print("Error: No Parseble")
                    completion(nil, "Parse error")
                }
            case .failure(_):
                print("Error: Network conection")
                completion(nil, "Network error")
            }
        }
    }
}
