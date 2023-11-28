import UIKit
import TinyConstraints
import MapKit
import SDWebImage

protocol SetupDelegate: AnyObject {
    func setupData(widgetType tag: WidgetType)
}

class ViewController: UIViewController, SetupDelegate {
    
    private let stackView = UIStackView()
    private let mapView = MapWidgetView()
    private let mapData = MapDataProvider()
    private let weatherView = WeatherWidgetView()
    private let weatherData = WeatherDataProvider()
    private let cryptoView = CryptoWidgetView()
    private let cryptoData = CryptoDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appGrey
        title = "Главное меню"
        mapData.delegate = self
        weatherData.delegate = self
        cryptoData.delegate = self
        mapData.initData()
        weatherData.initData()
        cryptoData.initData()
        setBar()
        initStackView()
        initMap()
        initWeather()
        initCrypto()
    }
    
    private func initStackView() {
        view.addSubview(stackView)
        stackView.edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }
    
    func setupData(widgetType tag: WidgetType) {
        switch tag {
        case .map:
            if mapData.getActive() {
                mapView.switcher(true)
                mapView.setup(mapData.getCity()!)
            } else {
                mapView.switcher(false)
            }
        case .weather:
            if weatherData.getActive() {
                weatherView.switcher(true)
                weatherView.setup(nowWeather: weatherData.getWeather(), nowWcity: weatherData.getCity()!, descripnion: weatherData.getType())
            } else {
                weatherView.switcher(false)
            }
        case .crypto:
            if cryptoData.getActive() {
                cryptoView.switcher(true)
                cryptoView.setup(cryptoData.getCoins())
            } else {
                cryptoView.switcher(false)
            }
        }
    }
    
    private func initMap() {
        mapView.settingsButton.addTarget(self, action: #selector(selectMap), for: .touchUpInside)
        mapView.startButton.addTarget(self, action: #selector(selectMap), for: .touchUpInside)
        stackView.addArrangedSubview(mapView)
    }
    
    private func initWeather() {
        weatherView.settingsButton.addTarget(self, action: #selector(selectWeather), for: .touchUpInside)
        weatherView.startButton.addTarget(self, action: #selector(selectWeather), for: .touchUpInside)
        stackView.addArrangedSubview(weatherView)
    }
    
    private func initCrypto() {
        cryptoView.settingsButton.addTarget(self, action: #selector(selectCrypto), for: .touchUpInside)
        cryptoView.startButton.addTarget(self, action: #selector(selectCrypto), for: .touchUpInside)
        stackView.addArrangedSubview(cryptoView)
    }
    
    @objc private func selectMap() {
        let controller = TableViewController(true, mapData.getCity(), [nil])
        controller.completionHandler = handleResultMap
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func selectWeather() {
        let controller = TableViewController(true, weatherData.getCity(), [nil])
        controller.completionHandler = handleResultWeather
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func selectCrypto() {
        let controller = TableViewController(false, nil, cryptoData.getCoins())
        controller.completionHandlerCrypto = handleResultCrypto
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleResultMap(_ value: City?) {
        mapData.update(selectedCity: value)
    }
    
    private func handleResultWeather(_ value: City?) {
        weatherData.update(selectedCity: value)
    }
    
    private func handleResultCrypto(_ value: [Crypto?]) {
        cryptoData.update(newCoins: value.compactMap{$0})
    }
}
