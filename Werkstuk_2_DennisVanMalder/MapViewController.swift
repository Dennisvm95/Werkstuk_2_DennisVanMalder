//
//  MapViewController.swift
//  Werkstuk_2_DennisVanMalder
//
//  Created by student on 05/07/2018.
//  Copyright © 2018 student. All rights reserved.
//
//annotations   https://www.youtube.com/watch?v=LJ7PG-o5XLA&t=1s


import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController:    UIViewController,
                            CLLocationManagerDelegate,
                            MKMapViewDelegate
{

    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var mainMap: MKMapView!
    
    var locationManager = CLLocationManager()
    var x = 0
    let jsonUrl = "https://api.jcdecaux.com/vls/v1/stations?contract=Bruxelles-Capitale&apiKey=0f6eeb84f56a0ec96b79278e957afed918b2d6db"
    var stations: Array<Station> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        let date = Date()
        let c = Calendar.current
        let sec = c.component(.second, from: date)
        let min = c.component(.minute, from: date)
        let hour = c.component(.hour, from: date)
        lastUpdate.text = "Last Updated: " + "\(hour):\(min):\(sec)"
        // Do any additional setup after loading the view.
        locationManager.delegate = self //as! CLLocationManagerDelegate - extend ad
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        showAnnotations()
    }
    
    //opzetten map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.0001,0.0001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mainMap.setRegion(region, animated: true)
        self.mainMap.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData(){
        //copy paste van viewdidload
        let date = Date()
        let c = Calendar.current
        let sec = c.component(.second, from: date)
        let min = c.component(.minute, from: date)
        let hour = c.component(.hour, from: date)
        lastUpdate.text = "Last Updated: " + "\(hour):\(min):\(sec)"
        
        //copy paste van getData stationdetails
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        request.returnsObjectsAsFaults = false
        do {
            let resultaten = try! managedContext.fetch(request)
            if resultaten.count > 0{
                for resultaat in resultaten as! [Station]
                {
                    stations.append(resultaat)
                }
            }
            else{
                let url = URL(string: jsonUrl)
                let urlRequest = URLRequest(url: url!)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                DispatchQueue.main.async {
                    let task = session.dataTask(with: urlRequest){ (data,response,error) in
                        guard error == nil else {
                            print("error can't get JSON")
                            print(error!)
                            return
                        }
                        guard let responseData = data
                            else{
                                print("Error: No Data available")
                                return
                        }
                        let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as? NSArray
                        for obj in json!
                        {
                            self.x = self.x + 1
                            if let objDict = obj as? NSDictionary
                            {
                                let obj = NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station
                                if objDict.value(forKey: "name") != nil{
                                    let objName = objDict.value(forKey: "name") as? String
                                    if objName != nil{
                                        obj.name = objName}
                                }
                                if objDict.value(forKey: "number") != nil {
                                    let objNumber = objDict.value(forKey: "number")  as! Int64
                                    obj.number = objNumber
                                }
                                if objDict.value(forKey: "address") != nil{
                                    let objAddress = objDict.value(forKey: "address")  as? String
                                    if objAddress != nil{
                                        obj.address = objAddress}
                                }
                                let objPosition = objDict.value(forKey:"position") as! NSDictionary
                                if objPosition.value(forKey: "lat") != nil{
                                    let objLat = objPosition.value(forKey:"lat") as! Double
                                    obj.latitude = objLat
                                }
                                if objPosition.value(forKey: "lng") != nil{
                                    let objLng = objPosition.value(forKey: "lng")  as! Double
                                    obj.longitude = objLng
                                }
                                if objDict.value(forKey: "banking") != nil{
                                    let objBanking = objDict.value(forKey: "banking")  as! Bool
                                    obj.banking = objBanking
                                }
                                if objDict.value(forKey: "bonus") != nil{
                                    let objBonus = objDict.value(forKey: "bonus")  as! Bool
                                    obj.bonus = objBonus
                                }
                                if objDict.value(forKey: "status") != nil{
                                    let objStatus = objDict.value(forKey: "status")  as? String
                                    if objStatus != nil{
                                        obj.status = objStatus}
                                }
                                if objDict.value(forKey: "contract_name") != nil{
                                    let objContractName = objDict.value(forKey: "contract_name")  as? String
                                    if objContractName != nil{
                                        obj.contract_name = objContractName}
                                }
                                if objDict.value(forKey: "bike_stands") != nil{
                                    let objBikeStands = objDict.value(forKey: "bike_stands")  as! Int64
                                    obj.bike_stands = objBikeStands
                                }
                                if objDict.value(forKey: "available_bike_stands") != nil{
                                    let objAvailBikeStands = objDict.value(forKey: "available_bike_stands")  as! Int64
                                    obj.available_bike_stands = objAvailBikeStands
                                }
                                if objDict.value(forKey: "available_bikes") != nil {
                                    let objAvailBikes = objDict.value(forKey: "available_bikes")  as! Int64
                                    obj.available_bikes = objAvailBikes
                                }
                                if objDict.value(forKey: "last_update") != nil {
                                    let objLastUpdate = objDict.value(forKey: "last_update")  as! Int64
                                    obj.last_update = objLastUpdate
                                }
                                do {
                                    print(self.x)
                                    try managedContext.save()
                                }
                                catch
                                {
                                    fatalError("Failure to save context: \(error)")
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        catch{
            print("No Data available")
        }
    }
    
    func showAnnotations(){
        //voor elk station in de array van alle stations - we gaan alle stations afprinten op de main map
        for station in stations {
            //preparen coordinate die gebruikt worden in de annotation
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
            //preparen van annotation, title en subtitle als in naam + status
            let annotation: annotations = annotations(coordinate: coordinate, title: station.name!, subtitle: station.status!)
            //annotation toevoegen aan map
            self.mainMap.addAnnotation(annotation)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
