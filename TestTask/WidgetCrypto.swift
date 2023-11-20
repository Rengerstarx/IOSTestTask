//
//  WidgetCrypto.swift
//  TestTask
//
//  Created by sergey on 11/20/23.
//

import UIKit
import SDWebImage
import TinyConstraints

class WidgetCrypto: UIViewController {
    
    var arrayCoins = [Coin?]()
    var arrayParseCoins = [Crypto]()
    let loaderCrypto = UIActivityIndicatorView(style: .gray)
    let bntRepeat = UIButton()
    let stackCoins = UIStackView()
    
    let defaults = UserDefaults()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    
    var noNils = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mainBackGrey")
        
        startWork()
        
    }
    
    @objc private func startWork(){
        
        view.addSubview(loaderCrypto)
        loaderCrypto.startAnimating()
        loaderCrypto.centerInSuperview()
        
        if let savedData3 = defaults.object(forKey: "selectedCoins") as? Data {
            let decoder = JSONDecoder()
            if let savedCoins = try? decoder.decode([Coin?].self, from: savedData3) {
                arrayCoins = savedCoins
            }
        }
        
        noNils = ""
        for i in arrayCoins {
            if i != nil {
                noNils += ",\(i!.id)"
            }
        }
        ParsCities().getCoinInfo(id: noNils){ result in
            
            self.loaderCrypto.removeFromSuperview()
            self.bntRepeat.removeFromSuperview()
            
            if let coins = result as? [Crypto] {
                self.arrayParseCoins = coins
                self.initWdgt()
            } else if let error = result as? String {
                self.alerting()
            }
        }
    }
    
    func initWdgt(){
        stackCoins.axis = .horizontal
        stackCoins.distribution = .fillEqually
        stackCoins.spacing = 10
        stackCoins.backgroundColor = UIColor(named: "mainBackGrey")
        view.addSubview(stackCoins)
        stackCoins.topToSuperview(offset: 5)
        stackCoins.bottomToSuperview(offset: -5)
        stackCoins.leftToSuperview(offset: 5)
        stackCoins.rightToSuperview(offset: -5)
        
        var cnt = 0
        for coin in arrayParseCoins {
            cnt += 1
            stackCoins.addArrangedSubview(initOneCoin(coin: coin))
        }
    }
    
    func initOneCoin(coin cn : Crypto) -> UIView{
        let miniCoin = UIView()
        miniCoin.layer.cornerRadius = 20
        miniCoin.backgroundColor = .white
        
        let labletp = UILabel()
        labletp.text = cn.name
        labletp.font = UIFont.boldSystemFont(ofSize: 14)
        labletp.numberOfLines = 3
        miniCoin.addSubview(labletp)
        labletp.textAlignment = .center
        labletp.leftToSuperview(offset: 5)
        labletp.rightToSuperview(offset: -5)
        labletp.topToSuperview(offset: 7)
        
        let lableChange = UILabel()
        lableChange.font = UIFont.systemFont(ofSize: 12)
        lableChange.textAlignment = .center
        lableChange.text = String(format: "%.3f", cn.priceChangePercentage1HInCurrency)
        if cn.priceChangePercentage1HInCurrency < 0 {
            lableChange.textColor = .red
        }
        else {
            lableChange.textColor = .green
        }
        miniCoin.addSubview(lableChange)
        lableChange.leftToSuperview(offset: 5)
        lableChange.rightToSuperview(offset: -5)
        lableChange.bottomToSuperview(offset: -7)
        
        let lablePrice = UILabel()
        lablePrice.font = UIFont.systemFont(ofSize: 12)
        lablePrice.textAlignment = .center
        lablePrice.textColor = .black
        lablePrice.text = String(format: "%.3f", cn.currentPrice) + "$"
        miniCoin.addSubview(lablePrice)
        lablePrice.leftToSuperview(offset: 5)
        lablePrice.rightToSuperview(offset: -5)
        lablePrice.bottomToTop(of: lableChange, offset: -7)
        
        let image = UIImageView()
        image.sd_setImage(with: URL(string: cn.image))
        
        miniCoin.addSubview(image)
        image.topToBottom(of: labletp, offset: 5)
        image.bottomToTop(of: lablePrice, offset: -5)
        image.leftToSuperview(offset: 5)
        image.rightToSuperview(offset: -5)
        //image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
        image.contentMode = .scaleAspectFit
        
        return miniCoin
    }
    
    func alerting(){
        
        view.addSubview(bntRepeat)
        bntRepeat.backgroundColor = UIColor(named: "mainBlue")
        bntRepeat.layer.cornerRadius = 10
        bntRepeat.setTitleColor(.white, for: .normal)
        bntRepeat.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        bntRepeat.setTitle("Повторить", for: .normal)
        bntRepeat.centerXToSuperview()
        bntRepeat.bottomToSuperview(offset: -20)
        bntRepeat.addTarget(self, action: #selector(startWork), for: .touchUpInside)
        
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей валюте. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }
}
