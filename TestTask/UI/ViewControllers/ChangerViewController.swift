import UIKit
import TinyConstraints

class ChangerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var collectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()
    private var arrayCity = [City]()
    private var count = 0
    private var selectedString = ""
    private let def = Defaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedString = def.getTransition()
        arrayCity = Parser().getCities()
        let lbl  = selectedString != "selectedCrypto" ? "Выбор города" : "Выбор криптовалюты"
        title = lbl
        if lbl == "Выбор города" {
            initUICollectionView()
        } else {
            let child = CryptoCollectionView()
            addChild(child)
            view.addSubview(child.view)
            child.view.edgesToSuperview()
        }
    }
    
    private func initUICollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICityCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.appGrey
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        if count >= arrayCity.count{
            return cell
        }
        cell.backgroundColor = .white
        let lableCode = UILabel(frame: cell.contentView.bounds)
        lableCode.textColor = .black
        lableCode.font = UIFont.systemFont(ofSize: 22)
        lableCode.text = arrayCity[count].code
        cell.addSubview(lableCode)
        lableCode.leftToSuperview(offset: 15)
        lableCode.centerYToSuperview()
        let lableCity = UILabel(frame: cell.contentView.bounds)
        lableCity.textColor = .black
        lableCity.font = UIFont.systemFont(ofSize: 18)
        lableCity.text = arrayCity[count].name
        cell.contentView.addSubview(lableCity)
        lableCity.leftToRight(of: lableCode, offset: 15)
        lableCity.centerYToSuperview()
        count += 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        def.setCity(city: arrayCity[indexPath.item], key: selectedString)
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей валюте. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }
}
