//
//  ViewController.swift
//  Displaying Starbucks
//
//  Created by Saddam Al Amin on 4/26/17.
//  Copyright © 2017 Saddam Al Amin. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var myTableView: UITableView!
    var locationManager = CLLocationManager()
    
    var model = [MapModel]()
    var latitude = ""
    var longitude = ""
    var called = false


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.first!
        longitude = "\(userLocation.coordinate.longitude)"
        latitude = "\(userLocation.coordinate.latitude)"
        locationManager.stopUpdatingLocation()
        
        if called == false {
            parseApi()
            called = true
        }
    }
    
    func parseApi() {
        let requestUrl = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=2500&type=Starbucks&keyword=Starbucks&key=AIzaSyA4FKXPy5GmMUpO6TUmv4uGnVOc_HvTbZw")
        
        let urlRequest = URLRequest(url: requestUrl!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            let httpRespose = response as! HTTPURLResponse
            let statusCode = httpRespose.statusCode
            if ( statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    if let results = json?["results"] as? [Dictionary<String, AnyObject>] {
                        for result in results {
                            guard let lat = (((result["geometry"] as? NSDictionary)?["location"]as? NSDictionary)?["lat"]), let lng = (((result["geometry"] as? NSDictionary)?["location"]as? NSDictionary)?["lng"]) else {
                                return
                            }
                            guard let vacinity = result["vicinity"] as? String, let name = result["name"] as? String else {
                                return
                            }
                            
                            self.model.append(MapModel(title:name,address: vacinity, lat: "lat", long: "long"))
                        }
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                }catch {
                    
                }
            }
        }
        task.resume()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! LocationTableViewCell
        let models = model[indexPath.row]
        cell.textLabel?.text = models.title
        cell.detailTextLabel?.text = models.address
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

}

