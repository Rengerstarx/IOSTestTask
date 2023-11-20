//
//  WidgetController.swift
//  TestTask
//
//  Created by sergey on 11/17/23.
//

import UIKit
import Foundation
import TinyConstraints
import SDWebImage

class WidgetController{
    
    private let stackWeather = UIStackView()
    
    //0 - sun, 1 - windy, 2 - cloudiness, 3 - rainy, 4 - snowy
    private var wthTypeIm = ""
    private var wthTypeString = ""
    
    private let backView = UIView()
    
    private let imgWeather = UIImageView()
    
    private let cityLabel = UILabel()
    private let typeWeatherLabel = UILabel()
    private let tempLabel = UILabel()
    private let typefeelLabel = UILabel()
    private let tempfeelLabel = UILabel()
    
    //Color
    private let backColor = UIColor(named: "backWeather")
    
    private let blockView: UIView
    private let nowCity: City
    private let nowWeather: Weather
    private let topLabel: UILabel
    
    init(widgetView blockView: UIView, city nowCity: City, weather nowWeather: Weather, topObject topLable: UILabel){
        self.blockView = blockView
        self.nowCity = nowCity
        self.nowWeather = nowWeather
        self.topLabel = topLable
        wthTypeIm = typeWeather()
    }
    
    func initWidget(){
        setBackground()
        setTop()
        setBottom()
        setMiddle()
        setStack()
    }
    
    private func setBackground(){
        backView.backgroundColor = .white
        blockView.addSubview(backView)
        backView.layer.cornerRadius = 20
        backView.topToBottom(of: topLabel, offset: 5)
        backView.leftToSuperview(offset: 10)
        backView.rightToSuperview(offset: -10)
        backView.bottomToSuperview(offset: -10)
    }
    
    private func setTop(){
        backView.addSubview(cityLabel)
        cityLabel.text = nowCity.name
        cityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cityLabel.textColor = .black
        cityLabel.topToSuperview(offset: 15)
        cityLabel.leftToSuperview(offset: 15)
        
        backView.addSubview(typeWeatherLabel)
        typeWeatherLabel.text = wthTypeString
        typeWeatherLabel.font = UIFont.systemFont(ofSize: 14)
        typeWeatherLabel.textColor = .black
        typeWeatherLabel.topToBottom(of: cityLabel)
        typeWeatherLabel.leftToSuperview(offset: 15)
    }
    
    private func setBottom(){
        backView.addSubview(typefeelLabel)
        typefeelLabel.text = "Ощущается как: "
        typefeelLabel.font = UIFont.systemFont(ofSize: 14)
        typefeelLabel.textColor = .black
        typefeelLabel.leftToSuperview(offset: 15)
        typefeelLabel.bottomToSuperview(offset: -10)
        
        
        backView.addSubview(tempfeelLabel)
        tempfeelLabel.text = String(format: "%.1f", nowWeather.main.feelsLike - 273.15) + "ºC"
        tempfeelLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tempfeelLabel.textColor = .black
        tempfeelLabel.leftToRight(of: typefeelLabel)
        tempfeelLabel.bottomToSuperview(offset: -10)
    }
    
    private func setMiddle(){
        backView.addSubview(imgWeather)
        imgWeather.sd_setImage(with: URL(string: wthTypeIm))
        imgWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        imgWeather.bottomToTop(of: typefeelLabel, offset: -7)
        imgWeather.leftToSuperview(offset: 15)
        
        backView.addSubview(tempLabel)
        tempLabel.text = String(format: "%.1f", nowWeather.main.temp - 273.15) + "ºC"
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tempLabel.textColor = .black
        tempLabel.topToBottom(of: typeWeatherLabel, offset: 7)
        tempLabel.bottomToTop(of: typefeelLabel, offset: -7)
        //tempLabel.leftToRight(of: imgWeather)
        //tempLabel.rightToSuperview(offset: -30)
        
        imgWeather.rightToLeft(of: tempLabel)
    }
    
    private func setStack(){
        stackWeather.axis = .vertical
        stackWeather.distribution = .fillEqually
        stackWeather.spacing = 1
        
        for t in 0..<5 {
            let row = UIStackView()
            stackWeather.addArrangedSubview(row)
            row.axis = .horizontal
            row.distribution = .equalSpacing
            row.spacing = 0
            
            var type = ""
            var value = ""
            
            switch t {
            case 0:
                type = "Ветер"
                value = "\(nowWeather.wind.speed) м/с"
            case 1:
                type = "Давление"
                value = "\((nowWeather.main.pressure)!) мм"
            case 2:
                type = "Влажность"
                value = "\(( nowWeather.main.humidity)!) %"
            case 3:
                type = "Облачность"
                value = "\(nowWeather.clouds.all) %"
            case 4:
                type = "Видимость"
                let dbd = Double(nowWeather.visibility) / 1000
                print(dbd)
                value = "\(String(format: "%.1f", dbd)) км"
            default:
                type = ""
                value = ""
            }
            
            //print(value)
            
            for y in 0..<2 {
                let lbl = UILabel()
                row.addArrangedSubview(lbl)
                lbl.text = y==0 ? type : value
                lbl.font = y==0 ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
                lbl.textAlignment = y==0 ? .left : .right
            }
            
        }
        backView.addSubview(stackWeather)
        
        //stackWeather.edgesToSuperview()
        stackWeather.rightToSuperview(offset: -15)
        stackWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        stackWeather.bottomToSuperview(offset: -10)
        stackWeather.leftToRight(of: tempfeelLabel, offset: 5)
        
        tempLabel.rightToLeft(of: stackWeather, offset: -5)
    }
    
    private func typeWeather() -> String{
        if nowWeather.snow?.the1H != nil {
            wthTypeString = "Идет снежок"
            return "https://psv4.userapi.com/c909328/u390619751/docs/d39/28a80deac105/snowy.png?extra=BAWmTxxHkIKZaQOVHULq0_cRZvTKa91ShH76gOzrZEydMgpcfNzYPYMtQZIKWGV8CikDOOty82UMMfTTDSfnxcXzPzOXWzSbIyUgA4sMY0JZEtnpQZTDcO6s_0uGFgP3gk1jMRk2vn-GEDuTCeg60ZWJ"
            
        }
        else if nowWeather.rain?.the1H != nil {
            wthTypeString = "Идет дождик"
            return "https://psv4.userapi.com/c909418/u390619751/docs/d27/809c69f083b3/rain.png?extra=hP6MMi7E0hmxWFshOsH-YuYvx_3UFTceSvaWl6RX0W0pCNo3-UY6oD5n8xCtNidiDgaMJuyeyh_5fc7EPbAmDxAsOo1eKTzOPCp2TBUFyg5WnL_oBhDbpddCaoD36WD40uSIS7IoVMRHNtn5fYbq9aAe"
            
        }
        else if nowWeather.wind.speed > 6.0{
            wthTypeString = "Сильный ветерок"
            return "https://psv4.userapi.com/c235031/u390619751/docs/d52/f28166e3c03f/windy.png?extra=nVRfvabystRjOiwCB0H24qjSO3kZPjmK8GAKmjGNcMABdzfyuDlzTPD5piEbKXRc1vDUjXWhk9D0WXZ8T6B6qfNS3SZg4wVeGCDobBoAozQvsrKLB992NXrqViY2M3R6_mja3h60KcRmNWtjiCg4zkpH"
        }
        else if nowWeather.clouds.all > 80 {
            wthTypeString = "На небе много облачков"
            return "https://psv4.userapi.com/c909518/u390619751/docs/d24/0d525ab58a74/cloudy.png?extra=i-Ae_GuOdRtGQ_W_sXsDn5ZIxoYP1P5ZLHrLGsAsg9OlP7eB4R3JqD0rpSZ3hgl8Kx5almhx0pLjvvmUvcDJa9Mz92-EemU2R67iCF9R-5lOkYyZsPxtqlGEzOcH-6c_hSCS6c2pVDRHEjYbEBWx3fsr"
        }
        else{
            wthTypeString = "Погода просто супер!"
            return "https://psv4.userapi.com/c909228/u390619751/docs/d58/bd592b9cb432/sunny.png?extra=R2P785kKweGNBRze-0AcyJVZCl12B7L-Y4LKgbs34F1XZv7ZyswA0zD10rbusSNCcBl3gTJh06unppMqL80zN4Btdm23ifWfnK4k5mbz06-Cxa1DDBGhsb6TJRBDbokSmW7gmklQY_JEAVOG9_moEZzV"
        }
        
    }
    
}
