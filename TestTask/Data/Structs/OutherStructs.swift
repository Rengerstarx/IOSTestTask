//
//  OutherStructs.swift
//  TestTask
//
//  Created by sergey on 11/21/23.
//

import Foundation
import UIKit

struct PaternView {
    let view = UIView()
    let lable = UILabel()
    let image = UIImageView()
    let buttonSet = UIButton()
    let button = UIButton(type: .roundedRect)
    let name: String
    let imageS: String
}

struct ViewTop {
    let view = UIView()
    let button = UIButton()
    let lable = UILabel()
}

struct Color {
    let mainBlue = UIColor(named: "mainBlue")
    let backGrey = UIColor(named: "mainBackGrey")
}
