class CryptoDataProvider {
    
    weak var delegate: SetupDelegate?
    private var isActive = false
    private var coins: [Crypto] = []
    private let def = Defaults()
    
    func initData() {
        takeCoins()
        checkActive()
    }
    
    private func takeCoins() {
        coins = def.getCoins()
    }
    
    private func checkActive() {
        let ids = coins.compactMap{$0.id}.joined(separator: ",")
        if ids != "" {
            Parser().getOneCoin(id: ids) { resultCrypto, resultError in
                if let result = resultCrypto {
                    self.isActive = true
                    self.coins = result
                } else {
                    self.isActive = false
                }
                self.delegate?.setupData(widgetType: .crypto)
            }
        } else {
            self.isActive = false
            self.delegate?.setupData(widgetType: .crypto)
        }
    }
    
    func update(newCoins coins: [Crypto]) {
        if !(self.coins == coins) {
            self.coins = coins
            def.setCoins(coins)
            checkActive()
        }
    }
    
    func getActive() -> Bool {
        return isActive
    }
    
    func getCoins() -> [Crypto] {
        return coins
    }
}
