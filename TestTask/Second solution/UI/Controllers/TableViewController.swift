import UIKit
import TinyConstraints

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var data = TableViewControllerData()
    var completionHandler: ((City?) -> Void)?
    var currentCity: City?
    
    init(_ city: City?) {
        currentCity = city
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUITableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getCitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell
        let city = data.getCityById(indexPath.item)
        cell?.codeLabel.text = city.code
        cell?.citynameLabel.text = city.name
        return cell ?? CityCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completionHandler?(data.getCityById(indexPath.item) ?? currentCity)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    private func initUITableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
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
