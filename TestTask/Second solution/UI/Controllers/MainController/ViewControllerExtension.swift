import UIKit

extension ViewController {
    func setBar() {
        let navBar = self.navigationController!.navigationBar
        let standartAppearence = UINavigationBarAppearance()
        standartAppearence.configureWithOpaqueBackground()
        standartAppearence.backgroundColor = UIColor.appBlue
        standartAppearence.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 24)]
        navBar.standardAppearance = standartAppearence
        navBar.scrollEdgeAppearance = standartAppearence
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
}
