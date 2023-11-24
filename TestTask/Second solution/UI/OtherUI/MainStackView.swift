import UIKit

class MainStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView() {
        axis = .vertical
        distribution = .fillEqually
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
