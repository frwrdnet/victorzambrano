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
import RealmSwift

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let realm = try! Realm()
	
	var projects: Results<Project>?
	
	// portfolio projects
	let postURL = "https://victorzambrano.com/wp-json/wp/v2/jetpack-portfolio?jetpack-portfolio-type=72"
	
	let reuseIdentifier = "projectCell"
	let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	let itemsPerRow: CGFloat = 3

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		getProjectData(url: postURL, parameters: ["":""])
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return projects!.count
	}
	
	//2
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return projects!.count
	}
	
	//3
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		cell.backgroundColor = UIColor.black
		// Configure the cell
		return cell
	}
	
	//1
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//2
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	//3
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	// 4
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
	
	func loadProjects() {
		projects = realm.objects(Project.self)
	}

	
    //MARK: - Networking
    /***************************************************************/

	func getProjectData(url: String, parameters: [String : String]) {

        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the projects data")
                    let projectsJSON : JSON = JSON(response.result.value!)

                    self.updateProjectsData(json: projectsJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
	

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateProjectsData(json : JSON) {
		
		if let temp1 = json[0]["date"].string {
			
			for proj in json {
				
				let project = proj.1
				
				if let temp2 = project["id"].int {
					
					// TODO: SAVE TO REALM DB
					do {
						try realm.write {
							// newProject
					
							let newProject = Project()
							newProject.projectID = project["id"].stringValue
							newProject.projectSlug = project["slug"].stringValue
							newProject.projectDate = project["date"].stringValue
							newProject.projectSelfJsonLink = project["_links"]["href"].stringValue
							newProject.projectURL = project["link"].stringValue
							newProject.projectContent = project["content"]["rendered"].stringValue
							newProject.projectTitle = project["title"]["rendered"].stringValue
							newProject.projectExcerpt = project["excerpt"]["rendered"].stringValue
							
							// TODO: RETRIEVE PROJECT IMAGES FROM POST JSON
							newProject.projectImages = updateImageData(json: project)
							
						}
					} catch {
						print("Error saving done status for newProject, Error: \(error)")
					}
					
				} else {
					print("Could not find 'project[\"id\"].int'")
				}
			}
		} else {
			print("Oh oh, wrong JSON reading...")
		}

        //updateUIWithProjectData()
		loadProjects()
    }
	
	func updateImageData(json: JSON) -> ProjectImages {
		
		let projectImages = ProjectImages()
		
		if let temp1 = json["id"].int {
			
			let images = json["_links"]["wp:attachment"]["href"]
		
			for img in images {
				
				let image = img.1
				
				print(image)
				print("----------------")
				
				projectImages["url"] = image["guid"]["rendered"].stringValue
				projectImages["link"] = image["link"].stringValue
				projectImages["title"] = image["title"]["rendered"].stringValue
				projectImages["slug"] = image["slug"].stringValue
				projectImages["mediaType"] = image["media_type"].stringValue
				projectImages["mimeType"] = image["mime_type"].stringValue
				projectImages["imageWidth"] = image["media_details"]["width"].stringValue
				projectImages["imageHeight"] = image["media_details"]["height"].stringValue
				projectImages["imageFile"] = image["media_details"]["height"].stringValue
				
				projectImages["imageSizeThumbnail"] = image["media_details"]["sizes"]["thumbnail"]["source_url"].stringValue
				projectImages["imageSizeThumbnailWidth"] = image["media_details"]["sizes"]["thumbnail"]["width"].stringValue
				projectImages["imageSizeThumbnailHeight"] = image["media_details"]["sizes"]["thumbnail"]["height"].stringValue
				projectImages["imageSizeThumbnailMimeType"] = image["media_details"]["sizes"]["thumbnail"]["mime_type"].stringValue
				
				projectImages["imageSizeMedium"] = image["media_details"]["sizes"]["medium"]["source_url"].stringValue
				projectImages["imageSizeMediumWidth"] = image["media_details"]["sizes"]["medium"]["width"].stringValue
				projectImages["imageSizeMediumHeight"] = image["media_details"]["sizes"]["medium"]["height"].stringValue
				projectImages["imageSizeMediumMimeType"] = image["media_details"]["sizes"]["medium"]["mime_type"].stringValue
				
				projectImages["imageSizeLarge"] = image["media_details"]["sizes"]["large"]["source_url"].stringValue
				projectImages["imageSizeLargeWidth"] = image["media_details"]["sizes"]["large"]["width"].stringValue
				projectImages["imageSizeLargeHeight"] = image["media_details"]["sizes"]["large"]["height"].stringValue
				projectImages["imageSizeLargeMimeType"] = image["media_details"]["sizes"]["large"]["mime_type"].stringValue
				
				projectImages["imageSizeFeature"] = image["media_details"]["sizes"]["feature_image"]["source_url"].stringValue
				projectImages["imageSizeFeatureWidth"] = image["media_details"]["sizes"]["feature_image"]["width"].stringValue
				projectImages["imageSizeFeatureHeight"] = image["media_details"]["sizes"]["feature_image"]["height"].stringValue
				projectImages["imageSizeFeatureMimeType"] = image["media_details"]["sizes"]["feature_image"]["mime_type"].stringValue
				
				projectImages["imageSizeFull"] = image["media_details"]["sizes"]["full"]["source_url"].stringValue
				projectImages["imageSizeFullWidth"] = image["media_details"]["sizes"]["full"]["width"].stringValue
				projectImages["imageSizeFullHeight"] = image["media_details"]["sizes"]["full"]["height"].stringValue
				projectImages["imageSizeFullMimeType"] = image["media_details"]["sizes"]["full"]["mime_type"].stringValue
			} // end for
			
		} else {
			print("Can't find json[\"id\"].int ")
		}
		
		return projectImages
	}
	
	
	//MARK: - Update Projects
	/***************************************************************/
	
	func updateUIWithProjectData() {
		
		print("updateUIWithProjectData")
		
	}
	
}
