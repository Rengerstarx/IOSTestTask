import UIKit
import TinyConstraints

open class BaseWidgetView: UIView {
    
    weak var delegate: SetupDelegate?
    private let nameLable = UILabel()
    let settingsButton  = UIButton()
    let startButton = UIButton()
    open var containerView = UIView()
    private let baseImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupView() {
        nameLable.font = UIFont.systemFont(ofSize: 16)
        nameLable.textColor = .gray
        startButton.backgroundColor = UIColor.appBlue
        startButton.layer.cornerRadius = 10
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        startButton.setTitle("Выбрать", for: .normal)
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        settingsButton.isHidden = true
        containerView.isHidden = true
    }
    
    open func setupLayout() {
        addSubview(nameLable)
        nameLable.topToSuperview(offset: 10)
        nameLable.leftToSuperview(offset: 10)
        addSubview(containerView)
        containerView.topToBottom(of: nameLable, offset: 10)
        containerView.leftToSuperview(offset: 10)
        containerView.rightToSuperview(offset: -10)
        containerView.bottomToSuperview(offset: -10)
        addSubview(baseImage)
        baseImage.topToBottom(of: nameLable, offset: 10)
        baseImage.leftToSuperview(offset: 10)
        baseImage.rightToSuperview(offset: -10)
        baseImage.bottomToSuperview(offset: -10)
        addSubview(startButton)
        startButton.centerXToSuperview()
        startButton.bottomToSuperview(offset: -30)
        addSubview(settingsButton)
        settingsButton.topToSuperview(offset: 10)
        settingsButton.rightToSuperview(offset: -10)
    }
    
    open func setupStart(nameOfView name: String, imageOfView image: String) {
        nameLable.text = name
        baseImage.image = UIImage(named: image)
    }
    
    open func switcher(_ marker: Bool) {
        settingsButton.isHidden = false
        settingsButton.isHidden = !marker
        containerView.isHidden = !marker
        baseImage.isHidden = marker
        startButton.isHidden = marker
    }
}
