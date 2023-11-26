import UIKit
import SDWebImage
import TinyConstraints

class CryptoWidgetView: BaseWidgetView {
    private let additionalView = UIStackCoinsView()
    
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
        additionalView.translatesAutoresizingMaskIntoConstraints = false
        additionalView.edgesToSuperview()
    }
    
    override func setupView() {
        super.setupView()
    }
    
    override func switcher(_ marker: Bool) {
        super.switcher(marker)
    }
    
    func setup(_ coins: [Crypto?]) {
        additionalView.deleteAll()
        additionalView.addCoins(coins)
    }
}
