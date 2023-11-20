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
    
    let defaults = UserDefaults()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var noNils = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startWork()
        
    }
    
    private func startWork(){
        if let savedData3 = defaults.object(forKey: "selectedCoins") as? Data {
            let decoder = JSONDecoder()
            if let savedCoins = try? decoder.decode([Coin?].self, from: savedData3) {
                arrayCoins = savedCoins
            }
        }
        
        view.addSubview(loaderCrypto)
        loaderCrypto.startAnimating()
        loaderCrypto.centerInSuperview()
        
        noNils = ""
        for i in arrayCoins {
            if i != nil {
                noNils += ",\(i!.id)"
            }
        }
        ParsCities().getCoinInfo(id: noNils){ result in
            if let coins = result as? [Crypto] {
                self.loaderCrypto.removeFromSuperview()
                self.arrayParseCoins = coins
                //self.isParseWeather = 200
            } else if let error = result as? String {
                //self.isParseWeather = 404
            }
        }
    }
}
