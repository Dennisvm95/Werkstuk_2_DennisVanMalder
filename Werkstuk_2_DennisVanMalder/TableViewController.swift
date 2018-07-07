//
//  TableViewController.swift
//  Werkstuk_2_DennisVanMalder
//
//  Created by student on 05/07/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    
    let jsonUrl = "https://api.jcdecaux.com/vls/v1/stations?contract=Bruxelles-Capitale&apiKey=0f6eeb84f56a0ec96b79278e957afed918b2d6db"
    var x = 0
    var stations: Array<Station> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = stations[indexPath.row].name
        cell.detailTextLabel?.text = stations[indexPath.row].status
        
        return cell
    }
    
    
    func getData(){
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
                            print("error GET JSON")
                            print(error!)
                            return
                        }
                        guard let responseData = data
                            else{
                                print("Error: No Data received")
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
            print("No Data found")
        }    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "gotoStationsDetails"
        {
            if let vc = segue.destination as? StationViewController{
                var indexPath = self.tableView.indexPathForSelectedRow
                vc.station = stations[(indexPath?.row)!]
                vc.stations = stations
            }
        }
        }
    

}
