import UIKit
import TinyConstraints

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let data: TableDataProvider
    var completionHandler: ((City?) -> Void)?
    var completionHandlerCrypto: (([Crypto]) -> Void)?
    private let tag: WidgetType
    private let reuseIdentifireCoin = "CoinCell"
    private let reuseIdentifireCity = "CityCell"
    
    init(widgetType tag: WidgetType) {
        self.tag = tag
        data = TableDataProvider(widgetType: tag)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if tag == .crypto {
            completionHandlerCrypto?(data.getSelectedCrypto())
            super.viewWillDisappear(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUITableView()
        data.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        data.updateCellView = { [weak self] index in
            let path = IndexPath(row: index, section: 0)
            self?.tableView.reloadRows(at: [path], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getArrayCount()
    }	
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tag != .crypto {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifireCity, for: indexPath) as? CityCell
            let city = data.getCityById(indexPath.item)
            cell?.codeLabel.text = city.code
            cell?.citynameLabel.text = city.name
            return cell ?? CityCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifireCoin, for: indexPath) as? CoinCell
            let coin = data.getCryptoById(indexPath.item)
            cell?.image.sd_setImage(with: URL(string: coin.image))
            cell?.name.text = coin.name
            cell?.switcher.isOn = data.isSelectedCoin(coin)
            cell?.configure(with: coin)
            cell?.onSwitcherStateUpdate = { [weak self] isOn in
                self?.data.didUpdatedStateForCoin(coin, isSelected: isOn)
            }
            return cell ?? CoinCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag != .crypto {
            completionHandler?(data.getCityById(indexPath.item) ?? data.getSelectedCity())
            navigationController?.popViewController(animated: true)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    private func initUITableView() {
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifireCity)
        tableView.register(CoinCell.self, forCellReuseIdentifier: reuseIdentifireCoin)
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
