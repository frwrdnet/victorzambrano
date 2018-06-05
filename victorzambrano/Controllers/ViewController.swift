//
//  ViewController.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/4/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
	
	let postURL = "https://victorzambrano.com/wp-json/wp/v2/posts"
	var finalURL = ""

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
    //MARK: - Networking
    /***************************************************************/

    func getProjectData(url: String, parameters: [String : String]) {

        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the projects data")
                    let weatherJSON : JSON = JSON(response.result.value!)

                    self.updateProjectsData(json: weatherJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
	

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateProjectsData(json : JSON) {

        if let tempResult = json["main"]["temp"].double {
        	//weatherData.temperature = Int(round(tempResult!) - 273.15)
        	//weatherData.city = json["name"].stringValue
        	//weatherData.condition = json["weather"][0]["id"].intValue
        	//weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
        }

        updateUIWithProjectData()
    }
	
	
	//MARK: - Update Projects
	/***************************************************************/
	
	func updateUIWithProjectData() {
		
		print("updateUIWithProjectData")
		
	}
	
}
