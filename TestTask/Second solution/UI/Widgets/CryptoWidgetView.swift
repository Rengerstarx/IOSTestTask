import UIKit
import SDWebImage
import TinyConstraints

class CryptoWidgetView: BaseWidgetView {
    private let additionalView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStart(nameOfView: "Crypto", imageOfView: "cryptoBack")
        setupLayout()
        setupView()
    }
    
    override func setupStart(nameOfView name: String, imageOfView image: String) {
        super.setupStart(nameOfView: name, imageOfView: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        super.containerView.addSubview(additionalView)
        additionalView.edgesToSuperview()
    }
    
    override func setupView() {
        super.setupView()
        additionalView.axis = .horizontal
        additionalView.distribution = .fillEqually
        additionalView.spacing = 10
    }
    
    func setup(_ coins: [Crypto]) {
        deleteAll()
        for coin in coins {
            let coinCard = UICoinCardView()
            coinCard.setup(coin: coin)
            additionalView.addArrangedSubview(coinCard)
        }
    }
    
    private func deleteAll() {
        for view in additionalView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
