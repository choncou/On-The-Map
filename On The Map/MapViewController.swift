//
//  MapViewController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/28.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createStudentAnnotation(student: Student){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double(student.latitude!), Double(student.longitude!))
        annotation.title = "\(student.firstName) \(student.lastName)"
        annotation.subtitle = student.mediaURL
        self.mapView.addAnnotation(annotation)
    }
    

}

extension MapViewController: MKMapViewDelegate{
    
    
}
