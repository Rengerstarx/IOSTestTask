class CryptoDataProvider {
    
    weak var delegate: SetupDelegate?
    private var state: WidgetState = .nilError
    private var coins: [Crypto] = []
    private let def = Defaults()
    
    func initData() {
        delegate?.setLoader(widgetType: .crypto)
        takeCoins()
        checkActive()
    }
    
    private func takeCoins() {
        coins = def.getCoins()
    }
    
    private func checkActive() {
        let ids = coins.compactMap{$0.id}.joined(separator: ",")
        if ids.isEmpty {
            state =  .nilError
            delegate?.setupData(widgetType: .crypto)
        } else {
            Parser.getOneCoin(id: ids) { resultCrypto, resultError in
                if let result = resultCrypto {
                    self.state = .correct
                    self.coins = result
                } else {
                    self.state = .connectError
                }
                self.delegate?.setupData(widgetType: .crypto)
            }
        }
    }
    
    func update(newCoins coins: [Crypto]) {
        if !(self.coins == coins) {
            self.coins = coins
            def.setCoins(coins)
            checkActive()
        }
    }
    
    func getState() -> WidgetState {
        return state
    }
    
    func getCoins() -> [Crypto] {
        return coins
    }
    
    func tryAgain() {
        checkActive()
    }
}
