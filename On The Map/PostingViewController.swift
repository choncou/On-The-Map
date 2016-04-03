//
//  PostingViewController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/04/03.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    // MARK: - Navigation
    @IBAction func cancelButtonTap(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostingViewController: MKMapViewDelegate {
    
}
