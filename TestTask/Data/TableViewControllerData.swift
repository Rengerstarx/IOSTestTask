import UIKit

struct CoinsView {
    var number1: Int? = nil
    var number2: Int? = nil
    var number3: Int? = nil
    var selectedCoin1: Coin? = nil
    var selectedCoin2: Coin? = nil
    var selectedCoin3: Coin? = nil
}

class TableViewControllerData {
    private var coins = CoinsView()
    private var arrayCity = [City]()
    private var arrayCrypto = [Crypto]()
    private var selectedString = ""
    private var isCrypto = false
    private let def = Defaults()
    
    init(typeOfTableView selectedType: String) {
        selectedString = selectedType
        if selectedString != "selectedCoins" {
            isCrypto = false
            arrayCity = downloadCities()
        } else {
            isCrypto = true
        }
    }
    
    func takeControllerType() -> String {
        return selectedString
    }
    
    private func downloadCities() -> [City]{
        return Parser().getCities()
    }
    
    func downloadCoins(completion: @escaping ([Crypto]?,String?) -> Void) {
        initStartCoins()
        Parser().getAllCoins() { resultCoins, resultError in
            if resultCoins != nil {
                self.arrayCrypto = resultCoins!
                completion(resultCoins, nil)
            } else {
                completion(nil, "Error")
            }
        }
    }
    
    private func initStartCoins() {
        let savedCoins = def.getCoins("selectedCoins")
        coins.selectedCoin1 = savedCoins[0]
        coins.selectedCoin2 = savedCoins[1]
        coins.selectedCoin3 = savedCoins[2]
    }
    
    func checkCoin(_ name: String, _ number: Int) -> Bool {
        switch name{
        case coins.selectedCoin1?.name:
            coins.number1 = number
            return true
        case coins.selectedCoin2?.name:
            coins.number2 = number
            return true
        case coins.selectedCoin3?.name:
            coins.number3 = number
            return true
        default:
            return false
        }
        return false
    }
    
    func deleteCoin(_ number: Int) {
        switch number{
        case coins.number1:
            coins.number1 = nil
            coins.selectedCoin1 = nil
        case coins.number2:
            coins.number2 = nil
            coins.selectedCoin2 = nil
        case coins.number3:
            coins.number3 = nil
            coins.selectedCoin3 = nil
        default:
            print("No to delete")
        }
        unloadCoins()
    }
    
    func addCoin(_ number: Int, _ coin: Coin) -> Int {
        if coins.selectedCoin1 == nil {
            coins.number1 = number
            coins.selectedCoin1 = coin
        } else if coins.selectedCoin2 == nil {
            coins.number2 = number
            coins.selectedCoin2 = coin
        } else if coins.selectedCoin3 == nil {
            coins.number3 = number
            coins.selectedCoin3 = coin
        } else {
            let nmb = coins.number3
            coins.number3 = number
            coins.selectedCoin3 = coin
            unloadCoins()
            return nmb!
        }
        unloadCoins()
        return number
    }
    
    private func unloadCoins(){
        let array = [coins.selectedCoin1,coins.selectedCoin2,coins.selectedCoin3]
        def.setCoins(coins: array, key: "selectedCoins")
    }
    
    func unloadCities(_ city: City) {
        def.setCity(city: city, key: selectedString)
    }
    
    func getCities() -> [City] {
        return arrayCity
    }
    
    func getMarker() -> Bool {
        return isCrypto
    }
}
