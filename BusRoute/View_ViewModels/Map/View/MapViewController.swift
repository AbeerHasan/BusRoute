//
//  ViewController.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController{

//--- Outlets ----------------------------------------
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loginDriverButton: UIButton!
    @IBOutlet weak var loginFormView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var deviceTokenTextField: UITextField!
    
//--- Variables --------------------------------------
    lazy var viewModel: MapViewModel = {
        return MapViewModel()
    }()
    
    let disposeBag = DisposeBag()
//--- ViewDidLoad ------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
            
//--- Helper Functions ------------------------------
    func setUp(){
        /*
        self.nameTextField.text = "bola_d"
        self.passwordTextField.text = "1234"
        */
        self.mapView.delegate = self
        
        self.loginFormView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMessageDialog))
        imageView.addGestureRecognizer(tap)
        
        bindTextFieldsToViewModel()
        subscribeToResponse()
        subscribeToLoginButton()
    }
    
    @objc func showMessageDialog(){
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let dialogVC = storyBoard.instantiateViewController(withIdentifier: MESSAGEVIEWCONTROLLER_ID) as! MessageViewController
            present(dialogVC, animated: true, completion: nil)
    }
    
    func bindTextFieldsToViewModel() {
        nameTextField.rx.text.orEmpty.bind(to: viewModel.driverNameBehavior).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.driverPasswordBehavior).disposed(by: disposeBag)
        deviceTokenTextField.rx.text.orEmpty.bind(to: viewModel.deviceTokenBehavior).disposed(by: disposeBag)
    }
    
    func subscribeToLoginButton() {
        loginDriverButton.rx.tap
               .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
               .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                if self.loginFormView.isHidden == true {
                    self.loginFormView.isHidden = false
                }else {
                    self.viewModel.getRoute()
                    self.loginFormView.isHidden = true
                }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        viewModel.loginResultObservable.subscribe(onNext: { [weak self] (route) in
            guard let self = self else { return }
            var points = [CLLocationCoordinate2D]()
            for point in route.routePath{
                let sourceLocation = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                points.append(sourceLocation)
            }
            self.createPath(points: points)
                                                                       
            for point in route.stop_points {
                let sourceLocation = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                self.putMark(location: sourceLocation, title: STOPPOINT)
            }
            self.loginDriverButton.setTitle(self.nameTextField.text, for: .normal)
            
        }).disposed(by: disposeBag)
    }
    
//--- Loading map --------------------------------------------------------------
    func putMark(location: CLLocationCoordinate2D, title: String){

        let sourcePlaceMark = MKPlacemark(coordinate: location, addressDictionary: nil)
      
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = title
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        self.mapView.showAnnotations([sourceAnotation], animated: true)
              
    }

    func createPath(points: [CLLocationCoordinate2D]) {
        var sourcePlaceMark = MKPlacemark(coordinate: points[0], addressDictionary: nil)
        var sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        
        self.putMark(location: points[0],title: STARTPOINT)
        
        for point in points {
            let destinationPlaceMark = MKPlacemark(coordinate: point, addressDictionary: nil)
                                    
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)
                                    
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationItem
            directionRequest.transportType = .automobile
                
            let direction = MKDirections(request: directionRequest)
                
                
            direction.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
            sourcePlaceMark = MKPlacemark(coordinate: point, addressDictionary: nil)
            sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
            
        }
        let endPoint = points[points.count - 1]
        self.putMark(location: endPoint, title: ENDPOINT)
    }
}

// --- Extensions -----------------------------------------------------------------
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
