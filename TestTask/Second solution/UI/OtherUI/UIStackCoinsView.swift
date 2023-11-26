import UIKit

class UIStackCoinsView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
        backgroundColor = UIColor.appGrey
    }
    
    func deleteAll() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    func addCoin(_ coin: Crypto?) {
        let coinCard = UICoinCardView()
        coinCard.setup(coin: coin)
        addArrangedSubview(coinCard)
    }
    
    func addCoins(_ coins: [Crypto?]) {
        for coin in coins {
            addCoin(coin)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
