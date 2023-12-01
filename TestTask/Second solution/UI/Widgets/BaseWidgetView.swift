import UIKit
import TinyConstraints

open class BaseWidgetView: UIView {
    
    weak var delegate: SetupDelegate?
    private let nameLable = UILabel()
    let settingsButton  = UIButton()
    let startButton = UIButton()
    let tryButton = UIButton()
    open var containerView = UIView()
    private let baseImage = UIImageView()
    private let loader = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .white
        nameLable.font = UIFont.systemFont(ofSize: 16)
        nameLable.textColor = .gray
        startButton.backgroundColor = UIColor.appBlue
        startButton.layer.cornerRadius = 10
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        startButton.setTitle("Выбрать", for: .normal)
        tryButton.backgroundColor = UIColor.appBlue
        tryButton.layer.cornerRadius = 10
        tryButton.setTitleColor(.white, for: .normal)
        tryButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        tryButton.setTitle("Повторить", for: .normal)
        tryButton.isHidden = true
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        settingsButton.isHidden = true
        loader.startAnimating()
        loader.isHidden = false
        containerView.layer.cornerRadius = 20
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
        addSubview(tryButton)
        tryButton.centerXToSuperview()
        tryButton.bottomToSuperview(offset: -30)
        addSubview(loader)
        loader.center(in: containerView)
        addSubview(settingsButton)
        settingsButton.topToSuperview(offset: 10)
        settingsButton.rightToSuperview(offset: -10)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    open func setupStart(nameOfView name: String, imageOfView image: String) {
        nameLable.text = name
        baseImage.image = UIImage(named: image)
    }
    
    func setView(widgetState state: WidgetState) {
        switch state {
        case .connectError:
            settingsButton.isHidden = true
            containerView.isHidden = true
            baseImage.isHidden = false
            startButton.isHidden = true
            tryButton.isHidden = false
        case .nilError:
            settingsButton.isHidden = true
            containerView.isHidden = true
            baseImage.isHidden = false
            startButton.isHidden = false
            tryButton.isHidden = true
        case .correct:
            settingsButton.isHidden = false
            containerView.isHidden = false
            baseImage.isHidden = true
            startButton.isHidden = true
            tryButton.isHidden = true
        }
    }
    
    func setHiddenLoader(_ marker: Bool) {
        loader.isHidden = marker
    }
}
