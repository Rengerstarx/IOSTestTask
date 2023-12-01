import Foundation

class Defaults {
    let defaults = UserDefaults()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    // MARK: - Functions for loading values into UserDefaults
    func setCityMap(_ city: City) {
        do {
            let encodedCity = try encoder.encode(city)
            defaults.set(encodedCity, forKey: "selectedMapCity")
        } catch {
            print("Defaults.setCity(): Error by encoding city")
        }
    }
    
    func setCityWeather(_ city: City) {
        do {
            let encodedCity = try encoder.encode(city)
            defaults.set(encodedCity, forKey: "selectedWeatherCity")
        } catch {
            print("Defaults.setCity(): Error by encoding city")
        }
    }
    
    func setCoins(_ arrayCoins: [Crypto]) {
        do {
            let encodedCoins = try encoder.encode(arrayCoins)
            defaults.set(encodedCoins, forKey: "selectedCoins")
        } catch {
            print("Defaults.setCoins(): Error by encoding coins")
        }
    }
    
    // MARK: - Functions for unloading values from UserDefaults
    func getCityMap() -> City? {
        if let savedData = defaults.object(forKey: "selectedMapCity") as? Data {
            do {
                let savedCity = try decoder.decode(City?.self, from: savedData)
                return savedCity
            } catch {
                print("Defaults.getCity(): Error by decoding city")
            }
        }
        return nil
    }
    
    func getCityWeather() -> City? {
        if let savedData = defaults.object(forKey: "selectedWeatherCity") as? Data {
            do {
                let savedCity = try decoder.decode(City?.self, from: savedData)
                return savedCity
            } catch {
                print("Defaults.getCity(): Error by decoding city")
            }
        }
        return nil
    }
    
    func getCoins() -> [Crypto] {
        if let savedData = defaults.object(forKey: "selectedCoins") as? Data {
            do {
                let savedCoins = try decoder.decode([Crypto].self, from: savedData)
                return savedCoins
            } catch {
                print("Defaults.getCoins(): Error by decoding coins")
            }
        }
        return []
    }
   
    // MARK: - Remove function
    func removeCityMap() {
        defaults.removeObject(forKey: "selectedMapCity")
    }
    
    func removeCityWeather() {
        defaults.removeObject(forKey: "selectedWeatherCity")
    }
}
