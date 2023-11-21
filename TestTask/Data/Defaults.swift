//
//  Defaults.swift
//  TestTask
//
//  Created by sergey on 11/21/23.
//

import Foundation

class Defaults{
    let defaults = UserDefaults()
    let defaultsString = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    // MARK: - Functions for loading values into UserDefaults
    func setTransition(target target: String){
        defaultsString.set(target, forKey: "Selected")
    }

    func setCity(city city: City, key key: String){
        if let encodedCity = try? encoder.encode(city) {
            defaults.set(encodedCity, forKey: key)
        } else {
            print("Defaults.setCity(): Error by encoding city")
        }
    }

    func setCoins(coins arrayCoins: [Coin?], key key: String){
        if let encodedCoins = try? encoder.encode(arrayCoins) {
            defaults.set(encodedCoins, forKey: key)
        } else {
            print("Defaults.setCoins(): Error by encoding coins")
        }
    }

    // MARK: - Functions for unloading values from UserDefaults
    func getTransition() -> String {
        return defaultsString.string(forKey: "Selected") ?? ""
    }

    func getCity(_ key: String) -> City?{
        if let savedData = defaults.object(forKey: key) as? Data {
            if let savedCity = try? decoder.decode(City.self, from: savedData) {
                return savedCity
            } else {
                print("Defaults.getCity(): Error by decoding city")
            }
        }
        return nil
    }

    func getCoins(_ key: String) -> [Coin?]{
        if let savedData = defaults.object(forKey: key) as? Data {
            if let savedCoins = try? decoder.decode([Coin?].self, from: savedData) {
                return savedCoins
            } else {
                print("Defaults.getCoins(): Error by decoding coins")
            }
        }
        return [nil, nil, nil]
    }
}
