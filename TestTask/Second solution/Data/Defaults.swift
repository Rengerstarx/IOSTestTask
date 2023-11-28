import Foundation

class Defaults {
    let defaults = UserDefaults()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    // MARK: - Functions for loading values into UserDefaults
    func setCityMap(_ city: City) {
        if let encodedCity = try? encoder.encode(city) {
            defaults.set(encodedCity, forKey: "selectedMapCity")
        } else {
            print("Defaults.setCity(): Error by encoding city")
        }
    }
    
    func setCityWeather(_ city: City) {
        if let encodedCity = try? encoder.encode(city) {
            defaults.set(encodedCity, forKey: "selectedWeatherCity")
        } else {
            print("Defaults.setCity(): Error by encoding city")
        }
    }
    
    func setCoins(_ arrayCoins: [Crypto]) {
        if let encodedCoins = try? encoder.encode(arrayCoins) {
            defaults.set(encodedCoins, forKey: "selectedCoins")
        } else {
            print("Defaults.setCoins(): Error by encoding coins")
        }
    }
    
    // MARK: - Functions for unloading values from UserDefaults
    func getCityMap() -> City? {
        if let savedData = defaults.object(forKey: "selectedMapCity") as? Data {
            if let savedCity = try? decoder.decode(City?.self, from: savedData) {
                return savedCity
            } else {
                print("Defaults.getCity(): Error by decoding city")
            }
        }
        return nil
    }
    
    func getCityWeather() -> City? {
        if let savedData = defaults.object(forKey: "selectedWeatherCity") as? Data {
            if let savedCity = try? decoder.decode(City?.self, from: savedData) {
                return savedCity
            } else {
                print("Defaults.getCity(): Error by decoding city")
            }
        }
        return nil
    }
    
    func getCoins() -> [Crypto] {
        if let savedData = defaults.object(forKey: "selectedCoins") as? Data {
            if let savedCoins = try? decoder.decode([Crypto].self, from: savedData) {
                return savedCoins
            } else {
                print("Defaults.getCoins(): Error by decoding coins")
            }
        }
        return []
    }
    
    func removeCityMap() {
        defaults.removeObject(forKey: "selectedMapCity")
    }
    
    func removeCityWeather() {
        defaults.removeObject(forKey: "selectedWeatherCity")
    }
}
