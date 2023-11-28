class MapDataProvider {
    
    weak var delegate: SetupDelegate?
    private var isActive = false
    private var city: City?
    private let def = Defaults()
    
    func initData() {
        takeCity()
        checkActive()
    }
    
    private func takeCity() {
        city = def.getCityMap()
    }
    
    private func checkActive() {
        if city != nil {
            isActive = true
        } else {
            isActive = false
        }
        delegate?.setupData(widgetType: .map)
    }
    
    func update(selectedCity city: City?) {
        if self.city?.name != city?.name {
            self.city = city
            if let cityC = city {
                def.setCityMap(cityC)
            } else {
                def.removeCityMap()
            }
            checkActive()
        }
    }
    
    func getActive() -> Bool {
        return isActive
    }
    
    func getCity() -> City? {
        return city
    }
}
