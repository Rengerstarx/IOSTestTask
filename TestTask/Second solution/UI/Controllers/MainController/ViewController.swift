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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appGrey
        title = "Главное меню"
        mapData.delegate = self
        mapData.initData()
        setBar()
        initStackView()
        initMap()
    }
    
    private func initStackView() {
        view.addSubview(stackView)
        stackView.topToSuperview(offset: 10)
        stackView.leftToSuperview(offset: 15)
        stackView.rightToSuperview(offset: -15)
        stackView.bottomToSuperview(offset: -20)
    }
    
    func setupData(tag value: Int) {
        if value == 1 {
            if mapData.getActive() {
                mapView.switcher(true)
                mapView.setup(mapData.getCity()!)
            } else {
                mapView.switcher(false)
            }
        }
    }
    
    private func initMap() {
        mapView.settingsButton.addTarget(self, action: #selector(selectMap), for: .touchUpInside)
        mapView.startButton.addTarget(self, action: #selector(selectMap), for: .touchUpInside)
        stackView.addArrangedSubview(mapView)
    }
    
    @objc private func selectMap() {
        let controller = TableViewController(typeOfTable: "selectedMapCity", mapData.getCity())
        controller.completionHandler = handleResultMap
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleResultMap(_ value: City?) {
        mapData.update(selectedCity: value)
    }
}
