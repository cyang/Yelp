//
//  MapViewController.swift
//  Yelp
//
//  Created by Christopher Yang on 2/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var address: String?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation(address!.stringByReplacingOccurrencesOfString(" ", withString: "+"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation(address: String) {
        let apiKey = "AIzaSyCV2ROpSqKnRNsjyyPwI4Rl3EZT5paabb8"
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(address),+CA&key=\(apiKey)")
        
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {

                            print(responseDictionary)

                            let location = responseDictionary["results"]![0]["geometry"]!!["location"] as? NSDictionary
                            
                            let latitude = location!["lat"] as! CLLocationDegrees
                            let longitude = location!["lng"] as! CLLocationDegrees
                            
                            let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
                            let centerLocation2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            
                            self.goToLocation(centerLocation)
                            self.addAnnotationAtCoordinate(centerLocation2D)
                    }
                }
        });
        task.resume()
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
