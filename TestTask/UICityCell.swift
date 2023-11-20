//
//  UICityCell.swift
//  TestTask
//
//  Created by sergey on 11/14/23.
//

import UIKit
import TinyConstraints

class UICityCell: UICollectionViewCell {
    
    let lableCity: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.textAlignment = .center
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lableCity)
        lableCity.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
