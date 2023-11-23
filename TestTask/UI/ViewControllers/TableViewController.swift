import UIKit
import TinyConstraints

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var arrayCity = [City]()
    private var arrayCrypto = [Crypto]()
    private var marker = false
    private var data: TableViewControllerData?
    var completionHandler: ((String) -> Void)?
    
    init(typeOfTable value: String) {
        print(value)
        super.init(nibName: nil, bundle: nil)
        data = TableViewControllerData(typeOfTableView: value)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completionHandler?(data?.takeControllerType() ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marker = data?.getMarker() ?? false
        title = !marker ? "Выбор города" : "Выбор валюты"
        if marker {
            data?.downloadCoins() { resultCoins, resultError in
                if resultCoins != nil {
                    self.arrayCrypto = resultCoins!
                } else {
                    self.alert()
                }
                self.initUITableView()
            }
        } else {
            arrayCity = data?.getCities() ?? []
            initUITableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marker ? arrayCrypto.count : arrayCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !marker {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell
            cell?.codeLabel.text = arrayCity[indexPath.item].code
            cell?.citynameLabel.text = arrayCity[indexPath.item].name
            return cell ?? CityCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinCell
            cell?.image.sd_setImage(with: URL(string: arrayCrypto[indexPath.item].image))
            cell?.nameLabel.text = arrayCrypto[indexPath.item].name
            cell?.switcher.isOn = data?.checkCoin(arrayCrypto[indexPath.item].name, indexPath.item) ?? false
            return cell ?? CoinCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if marker {
            let stc = Coin(name: arrayCrypto[indexPath.item].name, id: arrayCrypto[indexPath.item].id, uiCode: indexPath.item)
            let cell = tableView.cellForRow(at: indexPath) as? CoinCell
            if cell?.switcher.isOn ?? true {
                data?.deleteCoin(indexPath.item)
                cell?.switcher.isOn = false
            } else {
                let nmb = data?.addCoin(indexPath.item, stc)
                if nmb != indexPath.item {
                    (tableView.cellForRow(at: IndexPath(row: nmb!, section: 0)) as? CoinCell)?.switcher.isOn = false
                }
                cell?.switcher.isOn = true
            }
        } else {
            data?.unloadCities(arrayCity[indexPath.item])
            completionHandler?(data?.takeControllerType() ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    private func initUITableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        if marker {
            tableView.register(CoinCell.self, forCellReuseIdentifier: "CoinCell")
        } else {
            tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell") 
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.appGrey
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
