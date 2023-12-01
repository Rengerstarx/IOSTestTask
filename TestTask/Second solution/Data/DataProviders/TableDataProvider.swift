import UIKit

class TableDataProvider {
    
    var updateTableView: (() -> Void)?
    var updateCellView: ((Int) -> Void)?
    private var selectedCity: City?
    private var selectedCrypto = [Crypto]()
    private var arrayCrypto = [Crypto]()
    private var arrayCity = [City]()
    private let defaults = Defaults()
    
    init(widgetType tag: WidgetType) {
        switch tag {
        case .map:
            selectedCity = defaults.getCityMap()
            downloadCities()
        case .weather:
            selectedCity = defaults.getCityWeather()
            downloadCities()
        case .crypto:
            selectedCrypto = defaults.getCoins()
            downloadCrypto()
        }
    }
    
    private func downloadCrypto() {
        Parser.getAllCoins() { resultCrypto, resultError in
            if let result = resultCrypto {
                self.arrayCrypto = result
            }
            self.updateTableView?()
        }
    }
    
    private func downloadCities() {
        Parser.getCities() { result in
            self.arrayCity = result
            self.updateTableView?()
        }
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
        return selectedCrypto.contains(coin)
    }
    
    func didUpdatedStateForCoin(_ coin: Crypto) {
        if selectedCrypto.contains(coin) {
            if let indexAll = arrayCrypto.firstIndex(of: coin), let indexSelect = selectedCrypto.firstIndex(of: coin)  {
                selectedCrypto.remove(at: indexSelect)
                updateCellView?(indexAll)
            }
        } else if selectedCrypto.count < 3  {
            selectedCrypto.append(coin)
        } else {
            let last = selectedCrypto.removeLast()
            selectedCrypto.append(coin)
            if let indexSelect = arrayCrypto.firstIndex(of: last) {
                updateCellView?(indexSelect)
            }
        }
    }
}
