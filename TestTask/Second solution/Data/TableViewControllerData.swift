import UIKit

class TableViewControllerData {
    private var arrayCity = [City]()
    private let def = Defaults()
    
    init() {
        arrayCity = downloadCities()
    }
    
    private func downloadCities() -> [City]{
        return Parser().getCities()
    }
    
    func getCitiesCount() -> Int {
        return arrayCity.count
    }
    
    func getCityById(_ id: Int) -> City {
        return arrayCity[id]
    }
}
