import UIKit

class TableDataProvider {
    
    var updateTableView: (() -> Void)?
    var updateCellView: ((Int) -> Void)?
    private var selectedCity: City?
    private var selectedCrypto = [Crypto]()
    private var arrayCrypto = [Crypto]()
    private var arrayCity = [City]()
    private let def = Defaults()
    private var countOfCoins = 0
    
    init(widgetType tag: WidgetType, currentCity city: City?, currentCrypto crypto: [Crypto]) {
        selectedCity = city
        selectedCrypto = crypto
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
    
    func getSelectedCity() -> City? {
        return selectedCity
    }
    
    func getSelectedCrypto() -> [Crypto] {
        return selectedCrypto
    }
    
    func getCryptoById(_ id: Int) -> Crypto {
        return arrayCrypto[id]
    }
    
    func isSelectedCoin(_ coin: Crypto) -> Bool {
        return selectedCrypto.checkCoin(coin.name)
    }
    
    func didUpdatedStateForCoin(_ coin: Crypto, isSelected selec: Bool) {
        if selectedCrypto.count != 3  {
            selectedCrypto.append(coin)
        } else {
            let buffer = selectedCrypto[countOfCoins]
            selectedCrypto[countOfCoins] = coin
            countOfCoins = (countOfCoins + 1) % 3
            for i in 0..<arrayCrypto.count {
                if arrayCrypto[i].name == buffer.name {
                    updateCellView?(i)
                }
            }
        }
        
    }
}
