//
//  annotations.swift
//  Werkstuk_2_DennisVanMalder
//
//  Created by student on 05/07/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class annotations:  NSObject,
                    MKAnnotation
{
    
    var address: String?
    var available_bike_stands: Int64
    var available_bikes: Int64
    var banking: Bool
    var bike_stands: Int64
    var bonus: Bool
    var contract_name: String?
    var last_update: Int64
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var number: Int64
    var status: String?
    var title: String?
    var subtitle: String?
    
    
    
    init (
          address:String,
          AvailBikeStands:Int64,
          AvailBikes:Int64,
          banking:Bool,
          bonus:Bool,
          BikeStands:Int64,
          ContrName:String,
          LastUpdate:Int64,
          coordinate:CLLocationCoordinate2D,
          name:String,
          number:Int64,
          status:String
        )
    {
        self.address = address
        self.available_bike_stands = AvailBikeStands
        self.available_bikes = AvailBikes
        self.banking = banking
        self.bonus = bonus
        self.bike_stands = BikeStands
        self.contract_name = ContrName
        self.last_update = LastUpdate
        self.coordinate = coordinate
        self.name = name
        self.number = number
        self.status = status
    }
    
    init(
         coordinate: CLLocationCoordinate2D,
         title: String,
         subtitle: String
        )
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.name = ""
        self.number = 0
        self.status = ""
        self.address = ""
        self.available_bike_stands = 0
        self.available_bikes = 0
        self.banking = false
        self.bonus = false
        self.bike_stands = 0
        self.contract_name = ""
        self.last_update = 0
    }

}
