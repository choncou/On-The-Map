//
//  PostingViewController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/04/03.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostingViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studyQuestionlabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIRoundedButton!
    @IBOutlet weak var submitButton: UIRoundedButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomSection: UIView!
    var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchTextField.delegate = self
        urlTextField.delegate = self
        locationFindUI()
    }
    
//MARK: UI Setup
    /**
     Set up the UI when asking user for location
     */
    func locationFindUI() {
        studyQuestionlabel.hidden = false
        findOnMapButton.hidden = false
        searchTextField.hidden = false
        bottomSection.backgroundColor = bottomSection.backgroundColor?.colorWithAlphaComponent(1)
        submitButton.hidden = true
        mapView.hidden = true
    }
    
    /**
     Set up the UI when asking user for link
     */
    func linkAskUI() {
        guard location != nil else { return }
        cancelButton.tintColor = UIColor.whiteColor()
        studyQuestionlabel.hidden = true
        findOnMapButton.hidden = true
        searchTextField.hidden = true
        bottomSection.backgroundColor = bottomSection.backgroundColor?.colorWithAlphaComponent(0.5)
        submitButton.hidden = false
        mapView.hidden = false
        urlTextField.hidden = false
        setUpMap()
    }
    
// MARK: - Navigation
    @IBAction func cancelButtonTap(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapTap(sender: UIRoundedButton) {
        guard let text = searchTextField.text else { return }
        CLGeocoder().geocodeAddressString(text){placemarks, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let place = placemarks?.first else { return }
            self.location = place.location
            self.linkAskUI()
        }
    }
    
    @IBAction func submitButtonTap(sender: UIRoundedButton) {
        guard let url = urlTextField.text where urlTextField.text != "" else {
            showAlert("No Link", message: "Please enter a link")
            self.urlTextField.text = "http://udacity.com"
            return
        }
        ParseClient.postStudentLocations(searchTextField.text!, mediaURL: url, location: mapView.annotations.first!.coordinate) { error in
            performUpdateOnMain {
                guard error == nil else {
                    self.showAlert("Network Failure", message: "Failed to post your location")
                    return
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

extension PostingViewController: MKMapViewDelegate {
    /**
     Show annotation on map
     */
    func setUpMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = (location?.coordinate)!
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegionMake((location?.coordinate)!, MKCoordinateSpanMake(0.5, 0.5))
        mapView.setRegion(region, animated: true)
    }
}

extension PostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
}
