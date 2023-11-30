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
            downloadCities()
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
    
    func didUpdatedStateForCoin(_ coin: Crypto, isSelected selec: Bool) {
        if selectedCrypto.contains(coin) {
            if let indexAll = arrayCrypto.firstIndex(of: coin), let indexSelect = selectedCrypto.firstIndex(of: coin)  {
                selectedCrypto.remove(at: indexSelect)
                updateCellView?(indexAll)
            }
        }
        if selectedCrypto.count < 3  {
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
