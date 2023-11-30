import UIKit
import TinyConstraints

class CoinCell: UITableViewCell {
    
    let imageC = UIImageView()
    let nameLabel = UILabel()
    let switcher = UISwitch()
    var onSwitcherStateUpdate: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupView()
    }
    
    func configure(with coin: Crypto) {
        switcher.addTarget(self, action: #selector(switcherStateChange), for: .valueChanged)
    }
    
    @objc private func switcherStateChange(_ sender: UISwitch) {
        onSwitcherStateUpdate?(sender.isOn)
    }
    
    private func setupLayout() {
        contentView.addSubview(imageC)
        imageC.leftToSuperview(offset: 5)
        imageC.topToSuperview(offset: 5)
        imageC.bottomToSuperview(offset: -5)
        contentView.addSubview(nameLabel)
        nameLabel.topToSuperview(offset: 5)
        nameLabel.bottomToSuperview(offset: -5)
        contentView.addSubview(switcher)
        switcher.rightToSuperview(offset: -5)
        switcher.topToSuperview(offset: 5)
        switcher.bottomToSuperview(offset: -5)
        nameLabel.leftToRight(of: imageC, offset: 10)
        nameLabel.rightToLeft(of: switcher, offset: -10)
    }
    
    private func setupView() {
        imageC.aspectRatio(1)
        imageC.contentMode = .scaleAspectFit
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
}
