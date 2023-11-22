import UIKit
import TinyConstraints
import SDWebImage

struct Coin: Codable{
    var name: String
    var id: String
    var uiCode: Int
}

class CryptoCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private var switchForCoin1: UISwitch = UISwitch()
    private var switchForCoin2: UISwitch = UISwitch()
    private var switchForCoin3: UISwitch = UISwitch()
    private var selectedCoin1: Coin? = nil
    private var selectedCoin2: Coin? = nil
    private var selectedCoin3: Coin? = nil
    private var collectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()
    private var arrayCrypto = [Crypto]()
    private var count = 0
    private let subLable = UILabel()
    private let subView = UIView()
    private let def = Defaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appGrey
        initSubTopView()
        let savedCoins = def.getCoins("selectedCoins")
        selectedCoin1 = savedCoins[0]
        selectedCoin2 = savedCoins[1]
        selectedCoin3 = savedCoins[2]
        printLable()
        Parser().getAllCoins(){ resultCrypto, resutltError in
            if resultCrypto != nil {
                self.arrayCrypto = resultCrypto!
                self.initUICollectionView()
            }
        }
    }
    
    private func initSubTopView() {
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
        
        if count < arrayCrypto.count {
            let image = UIImageView()
            image.sd_setImage(with: URL(string: arrayCrypto[count].image))
            cell.addSubview(image)
            image.leftToSuperview(offset: 5)
            image.topToSuperview(offset: 5)
            image.bottomToSuperview(offset: -5)
            image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
            image.contentMode = .scaleAspectFit
            let lable = UILabel()
            lable.text = arrayCrypto[count].name
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
            case selectedCoin1?.name:
                check.isOn = true
                selectedCoin1?.uiCode = indexPath.item
                switchForCoin1 = check
            case selectedCoin2?.name:
                check.isOn = true
                switchForCoin2 = check
                selectedCoin2?.uiCode = indexPath.item
            case selectedCoin3?.name:
                check.isOn = true
                switchForCoin3 = check
                selectedCoin3?.uiCode = indexPath.item
            case .none:
                _ = 1
            case .some(_):
                _ = 1
            }
        }
        count += 1
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? UICityCell else {
            return
        }
        if let MySwitch = cell.subviews.first(where: {$0 is UISwitch}) as? UISwitch {
            let stc = Coin(name: arrayCrypto[indexPath.item].name, id: arrayCrypto[indexPath.item].id, uiCode: indexPath.item)
            if MySwitch.isOn == true {
                if indexPath.item == selectedCoin1?.uiCode {
                    switchForCoin1.isOn = false
                    selectedCoin1 = nil
                } else if indexPath.item == selectedCoin2?.uiCode {
                    switchForCoin2.isOn = false
                    selectedCoin2 = nil
                } else {
                    switchForCoin3.isOn = false
                    selectedCoin3 = nil
                }
            } else{
                if selectedCoin1 == nil {
                    MySwitch.isOn = true
                    switchForCoin1 = MySwitch
                    selectedCoin1 = stc
                } else if selectedCoin2 == nil {
                    MySwitch.isOn = true
                    switchForCoin2 = MySwitch
                    selectedCoin2 = stc
                } else if selectedCoin3 == nil {
                    MySwitch.isOn = true
                    switchForCoin3 = MySwitch
                    selectedCoin3 = stc
                } else {
                    switchForCoin3.isOn = false
                    MySwitch.isOn = true
                    switchForCoin3 = MySwitch
                    selectedCoin3 = stc
                }
            }
            printLable()
            let array = [selectedCoin1,selectedCoin2,selectedCoin3]
            def.setCoins(coins: array, key: "selectedCoins")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func printLable() {
        let i1 = selectedCoin1 == nil ? "" : selectedCoin1!.name
        let i2 = selectedCoin2 == nil ? "" : selectedCoin2!.name
        let i3 = selectedCoin3 == nil ? "" : selectedCoin3!.name
        let highStr = "Выбраная валюта - \(i1) \(i2) \(i3)"
        subLable.text = highStr
    }
}
