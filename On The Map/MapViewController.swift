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
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToStudentsNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToStudentsNotification()
    }
    
    func createStudentAnnotation(student: Student){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double(student.latitude!), Double(student.longitude!))
        annotation.title = "\(student.firstName!) \(student.lastName!)"
        annotation.subtitle = student.mediaURL
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK: Notifications
    func subscribeToStudentsNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.studentsArrived(_:)), name: "StudentNotification", object: nil)
    }
    
    func unsubscribeToStudentsNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "StudentNotification", object: nil)
    }
    
    func studentsArrived(notification: NSNotification) {
        let tabBar = tabBarController as! TabBarController
        guard let students = tabBar.studentsStore else{
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        for student in students{
            createStudentAnnotation(student)
        }
    }

}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIApplication.sharedApplication().openURL(NSURL(string: (view.annotation?.subtitle!)!)!)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        
        return annotationView
    }
    
}
