import UIKit
import TinyConstraints
import MapKit
import SDWebImage

extension ViewController {
    func setBar() {
        let navBar = self.navigationController!.navigationBar
        let standartAppearence = UINavigationBarAppearance()
        standartAppearence.configureWithOpaqueBackground()
        standartAppearence.backgroundColor = UIColor.appBlue
        standartAppearence.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 24)]
        navBar.standardAppearance = standartAppearence
        navBar.scrollEdgeAppearance = standartAppearence
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
}

class ViewController: UIViewController {

    private let map = PaternView(name: "Карта", imageS: "mapBack")
    private let weather = PaternView(name: "Погода", imageS: "weatherBack")
    private let crypto = PaternView(name: "Криптовалюта", imageS: "cryptoBack")
    private let stackView = UIStackView()
    private let mapView = WidgetMap()
    private let weatherView = WidgetWeather()
    private let cryptoView = WidgetCrypto()
    private let def = Defaults()
    private var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appGrey
        title = "Главное меню"
        setBar()
        setupView()
    }
    
    private func setupView() {
        addSubviews()
        initFirstView()
        initSecondView()
        initThirdView()
        initStackView()
    }
    
    private func addSubviews() {
        self.view.addSubview(stackView)
    }
    
    private func initStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.addArrangedSubview(map.view)
        stackView.addArrangedSubview(weather.view)
        stackView.addArrangedSubview(crypto.view)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topToSuperview(offset: 10)
        stackView.leftToSuperview(offset: 15)
        stackView.rightToSuperview(offset: -15)
        stackView.bottomToSuperview(offset: -20)
    }
    
    private func initPaternStart(view patern: PaternView) {
        patern.view.backgroundColor = .white
        patern.view.layer.cornerRadius = 20
        patern.view.addSubview(patern.lable)
        patern.lable.text = patern.name
        patern.lable.font = UIFont.systemFont(ofSize: 16)
        patern.lable.textColor = .gray
        patern.lable.topToSuperview(offset: 10)
        patern.lable.leftToSuperview(offset: 10)
        patern.view.addSubview(patern.image)
        patern.image.image = UIImage(named: patern.imageS)
        patern.image.topToBottom(of: patern.lable, offset: 10)
        patern.image.leftToSuperview(offset: 10)
        patern.image.rightToSuperview(offset: -10)
        patern.image.bottomToSuperview(offset: -10)
        patern.view.addSubview(patern.button)
        patern.button.backgroundColor = UIColor.appBlue
        patern.button.layer.cornerRadius = 10
        patern.button.setTitleColor(.white, for: .normal)
        patern.button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        patern.button.setTitle("Выбрать", for: .normal)
        patern.button.centerXToSuperview()
        patern.button.bottomToSuperview(offset: -30)
        patern.button.tag = count
        count += 1
        patern.button.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
    }
    
    private func initPaternLoad(view patern: PaternView) {
        patern.view.addSubview(patern.buttonSet)
        patern.buttonSet.setImage(UIImage(named: "settings"), for: .normal)
        patern.buttonSet.topToSuperview(offset: 10)
        patern.buttonSet.rightToSuperview(offset: -10)
        patern.buttonSet.tag = patern.button.tag
        patern.buttonSet.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
    }
    
    private func initFirstView() {
        initPaternStart(view: map)
        if mapView.getActive() {
            initPaternLoad(view: map)
            let miniMap = mapView.getMap()
            unboxWidget(topObject:map.lable, widgetView: miniMap, mainView: map.view)
        }
    }
    
    private func initSecondView() {
        initPaternStart(view: weather)
        if weatherView.getActive() {
            initPaternLoad(view: weather)
            let miniWeather = weatherView.getView()
            unboxWidget(topObject:weather.lable, widgetView: miniWeather, mainView: weather.view)
        }
    }
    
    private func initThirdView() {
        initPaternStart(view: crypto)
        if cryptoView.getActive() {
            initPaternLoad(view: crypto)
            let miniCrypto = cryptoView.getView()
            unboxWidget(topObject:crypto.lable, widgetView: miniCrypto, mainView: crypto.view)
        }
    }
    
    private func unboxWidget(topObject top: UILabel, widgetView wgtView: UIView, mainView mnView: UIView) {
        mnView.addSubview(wgtView)
        wgtView.topToBottom(of: top, offset: 10)
        wgtView.leftToSuperview(offset: 10)
        wgtView.rightToSuperview(offset: -10)
        wgtView.bottomToSuperview(offset: -10)
    }
    
    @objc private func selectAction(sender:UIButton) {
        var target = ""
        switch sender.tag {
        case 1:
            target = "selectedMapCity"
        case 2:
            target = "selectedWeatherCity"
        default:
            target = "selectedCoins"
        }
        let controller = TableViewController(typeOfTable: target)
        controller.completionHandler = handleResult
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleResult(_ value: String) {
        switch value {
        case "selectedMapCity":
            mapView.update()
        case "selectedWeatherCity":
            weatherView.update()
        case "selectedCoins":
            cryptoView.update()
        default:
            print("No updates")
        }
        print(value)
    }
}
