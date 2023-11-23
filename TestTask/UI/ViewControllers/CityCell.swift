import UIKit
import TinyConstraints

class CityCell: UITableViewCell {
    
    let codeLabel = UILabel()
    let citynameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        codeLabel.textColor = .black
        codeLabel.font = UIFont.systemFont(ofSize: 22)
        contentView.addSubview(codeLabel)
        codeLabel.leftToSuperview(offset: 15)
        codeLabel.centerYToSuperview()
        citynameLabel.textColor = .black
        citynameLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(citynameLabel)
        citynameLabel.leftToRight(of: codeLabel, offset: 15)
        citynameLabel.centerYToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
}
