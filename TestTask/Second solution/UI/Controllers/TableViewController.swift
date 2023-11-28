import UIKit
import TinyConstraints

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var data = TableCitiesData()
    var completionHandler: ((City?) -> Void)?
    var completionHandlerCrypto: (([Crypto?]) -> Void)?
    
    init(widgetType tag: WidgetType, _ city: City?, _ coins: [Crypto?]) {
        data.initer(widgetType: tag, currentCity: city, currentCrypto: coins)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !data.getIsCity() {
            completionHandlerCrypto?(data.getCurrentCrypto())
            super.viewWillDisappear(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUITableView()
        data.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.getIsCity() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell
            let city = data.getCityById(indexPath.item)
            cell?.codeLabel.text = city.code
            cell?.citynameLabel.text = city.name
            return cell ?? CityCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinCell
            let coin = data.getCryptoById(indexPath.item)
            cell?.imageC.sd_setImage(with: URL(string: coin.image))
            cell?.nameLabel.text = coin.name
            cell?.switcher.isOn = data.checkCoin(coin.name, cell?.switcher)
            return cell ?? CoinCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data.getIsCity() {
            completionHandler?(data.getCityById(indexPath.item) ?? data.getCurrentCity())
            navigationController?.popViewController(animated: true)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as? CoinCell
            if cell?.switcher.isOn ?? true {
                data.deleteCoin(data.getCryptoById(indexPath.item).name)
                cell?.switcher.isOn = false
            } else {
                let sw = data.setCoin(data.getCryptoById(indexPath.item), uiswitch: cell?.switcher)
                sw?.isOn = false
                cell?.switcher.isOn = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    private func initUITableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        if data.getIsCity() {
            tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        } else {
            tableView.register(CoinCell.self, forCellReuseIdentifier: "CoinCell")
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.appGrey
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
