//
//  WidgetWeatherData.swift
//  TestTask
//
//  Created by sergey on 11/22/23.
//

import Foundation

extension Double {
    var fahrenheitToCelsius: String {
        return "\(String(format: "%.1f", self - 273.15))Cº"
    }
    var metersToKilometrs: String {
        return "\(String(format: "%.1f", self/1000))км"
    }
}

struct weatherParamets {
    var cityName = ""
    var feelWeather = ""
    var fellTemp = ""
    var realTemp = ""
    var windSped = ""
    var pressure = ""
    var hummidity = ""
    var cloudness = ""
    var visibility = ""
    var image = ""
}

class WidgetWeatherData {
    
    private var isActive = false
    private var isConnect = false
    private var city: City?
    private var nowWeather: Weather?
    private let name = "selectedWeatherCity"
    private let def = Defaults()
    
    func getConnect(completion: @escaping (Bool, weatherParamets) -> Void) {
        checkWeather()
        takeWeather() {result in
            let wth = result ? self.getWeather() : weatherParamets()
            completion(result, wth)
        }
    }
    
    func getActive() -> Bool {
        checkWeather()
        return isActive
    }
    
    private func getWeather() -> weatherParamets {
        var wth = weatherParamets()
        wth.cityName = getName()
        wth.fellTemp = getFeelTemp()
        wth.cloudness = getCloudnes()
        wth.hummidity = getHummidity()
        wth.realTemp = getRealTemp()
        wth.visibility = getVisibillity()
        wth.pressure = getPressure()
        wth.windSped = getWindSpeed()
        wth.feelWeather = getType().0
        wth.image = getType().1
        return wth
    }
    
    private func checkWeather(){
        let savedCity = def.getCity(name)
        if savedCity != nil {
            city = savedCity
            isActive = true
        } else {
            isActive = false
        }
    }
    
    private func takeWeather(completion: @escaping (Bool) -> Void) {
        Parser().getWeather(lati: city?.latitude, long: city?.longitude) {resultWether,resultError  in
            if resultWether != nil {
                self.isConnect = true
                self.nowWeather = resultWether
            } else {
                self.isConnect = false
            }
            completion(self.isConnect)
        }
    }
    
    private func getName() -> String {
        return city?.name ?? ""
    }
    
    private func getFeelTemp() -> String {
        return nowWeather?.main.feelsLike.fahrenheitToCelsius ?? ""
    }
    
    private func getRealTemp() -> String {
        return nowWeather?.main.temp.fahrenheitToCelsius ?? ""
    }
    
    private func getCloudnes() -> String {
        return "\(nowWeather?.clouds.all ?? 0)%"
    }
    
    private func getVisibillity() -> String {
        return Double(nowWeather?.visibility ?? 10000).metersToKilometrs
    }
    
    private func getWindSpeed() -> String {
        return "\(nowWeather?.wind.speed ?? 0)м/с"
    }
    
    private func getHummidity() -> String {
        return "\(nowWeather?.main.humidity ?? 0)%"
    }
    
    private func getPressure() -> String {
        return "\(nowWeather?.main.pressure ?? 0)mm"
    }
    
    private func getType() -> (String,String) {
        if nowWeather?.snow?.the1H != nil {
            return ("Идет снежок","")
        } else if nowWeather?.rain?.the1H != nil {
            return ("Идет дождик","")
        } else if (nowWeather?.wind.speed)! > 6.0 {
            return ("Сильный ветерок","")
        } else if (nowWeather?.clouds.all)! > 80 {
            return ("На небе много облачков","")
        } else {
            return ("Погода просто супер!", "")
        }
    }
}
