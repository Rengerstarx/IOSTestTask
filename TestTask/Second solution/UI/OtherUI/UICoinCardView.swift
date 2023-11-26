import UIKit
import TinyConstraints
import SDWebImage

class UICoinCardView: UIView {
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let prevPriceLabel = UILabel()
    private let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        nameLabel.leftToSuperview(offset: 5)
        nameLabel.rightToSuperview(offset: -5)
        nameLabel.topToSuperview(offset: 7)
        addSubview(prevPriceLabel)
        prevPriceLabel.leftToSuperview(offset: 5)
        prevPriceLabel.rightToSuperview(offset: -5)
        prevPriceLabel.bottomToSuperview(offset: -7)
        addSubview(priceLabel)
        priceLabel.leftToSuperview(offset: 5)
        priceLabel.rightToSuperview(offset: -5)
        priceLabel.bottomToTop(of: prevPriceLabel, offset: -7)
        addSubview(image)
        image.topToBottom(of: nameLabel, offset: 5)
        image.bottomToTop(of: priceLabel, offset: -5)
        image.leftToSuperview(offset: 5)
        image.rightToSuperview(offset: -5)
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.numberOfLines = 3
        nameLabel.textAlignment = .center
        prevPriceLabel.font = UIFont.systemFont(ofSize: 12)
        prevPriceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .black
        image.contentMode = .scaleAspectFit
    }
    
    func setup(coin cn: Crypto?) {
        nameLabel.text = cn?.name ?? "Error"
        prevPriceLabel.text = cn?.priceChangePercentage1HInCurrency.formatValue ?? "0.0"
        if cn?.priceChangePercentage1HInCurrency ?? 0 < 0 {
            prevPriceLabel.textColor = .red
        } else {
            prevPriceLabel.textColor = .green
        }
        priceLabel.text = cn?.currentPrice.formatValue ?? "0.0"
        image.sd_setImage(with: URL(string: cn?.image ?? ""))
    }
}
