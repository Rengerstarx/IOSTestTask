//
//  CryptoCollectionView.swift
//  TestTask
//
//  Created by sergey on 11/18/23.
//

import UIKit
import TinyConstraints
import SDWebImage

struct Coin: Codable{
    var name: String
    var id: String
    var uiCode: Int
}

class CryptoCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //Array
    private var countAr = 0
    private var stCoin1: Coin? = nil
    private var sw1: UISwitch = UISwitch()
    private var sw2: UISwitch = UISwitch()
    private var sw3: UISwitch = UISwitch()
    private var stCoin2: Coin? = nil
    private var stCoin3: Coin? = nil
    
    //UICollectionView
    private var collectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()
    
    private var arrayCrypto = [Crypto]()
    private var isParsecrypto = 404
    private var cnt = 0
    
    private let subLable = UILabel()
    private let subView = UIView()
    
    let defaults = UserDefaults()
    let defaultsString = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mainBackGrey")
        initSubTopView()
        
        if let savedData = defaults.object(forKey: "selectedCoins") as? Data {
            let decoder = JSONDecoder()
            if let savedCoins = try? decoder.decode([Coin?].self, from: savedData) {
                stCoin1 = savedCoins[0]
                stCoin2 = savedCoins[1]
                stCoin3 = savedCoins[2]
            }
            printLable()
        }
        
        ParsCities().parsCrypto(){ result in
            if let crypto = result as? [Crypto] {
                self.arrayCrypto = crypto
                self.isParsecrypto = 200
                self.initUICollectionView()
            } else if let error = result as? String {
                self.isParsecrypto = 404
            }
        }
    }
    
    private func initSubTopView(){
        view.addSubview(subLable)
        subLable.numberOfLines = 10
        subLable.text = "Выбраная валюта -"
        subLable.font = UIFont.systemFont(ofSize: 20)
        subLable.textColor = .black
        subLable.topToSuperview(offset: 5)
        subLable.leftToSuperview(offset: 5)
        subLable.rightToSuperview(offset: -5)
    }
    
    private func initUICollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICityCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "mainBackGrey")
        view.addSubview(collectionView)
        collectionView.topToBottom(of: subLable)
        collectionView.leftToSuperview()
        collectionView.rightToSuperview()
        collectionView.bottomToSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCrypto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundColor = .white
        
        if cnt < arrayCrypto.count{
            let image = UIImageView()
            image.sd_setImage(with: URL(string: arrayCrypto[cnt].image))
            cell.addSubview(image)
            image.leftToSuperview(offset: 5)
            image.topToSuperview(offset: 5)
            image.bottomToSuperview(offset: -5)
            image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
            image.contentMode = .scaleAspectFit
            
            let lable = UILabel()
            lable.text = arrayCrypto[cnt].name
            lable.textColor = .black
            lable.font = UIFont.systemFont(ofSize: 18)
            cell.addSubview(lable)
            lable.topToSuperview(offset: 5)
            lable.bottomToSuperview(offset: -5)
            
            
            let check = UISwitch()
            check.isEnabled = false
            cell.addSubview(check)
            check.rightToSuperview(offset: -5)
            check.topToSuperview(offset: 5)
            check.bottomToSuperview(offset: -5)
            
            lable.leftToRight(of: image, offset: 10)
            lable.rightToLeft(of: check, offset: -10)
            
            switch lable.text {
            case stCoin1?.name:
                check.isOn = true
                stCoin1?.uiCode = indexPath.item
                sw1 = check
            case stCoin2?.name:
                check.isOn = true
                sw2 = check
                stCoin2?.uiCode = indexPath.item
            case stCoin3?.name:
                check.isOn = true
                sw3 = check
                stCoin3?.uiCode = indexPath.item
            case .none:
                let y = 1
            case .some(_):
                let y = 1
            }
        }
        cnt += 1
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) as? UICityCell else {
            return
        }
        if let MySwitch = cell.subviews.first(where: {$0 is UISwitch}) as? UISwitch {
            let stc = Coin(name: arrayCrypto[indexPath.item].name, id: arrayCrypto[indexPath.item].id, uiCode: indexPath.item)
            
            if MySwitch.isOn == true {
                if indexPath.item == stCoin1?.uiCode {
                    sw1.isOn = false
                    stCoin1 = nil
                }
                else if indexPath.item == stCoin2?.uiCode {
                    sw2.isOn = false
                    stCoin2 = nil
                }
                else {
                    sw3.isOn = false
                    stCoin3 = nil
                }
            }
            else{
                if stCoin1 == nil {
                    MySwitch.isOn = true
                    sw1 = MySwitch
                    stCoin1 = stc
                }
                else if stCoin2 == nil {
                    MySwitch.isOn = true
                    sw2 = MySwitch
                    stCoin2 = stc
                }
                else if stCoin3 == nil {
                    MySwitch.isOn = true
                    sw3 = MySwitch
                    stCoin3 = stc
                }
                else {
                    sw3.isOn = false
                    MySwitch.isOn = true
                    sw3 = MySwitch
                    stCoin3 = stc
                }
            }
            
            printLable()
            
            let array = [stCoin1,stCoin2,stCoin3]
            
            if let encodedPerson = try? encoder.encode(array){
                defaults.set(encodedPerson, forKey: "selectedCoins")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func printLable(){
        let i1 = stCoin1 == nil ? "" : stCoin1!.name
        let i2 = stCoin2 == nil ? "" : stCoin2!.name
        let i3 = stCoin3 == nil ? "" : stCoin3!.name
        var highStr = "Выбраная валюта - \(i1) \(i2) \(i3)"
        subLable.text = highStr
    }
    
}

