import UIKit
import Foundation
import TinyConstraints
import SDWebImage

class WidgetWeather {
    
    private var isActive = false
    private var backView = UIView()
    private let loader = UIActivityIndicatorView(style: .gray)
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
    private let data = WidgetWeatherData()
    private var masLables: [UILabel] = []
    
    init() {
        setBackground()
        if data.getActive() {
            isActive = true
            startWork()
        }
    }
    
    func update(){
        updateAll()
    }

    func getView() -> UIView {
        return backView
    }

    func getActive() -> Bool {
        return isActive
    }
    
    func updateData() {
        startWork()
    }
    
    private func updateAll(){
        data.getConnect() {resultBool, resultData in
            if resultBool {
                self.setInfo(resultData)
            }
        }
    }

    @objc private func startWork() {
        backView.addSubview(loader)
        loader.centerInSuperview()
        loader.startAnimating()
        data.getConnect() {resultBool, resultData in
            if resultBool {
                self.loader.removeFromSuperview()
                self.tryButton.removeFromSuperview()
                self.initWidget()
                self.setInfo(resultData)
            } else {
                self.alert()
                self.tryAgain()
            }
        }
    }
    
    private func setInfo(_ wth: weatherParamets) {
        cityLabel.text = wth.cityName
        tempLabel.text = wth.realTemp
        tempfeelLabel.text = wth.fellTemp
        typeWeatherLabel.text = wth.feelWeather
        imgWeather.sd_setImage(with: URL(string: wth.image))
        masLables[0].text = wth.windSped
        masLables[1].text = wth.pressure
        masLables[2].text = wth.hummidity
        masLables[3].text = wth.cloudness
        masLables[4].text = wth.visibility
    }

    private func initWidget() {
        setTop()
        setBottom()
        setMiddle()
        setStack()
    }

    private func alert() {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей погоде. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }

    private func tryAgain() {
        backView.addSubview(tryButton)
        tryButton.backgroundColor = UIColor.appBlue
        tryButton.layer.cornerRadius = 10
        tryButton.setTitleColor(.white, for: .normal)
        tryButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        tryButton.setTitle("Повторить", for: .normal)
        tryButton.centerXToSuperview()
        tryButton.bottomToSuperview(offset: -30)
        tryButton.addTarget(self, action: #selector(startWork), for: .touchUpInside)
    }
    
    private func setBackground() {
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 20
    }
    
    private func setTop() {
        backView.addSubview(cityLabel)
        cityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cityLabel.textColor = .black
        cityLabel.topToSuperview(offset: 15)
        cityLabel.leftToSuperview(offset: 15)
        backView.addSubview(typeWeatherLabel)
        typeWeatherLabel.font = UIFont.systemFont(ofSize: 14)
        typeWeatherLabel.textColor = .black
        typeWeatherLabel.topToBottom(of: cityLabel)
        typeWeatherLabel.leftToSuperview(offset: 15)
    }
    
    private func setBottom() {
        backView.addSubview(typefeelLabel)
        typefeelLabel.text = "Ощущается как: "
        typefeelLabel.font = UIFont.systemFont(ofSize: 14)
        typefeelLabel.textColor = .black
        typefeelLabel.leftToSuperview(offset: 15)
        typefeelLabel.bottomToSuperview(offset: -10)
        backView.addSubview(tempfeelLabel)
        tempfeelLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tempfeelLabel.textColor = .black
        tempfeelLabel.leftToRight(of: typefeelLabel)
        tempfeelLabel.bottomToSuperview(offset: -10)
    }
    
    private func setMiddle() {
        backView.addSubview(imgWeather)
        imgWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        imgWeather.bottomToTop(of: typefeelLabel, offset: -7)
        imgWeather.leftToSuperview(offset: 15)
        backView.addSubview(tempLabel)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tempLabel.textColor = .black
        tempLabel.topToBottom(of: typeWeatherLabel, offset: 7)
        tempLabel.bottomToTop(of: typefeelLabel, offset: -7)
        imgWeather.rightToLeft(of: tempLabel)
    }
    
    private func setStack() {
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
            case 1:
                type = "Давление"
            case 2:
                type = "Влажность"
            case 3:
                type = "Облачность"
            case 4:
                type = "Видимость"
            default:
                type = ""
            }
            for y in 0..<2 {
                let lbl = UILabel()
                row.addArrangedSubview(lbl)
                lbl.text = y==0 ? type : value
                lbl.font = y==0 ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
                lbl.textAlignment = y==0 ? .left : .right
                if y == 1 {
                    masLables.append(lbl)
                }
            }
        }
        backView.addSubview(stackWeather)
        stackWeather.rightToSuperview(offset: -15)
        stackWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        stackWeather.bottomToSuperview(offset: -10)
        stackWeather.leftToRight(of: tempfeelLabel, offset: 5)
        tempLabel.rightToLeft(of: stackWeather, offset: -5)
    }
}
