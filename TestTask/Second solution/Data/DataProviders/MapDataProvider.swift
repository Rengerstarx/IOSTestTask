class MapDataProvider {
    
    weak var delegate: SetupDelegate?
    private var state: WidgetState = .nilError
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
        state = city != nil ? .correct : .connectError
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
    
    func getState() -> WidgetState {
        return state
    }
    
    func getCity() -> City? {
        return city
    }
}
