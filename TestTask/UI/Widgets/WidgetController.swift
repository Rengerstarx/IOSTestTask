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

class WeatherWidget{
    
    private let def = Defaults()
    private let color = Color()
    private let name = "selectedWeatherCity"
    private var isActive = false
    private var city: City?
    private var nowWeather: Weather?
    
    private let backView = UIView()
    let loader = UIActivityIndicatorView(style: .gray)
    
    private let stackWeather = UIStackView()
    
    private var wthTypeIm = ""
    private var wthTypeString = ""
    private let tryButton = UIButton()
    private let imgWeather = UIImageView()
    private let cityLabel = UILabel()
    private let typeWeatherLabel = UILabel()
    private let tempLabel = UILabel()
    private let typefeelLabel = UILabel()
    private let tempfeelLabel = UILabel()
    
    init(){
        setBackground()
        checkWeather()
        if isActive {
            startWork()
        }
    }

    func getView() -> UIView{
        return backView
    }

    func getActive() -> Bool {
        return isActive
    }

    private func checkWeather(){
        let savedCity = def.getCity(name)
        if savedCity != nil {
            city = savedCity
            isActive = true
        }else {
            isActive = false
        }
    }

    @objc private func startWork(){
        backView.addSubview(loader)
        loader.centerInSuperview()
        loader.startAnimating()
        ParsWeather().pars(lati: city?.latitude, long: city?.longitude){result in
            self.loader.removeFromSuperview()
            self.tryButton.removeFromSuperview()
            if let weatherr = result as? Weather {
                self.nowWeather = weatherr
                self.initWidget()
            } else if let error = result as? String {
                self.alert()
                self.tryAgain()
            }
        }
    }

    func initWidget(){
        setTop()
        setBottom()
        setMiddle()
        setStack()
    }

    private func alert(){
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей погоде. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }

    private func tryAgain(){
        backView.addSubview(tryButton)
        tryButton.backgroundColor = color.mainBlue
        tryButton.layer.cornerRadius = 10
        tryButton.setTitleColor(.white, for: .normal)
        tryButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        tryButton.setTitle("Повторить", for: .normal)
        tryButton.centerXToSuperview()
        tryButton.bottomToSuperview(offset: -30)
        tryButton.addTarget(self, action: #selector(startWork), for: .touchUpInside)
    }
    
    private func setBackground(){
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 20
    }
    
    private func setTop(){
        backView.addSubview(cityLabel)
        cityLabel.text = city?.name
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
        tempfeelLabel.text = String(format: "%.1f", nowWeather!.main.feelsLike - 273.15) + "ºC"
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
        tempLabel.text = String(format: "%.1f", nowWeather!.main.temp - 273.15) + "ºC"
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tempLabel.textColor = .black
        tempLabel.topToBottom(of: typeWeatherLabel, offset: 7)
        tempLabel.bottomToTop(of: typefeelLabel, offset: -7)
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
                value = "\(nowWeather!.wind.speed) м/с"
            case 1:
                type = "Давление"
                value = "\((nowWeather!.main.pressure)!) мм"
            case 2:
                type = "Влажность"
                value = "\(( nowWeather!.main.humidity)!) %"
            case 3:
                type = "Облачность"
                value = "\(nowWeather!.clouds.all) %"
            case 4:
                type = "Видимость"
                let dbd = Double(nowWeather!.visibility) / 1000
                print(dbd)
                value = "\(String(format: "%.1f", dbd)) км"
            default:
                type = ""
                value = ""
            }
            for y in 0..<2 {
                let lbl = UILabel()
                row.addArrangedSubview(lbl)
                lbl.text = y==0 ? type : value
                lbl.font = y==0 ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
                lbl.textAlignment = y==0 ? .left : .right
            }
        }
        backView.addSubview(stackWeather)
        stackWeather.rightToSuperview(offset: -15)
        stackWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        stackWeather.bottomToSuperview(offset: -10)
        stackWeather.leftToRight(of: tempfeelLabel, offset: 5)
        tempLabel.rightToLeft(of: stackWeather, offset: -5)
    }
    
    private func typeWeather() -> String{
        if nowWeather?.snow?.the1H != nil {
            wthTypeString = "Идет снежок"
            return "https://psv4.userapi.com/c909328/u390619751/docs/d39/47d7f3f6d513/snowy.png?extra=SBqOZoUwAy59BfryFSuaut1Nexg4hsTBkdDkU2AL20OiaanVP4XHZxhrzp412xn5m5tOTpRIIqZ0yyKXthD3HajzD-xtKpNtyP0044cnJgSL6_ql3plycv8iDEV_nzypwl1sFYy0_g-TZNFDrABKSLcn"
        }
        else if nowWeather?.rain?.the1H != nil {
            wthTypeString = "Идет дождик"
            return "https://psv4.userapi.com/c909418/u390619751/docs/d27/04f27ef6d255/rain.png?extra=TVb2RE3fNgplnYradq1BB5ASaMxpl4Ur29gtStMiuW3fbectRqKV1ZpeMYJzp0MwAs0uAi2LS28SZC3tbnKWqzEqQUwr0gZNt72pd_Lp2KT73ig4VJ8D8sx782_QNgGtrGYx8QvDeXS6cpFIObQ3s8HE"
        }
        else if (nowWeather?.wind.speed)! > 6.0{
            wthTypeString = "Сильный ветерок"
            return "https://psv4.userapi.com/c235031/u390619751/docs/d52/ec5c724998c0/windy.png?extra=e5KH0UksPgZutN0J8HcOeO8is27wrrCsv2pM4ioEY320cVf8FjLFI0CkI9ECSz9YjC5iDhESf7KmTJSuN3mfRPZXG7acz9BFKnawna1-MRHs26pc0zIsMY-DnW0XIuvyfI0FtRLdPjo_4_fMgU9OaQpT"
        }
        else if (nowWeather?.clouds.all)! > 80 {
            wthTypeString = "На небе много облачков"
            return "https://psv4.userapi.com/c909518/u390619751/docs/d24/fa822b32f104/cloudy.png?extra=Q4ZTyamP-KgZHRhMuNeTM4Q-U2N_ulipYbH40xQGlQng-8bDGSW9ynhNqdcoe5zKNQL8BQrCi50CYdsX3kM02hwI8jNgG_qddUEvdIuP_AMKYoFexWaukxzxZCyETHSDWGO40b0pTZBFKKtZ1SUKPty3"
        }
        else{
            wthTypeString = "Погода просто супер!"
            return "https://psv4.userapi.com/c909228/u390619751/docs/d58/4e70d199f6e0/sunny.png?extra=Hs72hO6nMXJACbVL5WqmsYHmDxgN5pBz2sfb_sIq8aCeuus6fhp2tV-WYbV6H6bkVnbeyFKpFAnllr7xHtiisAYK1L9MrE621VEQgBPnAw4NZkJKTqd9E4hTPjB9H8-XOu2_Ui30Od2AbokSjPuzuTge"
        }
    }
}
