import UIKit
import TinyConstraints
import MapKit
import SDWebImage

protocol SetupDelegate: AnyObject {
    func setupData(widgetType tag: WidgetType)
    func setLoader(widgetType tag: WidgetType)
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
            mapView.setHiddenLoader(true)
            mapView.setView(widgetState: mapData.getState())
            if mapData.getState() == .correct { mapView.setup(mapData.getCity()!)
            }
        case .weather:
            weatherView.setHiddenLoader(true)
            weatherView.setView(widgetState: weatherData.getState())
            if weatherData.getState() == .correct {
                weatherView.setup(nowWeather: weatherData.getWeather(), nowWcity: weatherData.getCity()!, descripnion: weatherData.getType())
            }
        case .crypto:
            cryptoView.setHiddenLoader(true)
            cryptoView.setView(widgetState: cryptoData.getState())
            if cryptoData.getState() == .correct {
                cryptoView.setup(cryptoData.getCoins())
            }
        }
    }
    
    func setLoader(widgetType tag: WidgetType) {
        switch tag {
        case .map:
            mapView.setHiddenLoader(false)
        case .weather:
            weatherView.setHiddenLoader(false)
        case .crypto:
            cryptoView.setHiddenLoader(false)
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
        let controller = TableViewController(widgetType: .map, mapData.getCity(), [])
        controller.completionHandler = handleResultMap
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func selectWeather() {
        let controller = TableViewController(widgetType: .weather, weatherData.getCity(), [])
        controller.completionHandler = handleResultWeather
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func selectCrypto() {
        let controller = TableViewController(widgetType: .crypto, nil, cryptoData.getCoins())
        controller.completionHandlerCrypto = handleResultCrypto
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleResultMap(_ value: City?) {
        mapData.update(selectedCity: value)
    }
    
    private func handleResultWeather(_ value: City?) {
        weatherData.update(selectedCity: value)
    }
    
    private func handleResultCrypto(_ value: [Crypto]) {
        cryptoData.update(newCoins: value)
    }	
}
