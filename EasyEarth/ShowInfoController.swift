//
//  ShowInfoController.swift
//  EasyEarth
//
//  Created by WGonzalez on 10/27/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//

import UIKit
import MapKit

class ShowInfoController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var locationPreviewMap: MKMapView!

    @IBOutlet weak var capitalDisplay: UILabel!
    @IBOutlet weak var populationDisplay: UILabel!

    
    let locationManager = CLLocationManager()
    
    //Stores info from the past segue
    var capitalText : String = ""
    var populationText : String = ""
    var locationForPreview : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Sets the info of whatever was seleccted previously
        capitalDisplay.text = capitalText
        populationDisplay.text = populationText
        
        geoCodeLocation(locationForPreview)
        
    }
    
    func geoCodeLocation(Location: String)
    {
        let myGeoCode = CLGeocoder()
        myGeoCode.geocodeAddressString(Location) { (placeMarks, error) -> Void in
            if error != nil
            {
                print("Error")
            }
            else
            {
                //Calls on the function to display on the map
                self.displayMap((placeMarks?.first)!)
            }
        }
    }
    
    //Creates a pin of the location selected by the user
    func displayMap(MyPlaceMark: CLPlacemark)
    {
        let myPin = MKPointAnnotation()
        locationForPreview = MyPlaceMark.name!
        let myLocation = MyPlaceMark
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegionMake((myLocation.location?.coordinate)!, span)
        locationPreviewMap.setRegion(region, animated: true)
        myPin.coordinate = (myLocation.location?.coordinate)!
        myPin.title = MyPlaceMark.name
        locationPreviewMap.addAnnotation(myPin)
    }
    
    


}
