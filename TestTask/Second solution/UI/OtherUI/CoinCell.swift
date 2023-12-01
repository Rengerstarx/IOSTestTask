import UIKit
import TinyConstraints

class CoinCell: UITableViewCell {
    
    let image = UIImageView()
    let name = UILabel()
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
        contentView.addSubview(image)
        image.leftToSuperview(offset: 5)
        image.topToSuperview(offset: 5)
        image.bottomToSuperview(offset: -5)
        contentView.addSubview(name)
        name.topToSuperview(offset: 5)
        name.bottomToSuperview(offset: -5)
        contentView.addSubview(switcher)
        switcher.rightToSuperview(offset: -5)
        switcher.topToSuperview(offset: 5)
        switcher.bottomToSuperview(offset: -5)
        name.leftToRight(of: image, offset: 10)
        name.rightToLeft(of: switcher, offset: -10)
    }
    
    private func setupView() {
        image.aspectRatio(1)
        image.contentMode = .scaleAspectFit
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
}
