//
//  StationViewController.swift
//  Werkstuk_2_DennisVanMalder
//
//  Created by student on 05/07/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class StationViewController: UIViewController {

    @IBOutlet weak var stationNaam: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var standCount: UILabel!
    @IBOutlet weak var bikeCount: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var station: Station = Station()
    var stations: Array<Station> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stationsnaam
        self.stationNaam.text = station.name
        //status, green open, red closed
        self.Status.text = station.status
        if station.status == "OPEN" {
            self.Status.textColor = UIColor.green
        } else {
            self.Status.textColor = UIColor.red
        }
        //bikes available
        self.bikeCount.text = String(station.available_bikes)
        if station.available_bikes == 0 {
            self.bikeCount.textColor = UIColor.red
        } else {
            self.bikeCount.textColor = UIColor.green
        }
        //bike stands available
        self.standCount.text = String(station.available_bike_stands)
        if station.available_bike_stands == 0 {
            self.standCount.textColor = UIColor.red
        } else {
            self.standCount.textColor = UIColor.green
        }
        //adress
        self.address.text = station.address
        
        //annotations
        for station in stations {
            let location = CLLocationCoordinate2DMake(station.latitude, station.longitude)
            let annotation: annotations =  annotations(coordinate: location, title: station.name!, subtitle: station.status!)
            map.addAnnotation(annotation)
        }
        //aanmaken map regions/span + location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001,0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(station.latitude, station.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //annotationActions https://stackoverflow.com/questions/39718728/how-to-make-an-action-for-a-map-annotated-button-in-swift
        
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
