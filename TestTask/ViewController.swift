//
//  ViewController.swift
//  TestTask
//
//  Created by sergey on 11/13/23.
//

import UIKit
import TinyConstraints
import MapKit
import SDWebImage

class ViewController: UIViewController {
    
    var count = 0
    var taperMap = UITapGestureRecognizer()
    var taperWeather = UITapGestureRecognizer()
    var taperCrypto = UITapGestureRecognizer()
    let stackView = UIStackView()
    
    //ViewTop:
    private let viewTop = UIView()
    private let buttonChange = UIButton(/*type: .system*/)
    private let lableTop = UILabel()
    
    //ViewMap:
    let viewMap = UIView()
    let lableMap = UILabel()
    let mapView = MKMapView()
    let imageMap = UIImageView()
    let imageMapSet = UIImageView()
    let buttonMap = UIButton(type: .roundedRect)
    
    //ViewWeather
    let viewWeather = UIView()
    var nowWeather: Weather?
    var isParseWeather = 404
    let lableWeather = UILabel()
    let imageWeather = UIImageView()
    let imageWeatherSet = UIImageView()
    let buttonWeather = UIButton(type: .roundedRect)
    let loaderWeather = UIActivityIndicatorView(style: .gray)

    //Viewcrypto
    let viewCrypto = UIView()
    let lableCrypto = UILabel()
    let imageCrypto = UIImageView()
    let buttonCrypto = UIButton(type: .roundedRect)
    var isCrypto = false
    var coinsArray = [Coin?]()
    let imageCryptoSet = UIImageView()

    //Color
    let mainBlue = UIColor(named: "mainBlue")
    let backGrey = UIColor(named: "mainBackGrey")
    
    //UserDefaults
    let defaults = UserDefaults()
    let defaultsString = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var isMap = false
    var isWeather = false
    var cityWeather: City?
    var cityMap: City?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backGrey
        viewTop.backgroundColor = mainBlue
        viewMap.backgroundColor = .white
        viewCrypto.backgroundColor = .white
        viewWeather.backgroundColor = .white
        
        let child = WidgetCrypto()
        addChild(child)
        view.addSubview(child.view)
        
        taperMap = UITapGestureRecognizer(target: self, action: #selector(selectCityMap))
        taperWeather = UITapGestureRecognizer(target: self, action: #selector(selectCityWeather))
        taperCrypto = UITapGestureRecognizer(target: self, action: #selector(selectCrypto))
        
        if let savedData = defaults.object(forKey: "selectedMapCity") as? Data {
            let decoder = JSONDecoder()
            if let savedCity = try? decoder.decode(City.self, from: savedData) {
                cityMap = savedCity
                isMap = true
                print("Choosed Map-City: \(savedCity)")
            }
        }
        else{
            isMap = false
        }
        if let savedData2 = defaults.object(forKey: "selectedWeatherCity") as? Data {
            let decoder = JSONDecoder()
            if let savedCity2 = try? decoder.decode(City.self, from: savedData2) {
                cityWeather = savedCity2
                isWeather = true
                print("Choosed Weather-City: \(savedCity2)")
            }
        }
        else {
            isWeather = false
        }
        
        if let savedData3 = defaults.object(forKey: "selectedCoins") as? Data {
            let decoder = JSONDecoder()
            if let savedCoins = try? decoder.decode([Coin?].self, from: savedData3) {
                coinsArray = savedCoins
                isCrypto = true
                print("Choosed coins: \(savedCoins)")
            }
        }
        else {
            isCrypto = false
        }
        
        setupView()
        
    }
    
    fileprivate func setupView() {
        addSubviews()
        initTopView()
        initFirstView()
        initSecondView()
        initThirdView()
        initStackView()
    }
    
    fileprivate func addSubviews() {
        self.view.addSubview(viewTop)
        self.view.addSubview(stackView)
    }
    
    fileprivate func initTopView(){
        viewTop.edgesToSuperview(excluding: .bottom)
        viewTop.height(90)
        
        viewTop.addSubview(lableTop)
        lableTop.text = "Главный экран"
        lableTop.textColor = .white
        lableTop.font = UIFont.systemFont(ofSize: 24)
        lableTop.bottomToSuperview(offset: -10)
        lableTop.centerXToSuperview()
        
        viewTop.addSubview(buttonChange)
        buttonChange.setTitle("Править", for: .normal)
        //buttonChange.bottomToSuperview(offset: -10)
        buttonChange.centerY(to: lableTop)
        buttonChange.rightToSuperview(offset: -15)
    }
    
    fileprivate func initStackView(){
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.addArrangedSubview(viewMap)
        stackView.addArrangedSubview(viewWeather)
        stackView.addArrangedSubview(viewCrypto)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topToBottom(of: viewTop, offset: 10)
        stackView.leftToSuperview(offset: 15)
        stackView.rightToSuperview(offset: -15)
        stackView.bottomToSuperview(offset: -20)
    }
    
    fileprivate func initFirstView(){
        viewMap.layer.cornerRadius = 20
        
        viewMap.addSubview(lableMap)
        lableMap.text = "Карта"
        lableMap.font = UIFont.systemFont(ofSize: 16)
        lableMap.textColor = .gray
        lableMap.topToSuperview(offset: 10)
        lableMap.leftToSuperview(offset: 10)
        
        if isMap{
            viewMap.addSubview(imageMapSet)
            imageMapSet.image = UIImage(named: "settings")
            imageMapSet.topToSuperview(offset: 10)
            imageMapSet.rightToSuperview(offset: -10)
            imageMapSet.isUserInteractionEnabled = true
            imageMapSet.addGestureRecognizer(taperMap)
            
            mapInit()
            viewMap.addSubview(mapView)
            mapView.topToBottom(of: lableMap, offset: 0)
            mapView.leftToSuperview(offset: 10)
            mapView.rightToSuperview(offset: -10)
            mapView.bottomToSuperview(offset: -10)
        }
        else{
            viewMap.addSubview(imageMap)
            imageMap.image = UIImage(named: "mapBack")
            imageMap.topToBottom(of: lableMap, offset: 5)
            imageMap.leftToSuperview(offset: 10)
            imageMap.rightToSuperview(offset: -10)
            imageMap.bottomToSuperview(offset: -10)
            
            viewMap.addSubview(buttonMap)
            buttonMap.backgroundColor = mainBlue
            buttonMap.layer.cornerRadius = 10
            buttonMap.setTitleColor(.white, for: .normal)
            buttonMap.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            buttonMap.setTitle("Выбрать", for: .normal)
            buttonMap.centerXToSuperview()
            buttonMap.bottomToSuperview(offset: -30)
            buttonMap.addTarget(self, action: #selector(selectCityMap), for: .touchUpInside)
        }
        
    }
    
    func mapInit(){
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coord = CLLocationCoordinate2D(latitude: cityMap!.latitude, longitude: cityMap!.longitude)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "City: \(cityMap!.name)"
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func initSecondView(){
        viewWeather.layer.cornerRadius = 20
        
        viewWeather.addSubview(lableWeather)
        lableWeather.text = "Погода"
        lableWeather.font = UIFont.systemFont(ofSize: 16)
        lableWeather.textColor = .gray
        lableWeather.topToSuperview(offset: 10)
        lableWeather.leftToSuperview(offset: 10)
        
        viewWeather.addSubview(imageWeather)
        imageWeather.image = UIImage(named: "weatherBack")
        imageWeather.topToBottom(of: lableWeather, offset: 5)
        imageWeather.leftToSuperview(offset: 10)
        imageWeather.rightToSuperview(offset: -10)
        imageWeather.bottomToSuperview(offset: -10)
        
        if isWeather {
            viewWeather.addSubview(imageWeatherSet)
            imageWeatherSet.image = UIImage(named: "settings")
            imageWeatherSet.topToSuperview(offset: 10)
            imageWeatherSet.rightToSuperview(offset: -10)
            imageWeatherSet.isUserInteractionEnabled = true
            imageWeatherSet.addGestureRecognizer(taperWeather)
            
            parseWeather()
        }
        else {
            viewWeather.addSubview(buttonWeather)
            buttonWeather.backgroundColor = mainBlue
            buttonWeather.layer.cornerRadius = 10
            buttonWeather.setTitleColor(.white, for: .normal)
            buttonWeather.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            buttonWeather.setTitle("Выбрать", for: .normal)
            buttonWeather.centerXToSuperview()
            buttonWeather.bottomToSuperview(offset: -30)
            buttonWeather.addTarget(self, action: #selector(selectCityWeather), for: .touchUpInside)
        }
        
    }
    
    fileprivate func initThirdView(){
        viewCrypto.layer.cornerRadius = 20
        
        viewCrypto.addSubview(lableCrypto)
        lableCrypto.text = "Курс криптовалют"
        lableCrypto.font = UIFont.systemFont(ofSize: 16)
        lableCrypto.textColor = .gray
        lableCrypto.topToSuperview(offset: 10)
        lableCrypto.leftToSuperview(offset: 10)
        
        viewCrypto.addSubview(imageCrypto)
        imageCrypto.image = UIImage(named: "cryptoBack")
        imageCrypto.topToBottom(of: lableCrypto, offset: 5)
        imageCrypto.leftToSuperview(offset: 10)
        imageCrypto.rightToSuperview(offset: -10)
        imageCrypto.bottomToSuperview(offset: -10)
        
        if isCrypto {
            viewCrypto.addSubview(imageCryptoSet)
            imageCryptoSet.image = UIImage(named: "settings")
            imageCryptoSet.topToSuperview(offset: 10)
            imageCryptoSet.rightToSuperview(offset: -10)
            imageCryptoSet.isUserInteractionEnabled = true
            imageCryptoSet.addGestureRecognizer(taperCrypto)
        }
        else{
            viewCrypto.addSubview(buttonCrypto)
            buttonCrypto.backgroundColor = mainBlue
            buttonCrypto.layer.cornerRadius = 10
            buttonCrypto.setTitleColor(.white, for: .normal)
            buttonCrypto.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            buttonCrypto.setTitle("Выбрать", for: .normal)
            buttonCrypto.centerXToSuperview()
            buttonCrypto.bottomToSuperview(offset: -30)
            buttonCrypto.addTarget(self, action: #selector(selectCrypto), for: .touchUpInside)
        }
        
        
    }
    
    
    
    @objc private func selectCityMap(){
        defaultsString.set("selectedMapCity", forKey: "Selected")
        let changerViewController = ChangerViewController()
        UIApplication.shared.keyWindow?.rootViewController = changerViewController
    }
    
    @objc private func selectCityWeather(){
        defaultsString.set("selectedWeatherCity", forKey: "Selected")
        let changerViewController = ChangerViewController()
        UIApplication.shared.keyWindow?.rootViewController = changerViewController
    }
    
    @objc private func selectCrypto(){
        defaultsString.set("selectedCrypto", forKey: "Selected")
        let changerViewController = ChangerViewController()
        UIApplication.shared.keyWindow?.rootViewController = changerViewController
    }
    
    @objc private func parseWeather(){
        viewWeather.addSubview(loaderWeather)
        loaderWeather.center(in: imageWeather)
        loaderWeather.startAnimating()
        buttonWeather.removeFromSuperview()
        
        ParsWeather().pars(lati: cityWeather?.latitude, long: cityWeather?.longitude){result in
            //print(result)
            if let weather = result as? Weather {
                self.nowWeather = weather
                self.isParseWeather = 200
            } else if let error = result as? String {
                self.isParseWeather = 404
            }
            self.initWeatherWidget()
        }
    }
    
    private func initWeatherWidget(){
        loaderWeather.removeFromSuperview()
        
        if isParseWeather == 404 {
            imageWeather.isHidden = false
            let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей погоде. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
            viewWeather.addSubview(buttonWeather)
            buttonWeather.backgroundColor = mainBlue
            buttonWeather.layer.cornerRadius = 10
            buttonWeather.setTitleColor(.white, for: .normal)
            buttonWeather.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            buttonWeather.setTitle("Повторить", for: .normal)
            buttonWeather.centerXToSuperview()
            buttonWeather.bottomToSuperview(offset: -30)
            buttonWeather.addTarget(self, action: #selector(parseWeather), for: .touchUpInside)
        }
        else if isParseWeather == 200 {
            imageWeather.isHidden = true
            
            let widget = WidgetController(widgetView: viewWeather, city: cityWeather!, weather: nowWeather!, topObject: lableWeather)
            
            widget.initWidget()
        }
        
    }
}

