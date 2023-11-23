import Foundation
import UIKit

// MARK: - Patern view for Main Screen
struct PaternView {
    let view = UIView()
    let lable = UILabel()
    let image = UIImageView()
    let buttonSet = UIButton()
    let button = UIButton(type: .roundedRect)
    let name: String
    let imageS: String
}

// MARK: - UIColor extension
extension UIColor {
    static let appBlue = UIColor(named: "mainBlue")
    static let appGrey = UIColor(named: "mainBackGrey")
}

struct Coin: Codable{
    var name: String
    var id: String
    var uiCode: Int
}
