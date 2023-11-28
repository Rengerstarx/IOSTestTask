import UIKit

class TableCitiesData {
    
    var updateTableView: (() -> Void)?
    private var currentCity: City?
    private var currentCrypto: [Crypto?] = [nil, nil, nil]
    private var arrayCrypto = [Crypto]()
    private var arrayCity = [City]()
    private let def = Defaults()
    private var isCity = true
    private var swch: UISwitch?
    
    func initer(_ isCity: Bool, currentCity city: City?, currentCrypto crypto: [Crypto?]) {
        currentCity = city
        currentCrypto = crypto
        while currentCrypto.count < 3 {
            currentCrypto.append(nil)
        }
        self.isCity = isCity
        if isCity {
            arrayCity = downloadCities()
        } else {
            downloadCrypto()
        }
    }
    
    private func downloadCrypto() {
        Parser().getAllCoins() { resultCrypto, resultError in
            if let result = resultCrypto {
                self.arrayCrypto = result
            }
            self.updateTableView?()
        }
    }
    
    private func downloadCities() -> [City] {
        return Parser().getCities()
    }
    
    func getIsCity() -> Bool {
        return isCity
    }
    
    func getArrayCount() -> Int {
        if isCity {
            return arrayCity.count
        } else {
            return arrayCrypto.count
        }
    }
    
    func getCityById(_ id: Int) -> City {
        return arrayCity[id]
    }
    
    func getCurrentCity() -> City? {
        return currentCity
    }
    
    func getCurrentCrypto() -> [Crypto?] {
        return currentCrypto
    }
    
    func getCryptoById(_ id: Int) -> Crypto {
        return arrayCrypto[id]
    }
    
    func deleteCoin(_ name: String) {
        for i in 0..<currentCrypto.count {
            if currentCrypto[i]?.name == name {
                currentCrypto[i] = nil
            }
        }
    }
    
    func checkCoin (_ name: String, _ swth: UISwitch?) -> Bool {
        for i in 0..<currentCrypto.count {
            if currentCrypto[i]?.name == name {
                if i == 2 {
                    swch = swth
                }
                return true
            }
        }
        return false
    }
    
    func setCoin(_ coin: Crypto?, uiswitch swtch: UISwitch?) -> UISwitch? {
        var mark = false
        for i in 0..<currentCrypto.count {
            if currentCrypto[i] == nil {
                currentCrypto[i] = coin
                mark = true
                swch = i==2 ? swtch : nil
                return nil
            }
        }
        print(currentCrypto)
        if !mark {
            currentCrypto[2] = coin
            let buffer = swch
            swch = swtch
            return buffer
        }
        return nil
    }
}
