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
        delegate?.setupData(tag: 1)
    }
    
    func update(selectedCity city: City?) {
        if self.city?.name != city?.name {
            self.city = city
            def.setCityMap(city)
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