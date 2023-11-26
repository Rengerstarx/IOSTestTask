class CryptoDataProvider {
    
    weak var delegate: SetupDelegate?
    private var isActive = false
    private var coins: [Crypto?] = [nil, nil, nil]
    private let def = Defaults()
    
    func initData() {
        takeCoins()
        checkActive()
    }
    
    private func takeCoins() {
        coins = def.getCoins()
    }
    
    private func checkActive() {
        var noNils = ""
        for i in coins {
            if i != nil {
                noNils += ",\(i!.id)"
            }
        }
        Parser().getOneCoin(id: noNils) { resultCrypto, resultError in
            if resultCrypto != nil {
                self.isActive = true
                self.coins = resultCrypto!
            } else {
                self.isActive = false
            }
            self.delegate?.setupData(tag: 3)
        }
    }
    
    func update(newCoins coins: [Crypto?]) {
        if !(self.coins == coins) {
            self.coins = coins
            def.setCoins(coins)
            checkActive()
        }
    }
    
    func getActive() -> Bool {
        return isActive
    }
    
    func getCoins() -> [Crypto?] {
        return coins
    }
}
