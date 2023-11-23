//
//  Map.swift
//  TestTask
//
//  Created by sergey on 11/21/23.
//

import Foundation
import MapKit

class WidgetMap {
    private let def = Defaults()
    private let name = "selectedMapCity"
    private let mapView = MKMapView()
    private var city: City?
    private var isActive = false

    init(){
        checkMap()
        if isActive{
            settingsMap()
        }
    }
    
    private func checkMap() {
        let savedCity = def.getCity(name)
        if savedCity != nil {
            city = savedCity
            isActive = true
        }else {
            isActive = false
        }
    }
    
    private func settingsMap() {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coord = CLLocationCoordinate2D(latitude: city!.latitude, longitude: city!.longitude)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "City: \(city!.name)"
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.addAnnotation(annotation)
    }
    
    func update() {
        checkMap()
        settingsMap()
    }

    func getMap() -> MKMapView {
        return mapView
    }

    func getActive() -> Bool {
        return isActive
    }

}
