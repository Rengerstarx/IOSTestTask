//  MyWeatherAPI.swift
//  TestTask
//  Created by sergey on 11/15/23.

import Moya

enum MyWeatherAPI {
    case getData(lati: Double, long: Double, appid: String)
}

extension MyWeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        return "/data/2.5/weather"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self{
        case let .getData(lati, long, appid):
            let parametrs: [String: String] = [
                "lat": String(lati),
                "lon": String(long),
                "appid": appid
            ]
            return .requestParameters(parameters: parametrs, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

