//
//  MyCryptoAPI.swift
//  TestTask
//
//  Created by sergey on 11/18/23.
//


import Moya

enum MyCryptoAPI {
    case getData(coin: String)
    case getDataAll(market: Bool)
}

extension MyCryptoAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coingecko.com/api/v3/coins/")!
    }
    
    var path: String {
        return "markets"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
        
    }
    
    var task: Task {
        switch self{
        case let .getDataAll(market):
            let parametrs: [String: String] = [
                "vs_currency": "usd",
                "order": "market_cap_desc",
                "per_page": "10",
                "page" : "1",
                "sparkline" : "false",
                "price_change_percentage" : "1h"
            ]
            return .requestParameters(parameters: parametrs, encoding: URLEncoding.default)
        case let .getData(coin):
            let parametrs: [String: String] = [
                "vs_currency": "usd",
                "ids": coin,
                "order": "market_cap_desc",
                "per_page": "10",
                "page" : "1",
                "sparkline" : "false",
                "price_change_percentage" : "1h"
            ]
            return .requestParameters(parameters: parametrs, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

