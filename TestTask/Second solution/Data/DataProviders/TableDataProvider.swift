import UIKit

class TableDataProvider {
    
    var updateTableView: (() -> Void)?
    private var currentCity: City?
    private var currentCrypto = [(Crypto, UISwitch?)]()
    private var arrayCrypto = [Crypto]()
    private var arrayCity = [City]()
    private let def = Defaults()
    private var countOfCoins = 0
    
    init(widgetType tag: WidgetType, currentCity city: City?, currentCrypto crypto: [Crypto]) {
        currentCity = city
        currentCrypto = crypto.convertToPair
        if tag == .crypto {
            downloadCrypto()
        } else {
            arrayCity = downloadCities()
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
    
    func getArrayCount() -> Int {
        return arrayCity.isEmpty ? arrayCrypto.count : arrayCity.count
    }
    
    func getCityById(_ id: Int) -> City {
        return arrayCity[id]
    }
    
    func getCurrentCity() -> City? {
        return currentCity
    }
    
    func getCurrentCrypto() -> [Crypto] {
        return currentCrypto.convertToArray
    }
    
    func getCryptoById(_ id: Int) -> Crypto {
        return arrayCrypto[id]
    }
    
    func deleteCoin(_ name: String) {
        if let number = currentCrypto.checkCoin(name) {
            currentCrypto.remove(at: number)
        }
    }
    
    func checkCoin (_ name: String, _ swtch: UISwitch?) -> Bool {
        if let number = currentCrypto.checkCoin(name) {
            currentCrypto[number].1 = swtch
            return true
        }
        return false
    }
    
    func setCoin(_ coin: Crypto, uiswitch swtch: UISwitch) -> UISwitch? {
        var result: UISwitch? = nil
        if currentCrypto.count != 3 {
            currentCrypto.append((coin,swtch))
        } else {
            result = currentCrypto[countOfCoins].1
            currentCrypto[countOfCoins] = (coin, swtch)
            countOfCoins = (countOfCoins + 1) % 3
        }
        return result
    }
}
