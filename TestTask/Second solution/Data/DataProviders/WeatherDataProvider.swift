class WeatherDataProvider {
    
    weak var delegate: SetupDelegate?
    private var isActive = false
    private var city: City?
    private var weather: Weather?
    private let def = Defaults()
    
    func initData() {
        takeCity()
        checkActive()
    }
    
    private func takeCity() {
        city = def.getCityWeather()
    }
    
    private func checkActive() {
        Parser().getWeather(lati: city?.latitude, long: city?.longitude) { resultWeather, resultError in
            if resultWeather != nil {
                self.weather = resultWeather!
                self.isActive = true
            } else {
                self.isActive = false
            }
            self.delegate?.setupData(tag: 2)
        }
    }
    
    func update(selectedCity city: City?) {
        if self.city?.name != city?.name {
            self.city = city
            def.setCityWeather(city)
            checkActive()
        }
    }
    
    func getActive() -> Bool {
        return isActive
    }
    
    func getCity() -> City? {
        return city
    }
    
    func getWeather() -> Weather {
        return weather!
    }
    
    func getType() -> (String,String) {
        let url = "https://psv4.userapi.com/c909518/u390619751/docs/d24/e0f3dcbe37ba/cloudy.png?extra=4dpxERoZA2aHQQiagjIGsZB6HOzac0OSsUwvYXPTUkPAPyrx4s7ITGCfOWm-NDu5GDWodbgU4wTaOmZks3TKvojY-qrIlnULSvgJfme1VTE9AWxVuKWehqzS7oPIgH6lR7OV6ZM03vFfTNGyrZU3HkoB"
        if weather!.snow?.the1H != nil {
            return ("Идет снежок", url)
        } else if weather!.rain?.the1H != nil {
            return ("Идет дождик", url)
        } else if weather!.wind.speed > 8.0 {
            return ("Сильный ветерок", url)
        } else if weather!.clouds.all > 80 {
            return ("На небе много облачков", url)
        } else {
            return ("Погода просто супер!", url)
        }
    }
}
