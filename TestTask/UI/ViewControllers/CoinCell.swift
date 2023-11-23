import UIKit
import TinyConstraints

class CoinCell: UITableViewCell {
    
    let image = UIImageView()
    let nameLabel = UILabel()
    let switcher = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)
        image.leftToSuperview(offset: 5)
        image.topToSuperview(offset: 5)
        image.bottomToSuperview(offset: -5)
        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
        image.contentMode = .scaleAspectFit
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(nameLabel)
        nameLabel.topToSuperview(offset: 5)
        nameLabel.bottomToSuperview(offset: -5)
        switcher.isEnabled = false
        switcher.isOn = false
        contentView.addSubview(switcher)
        switcher.rightToSuperview(offset: -5)
        switcher.topToSuperview(offset: 5)
        switcher.bottomToSuperview(offset: -5)
        nameLabel.leftToRight(of: image, offset: 10)
        nameLabel.rightToLeft(of: switcher, offset: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
}
