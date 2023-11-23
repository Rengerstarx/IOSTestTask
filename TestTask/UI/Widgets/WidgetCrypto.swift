import UIKit
import SDWebImage
import TinyConstraints

class WidgetCrypto {

    private let def = Defaults()
    private let name = "selectedCoins"
    private var isActive = false
    private var coinsArray = [Coin?]()
    private var arrayParseCoins = [Crypto]()
    private var stackCoins = UIStackView()
    private let backView = UIView()
    private let loaderCrypto = UIActivityIndicatorView(style: .gray)
    private let tryButton = UIButton()
    var noNils = ""

    init() {
        setBackground()
        initWidget()
        checkCrypto()
        if isActive {
            startWork()
        }
    }
    
    func update() {
        stackCoins.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        checkCrypto()
        startWork()
    }
    
    func getView() -> UIView{
        return backView
    }

    func getActive() -> Bool {
        return isActive
    }

    private func checkCrypto() {
        let savedCoins = def.getCoins(name)
        if savedCoins[0] == nil && savedCoins[1] == nil && savedCoins[2] == nil {
            isActive = false
        } else {
            coinsArray = savedCoins
            isActive = true
        }
    }

    private func setBackground() {
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 20
    }
    
    @objc private func startWork() {
        backView.addSubview(loaderCrypto)
        loaderCrypto.startAnimating()
        loaderCrypto.centerInSuperview()
        for i in coinsArray {
            if i != nil {
                noNils += ",\(i!.id)"
            }
        }
        Parser().getOneCoin(id: noNils) { resultCrypto, resultError in
            self.loaderCrypto.removeFromSuperview()
            self.tryButton.removeFromSuperview()
            if resultCrypto != nil {
                self.arrayParseCoins = resultCrypto!
                self.fillStack()
            } else {
                self.alerting()
            }
        }
    }
    
    private func initWidget() {
        backView.addSubview(stackCoins)
        stackCoins.axis = .horizontal
        stackCoins.distribution = .fillEqually
        stackCoins.spacing = 10
        stackCoins.backgroundColor = UIColor.appGrey
        stackCoins.topToSuperview(offset: 15)
        stackCoins.bottomToSuperview(offset: -15)
        stackCoins.leftToSuperview(offset: 15)
        stackCoins.rightToSuperview(offset: -15)
    }

    private func fillStack() {
        var cnt = 0
        for coin in arrayParseCoins {
            cnt += 1
            stackCoins.addArrangedSubview(initOneCoin(coin: coin))
        }
    }
    
    private func initOneCoin(coin cn : Crypto) -> UIView {
        let miniCoin = UIView()
        miniCoin.layer.cornerRadius = 20
        miniCoin.backgroundColor = .white
        let labletp = UILabel()
        labletp.text = cn.name
        labletp.font = UIFont.boldSystemFont(ofSize: 14)
        labletp.numberOfLines = 3
        miniCoin.addSubview(labletp)
        labletp.textAlignment = .center
        labletp.leftToSuperview(offset: 5)
        labletp.rightToSuperview(offset: -5)
        labletp.topToSuperview(offset: 7)
        let lableChange = UILabel()
        lableChange.font = UIFont.systemFont(ofSize: 12)
        lableChange.textAlignment = .center
        lableChange.text = String(format: "%.3f", cn.priceChangePercentage1HInCurrency)
        if cn.priceChangePercentage1HInCurrency < 0 {
            lableChange.textColor = .red
        } else {
            lableChange.textColor = .green
        }
        miniCoin.addSubview(lableChange)
        lableChange.leftToSuperview(offset: 5)
        lableChange.rightToSuperview(offset: -5)
        lableChange.bottomToSuperview(offset: -7)
        let lablePrice = UILabel()
        lablePrice.font = UIFont.systemFont(ofSize: 12)
        lablePrice.textAlignment = .center
        lablePrice.textColor = .black
        lablePrice.text = String(format: "%.3f", cn.currentPrice) + "$"
        miniCoin.addSubview(lablePrice)
        lablePrice.leftToSuperview(offset: 5)
        lablePrice.rightToSuperview(offset: -5)
        lablePrice.bottomToTop(of: lableChange, offset: -7)
        let image = UIImageView()
        image.sd_setImage(with: URL(string: cn.image))
        miniCoin.addSubview(image)
        image.topToBottom(of: labletp, offset: 5)
        image.bottomToTop(of: lablePrice, offset: -5)
        image.leftToSuperview(offset: 5)
        image.rightToSuperview(offset: -5)
        image.contentMode = .scaleAspectFit
        return miniCoin
    }

    private func tryAgain() {
        backView.addSubview(tryButton)
        tryButton.backgroundColor = UIColor.appBlue
        tryButton.layer.cornerRadius = 10
        tryButton.setTitleColor(.white, for: .normal)
        tryButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        tryButton.setTitle("Повторить", for: .normal)
        tryButton.centerXToSuperview()
        tryButton.bottomToSuperview(offset: -30)
        tryButton.addTarget(self, action: #selector(startWork), for: .touchUpInside)
    }
    
    private func alerting() {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей валюте. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }
}
