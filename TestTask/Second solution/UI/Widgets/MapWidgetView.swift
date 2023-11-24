import UIKit
import MapKit

class MapWidgetView: BaseWidgetView {
    private let additionalView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStart(nameOfView: "Map", imageOfView: "mapBack")
        setupLayout()
        setupView()
    }
    
    override func setupStart(nameOfView name: String, imageOfView image: String) {
        super.setupStart(nameOfView: name, imageOfView: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        super.containerView.addSubview(additionalView)
        additionalView.edgesToSuperview()
    }
    
    override func setupView() {
        super.setupView()
        additionalView.isScrollEnabled = false
        additionalView.isZoomEnabled = false
    }
    
    override func switcher(_ marker: Bool) {
        super.switcher(marker)
    }
    
    func setup(_ city: City) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coord = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        let region = MKCoordinateRegion(center: coord, span: span)
        additionalView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "City: \(city.name)"
        additionalView.addAnnotation(annotation)
    }
}
