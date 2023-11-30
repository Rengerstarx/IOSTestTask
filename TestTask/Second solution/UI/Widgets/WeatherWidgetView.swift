import UIKit
import MapKit
import TinyConstraints
import SDWebImage

class WeatherWidgetView: BaseWidgetView {
    private let additionalView = UIView()
    private let stackWeather = UIStackView()
    private var wthTypeIm = ""
    private var wthTypeString = ""
    private let imgWeather = UIImageView()
    private let cityLabel = UILabel()
    private let typeWeatherLabel = UILabel()
    private let tempLabel = UILabel()
    private let typefeelLabel = UILabel()
    private let tempfeelLabel = UILabel()
    private var masLables: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStart(nameOfView: "Weather", imageOfView: "weatherBack")
        setupLayout()
        setupView()
    }
    
    override func setupStart(nameOfView name: String, imageOfView image: String) {
        super.setupStart(nameOfView: name, imageOfView: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        additionalView.addSubview(cityLabel)
        cityLabel.topToSuperview(offset: 15)
        cityLabel.leftToSuperview(offset: 15)
        additionalView.addSubview(typeWeatherLabel)
        typeWeatherLabel.topToBottom(of: cityLabel)
        typeWeatherLabel.leftToSuperview(offset: 15)
        additionalView.addSubview(typefeelLabel)
        typefeelLabel.leftToSuperview(offset: 15)
        typefeelLabel.bottomToSuperview(offset: -10)
        additionalView.addSubview(tempfeelLabel)
        tempfeelLabel.leftToRight(of: typefeelLabel)
        tempfeelLabel.bottomToSuperview(offset: -10)
        additionalView.addSubview(imgWeather)
        imgWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        imgWeather.bottomToTop(of: typefeelLabel, offset: -7)
        imgWeather.leftToSuperview(offset: 15)
        additionalView.addSubview(tempLabel)
        tempLabel.topToBottom(of: typeWeatherLabel, offset: 7)
        tempLabel.bottomToTop(of: typefeelLabel, offset: -7)
        imgWeather.rightToLeft(of: tempLabel)
        additionalView.addSubview(stackWeather)
        stackWeather.rightToSuperview(offset: -15)
        stackWeather.topToBottom(of: typeWeatherLabel, offset: 7)
        stackWeather.bottomToSuperview(offset: -10)
        stackWeather.leftToRight(of: tempfeelLabel, offset: 5)
        tempLabel.rightToLeft(of: stackWeather, offset: -5)
        for _ in 0..<5 {
            let lbl = UILabel()
            stackWeather.addArrangedSubview(lbl)
            masLables.append(lbl)
        }
        super.containerView.addSubview(additionalView)
        additionalView.edgesToSuperview()
    }
    
    override func setupView() {
        super.setupView()
        cityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cityLabel.textColor = .black
        typeWeatherLabel.font = UIFont.systemFont(ofSize: 14)
        typeWeatherLabel.textColor = .black
        typefeelLabel.text = "Ощущается как: "
        typefeelLabel.font = UIFont.systemFont(ofSize: 14)
        typefeelLabel.textColor = .black
        tempfeelLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tempfeelLabel.textColor = .black
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tempLabel.textColor = .black
        stackWeather.axis = .vertical
        stackWeather.distribution = .fillEqually
        stackWeather.spacing = 1
        for i in 0..<5 {
            masLables[i].textColor = .black
            masLables[i].font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    
    func setup(nowWeather wth: Weather, nowWcity city: City, descripnion desc: (String,String)) {
        cityLabel.text = city.name
        tempLabel.text = wth.main.temp.fahrenheitToCelsius
        tempfeelLabel.text = wth.main.feelsLike.fahrenheitToCelsius
        typeWeatherLabel.text = desc.0
        imgWeather.sd_setImage(with: URL(string: desc.1))
        masLables[0].text = "Wind speed: \(wth.wind.speed)"
        masLables[1].text = "Pressure: \(wth.main.pressure ?? 0)"
        masLables[2].text = "Humidity: \(wth.main.humidity ?? 0)"
        masLables[3].text = "Cloudness: \(wth.clouds.all)"
        masLables[4].text = "Visibility: \(Double(wth.visibility).metersToKilometrs)"
    }
}
