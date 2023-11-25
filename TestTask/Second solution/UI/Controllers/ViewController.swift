import UIKit
import TinyConstraints
import MapKit
import SDWebImage

//1 - Map, 2 - Weather, 3 - Crypto
protocol SetupDelegate: AnyObject {
    func setupData(tag value: Int)
}

class ViewController: UIViewController, SetupDelegate {
    
    private let stackView = MainStackView()
    private let mapView = MapWidgetView()
    private let mapData = MapDataProvider()
    private let weatherView = WeatherWidgetView()
    private let weatherData = WeatherDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appGrey
        title = "Главное меню"
        mapData.delegate = self
        weatherData.delegate = self
        mapData.initData()
        weatherData.initData()
        setBar()
        initStackView()
        initMap()
        initWeather()
    }
    
    private func initStackView() {
        view.addSubview(stackView)
        stackView.edgesToSuperview(excluding: .trailing, insets: .uniform(10))
    }
    
    func setupData(tag value: Int) {
        if value == 1 {
            if mapData.getActive() {
                mapView.switcher(true)
                mapView.setup(mapData.getCity()!)
            } else {
                mapView.switcher(false)
            }
        } else if value == 2 {
            if weatherData.getActive() {
                weatherView.switcher(true)
                weatherView.setup(nowWeather: weatherData.getWeather(), nowWcity: weatherData.getCity()!, descripnion: weatherData.getType())
            } else {
                weatherView.switcher(false)
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
    
    @objc private func selectMap() {
        let controller = TableViewController(mapData.getCity())
        controller.completionHandler = handleResultMap
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func selectWeather() {
        let controller = TableViewController(weatherData.getCity())
        controller.completionHandler = handleResultWeather
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleResultMap(_ value: City?) {
        mapData.update(selectedCity: value)
    }
    
    private func handleResultWeather(_ value: City?) {
        weatherData.update(selectedCity: value)
    }
}
