//
//  CollectionViewController.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/4/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let realm = try! Realm()
	
	var projects: Results<Project>?
	
	var selectedProject: Project?
	
	// portfolio projects
	let postURL = "https://victorzambrano.com/wp-json/wp/v2/jetpack-portfolio?jetpack-portfolio-type=72"
	
	let reuseIdentifier = "projectCell"
	let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	let itemsPerRow: CGFloat = 3

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		loadProjects()
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("collectionView - numberOfSections: \(String(describing: projects?.count ?? 1))")
		return 1 //projects?.count ?? 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("collectionView - numberOfItemsInSection: \(String(describing: projects?.count ?? nil))")
		return projects?.count ?? 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		print("collectionView - cellForItemAt: \(indexPath.row)")

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProjectCell
		//let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ProjectCell
		//cell.backgroundColor = UIColor.black
		
		let project = projects![indexPath.row]  //projectForIndexPath(indexPath)
		
		print("Project title: \(project.projectTitle)")
		
		cell.projectThumbTitle.text = project.projectTitle
		//cell.projectThumbImage.image = project.projectImage

		// Configure the cell
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		print("collectionView - cellForItemAt")

		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow

		return CGSize(width: widthPerItem, height: widthPerItem)
	}

//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//		print("collectionView - insetForSectionAt")
//
//		return sectionInsets
//
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//		print("collectionView - minimumLineSpacingForSectionAt")
//
//		return sectionInsets.left
//
//	}
	
	func loadProjects() {
		
		print("loadProjects...")
		
		if let test0 = projects?[0].projectID {
			print("Loading project data...")
			projects = realm.objects(Project.self)
		} else {
			print("Getting project data...")
			getProjectData(url: postURL, parameters: ["":""])
		}
			
		//print("Projects: \(String(describing: projects))\n----")
		
	}
	
	// MARK: Project Image Management
//	func getProjectImages(url: String, parameters: [String:String]) -> ProjectImages {
//
//	}

	
    //MARK: - Networking
    /***************************************************************/

	func getProjectData(url: String, parameters: [String : String]) {
		
		print("getProjectData...")

        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the projects data")
                    let json : JSON = JSON(response.result.value!)

                    self.updateProjectsData(json: json)
					
//					print("updateProjectsData...")
//
//					if let temp1 = json[0]["date"].string {
//
//						for proj in json {
//
//							let project = proj.1
//
//							if let temp2 = project["id"].int {
//
//								// newProject
//
//								print("newProject = \(project)\n----")
//
//								let newProject = Project()
//								newProject.projectID = project["id"].stringValue
//								newProject.projectSlug = project["slug"].stringValue
//								newProject.projectDate = project["date"].stringValue
//								newProject.projectSelfJsonLink = project["_links"]["href"].stringValue
//								newProject.projectURL = project["link"].stringValue
//								newProject.projectContent = project["content"]["rendered"].stringValue
//								newProject.projectTitle = project["title"]["rendered"].stringValue
//								newProject.projectExcerpt = project["excerpt"]["rendered"].stringValue
//
//								// SAVE TO REALM DB
//								do {
//									try self.realm.write {
//										self.realm.add(newProject)
//										print("Saved project info!")
//									}
//								} catch {
//									print("Error saving done status for newProject, Error: \(error)")
//								}
//
//								// RETRIEVE PROJECT IMAGES FROM POST JSON
//								let imagesURL = json["_links"]["wp:attachment"]["href"].stringValue
//
//								//newProject.projectImages = self.getProjectImagesData(url: imagesURL, parameters: ["" : ""])
//
//							} else {
//								print("Could not find 'project[\"id\"].int'")
//							}
//						}
//					} else {
//						print("Oh oh, wrong JSON reading...")
//					}

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    //self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
	
	func getProjectImagesData(url: String, parameters: [String : String], index: Int) {

		print("getProjectImagesData...")

		Alamofire.request(url, method: .get, parameters: parameters)
			.responseJSON { response in
				if response.result.isSuccess {

					print("Sucess! Got the projects data")
					let images : JSON = JSON(response.result.value!)

					self.updateProjectImagesData(json: images, index: index)

				} else {
					print("Error: \(String(describing: response.result.error))")
					//self.bitcoinPriceLabel.text = "Connection Issues"
				}
		}

	}
	

    //MARK: - JSON Parsing
    /***************************************************************/

	func updateProjectsData(json : JSON) {
		
		print("updateProjectsData...")
		
		if let temp1 = json[0]["date"].string {
			
			for (index, proj) in json {
				
				let project = proj
				
				if let temp2 = project["id"].int {
					
					// newProject
					
					print("newProject = \(project)\n----")
					
					let newProject = Project()
					newProject.projectID = project["id"].stringValue
					newProject.projectSlug = project["slug"].stringValue
					newProject.projectDate = project["date"].stringValue
					newProject.projectSelfJsonLink = project["_links"]["href"].stringValue
					newProject.projectURL = project["link"].stringValue
					newProject.projectContent = project["content"]["rendered"].stringValue
					newProject.projectTitle = project["title"]["rendered"].stringValue
					newProject.projectExcerpt = project["excerpt"]["rendered"].stringValue
					
					// RETRIEVE PROJECT IMAGES FROM POST JSON
					let imagesURL = json["_links"]["wp:attachment"]["href"].stringValue
					
					getProjectImagesData(url: imagesURL, parameters: ["" : ""], index: Int(index)!)
					
					// SAVE TO REALM DB
					do {
						try realm.write {
							realm.add(newProject)
							print("Saved project info!")
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

		print("Done getting projects from JSON\n----")
		
		updateUIWithProjectData()
    }
	
	func updateProjectImagesData(json: JSON, index: Int) {
		
		let images = json
		
		//let imagesList: List<ProjectImage>?
		
		for img in images {
		
			let projectImage = ProjectImage()
			
			let image = img.1
			
			print("\(image)\n---")
			
			projectImage["url"] = image["guid"]["rendered"].stringValue
			projectImage["link"] = image["link"].stringValue
			projectImage["title"] = image["title"]["rendered"].stringValue
			projectImage["slug"] = image["slug"].stringValue
			projectImage["mediaType"] = image["media_type"].stringValue
			projectImage["mimeType"] = image["mime_type"].stringValue
			projectImage["imageWidth"] = image["media_details"]["width"].stringValue
			projectImage["imageHeight"] = image["media_details"]["height"].stringValue
			projectImage["imageFile"] = image["media_details"]["height"].stringValue
			
			projectImage["imageSizeThumbnail"] = image["media_details"]["sizes"]["thumbnail"]["source_url"].stringValue
			projectImage["imageSizeThumbnailWidth"] = image["media_details"]["sizes"]["thumbnail"]["width"].stringValue
			projectImage["imageSizeThumbnailHeight"] = image["media_details"]["sizes"]["thumbnail"]["height"].stringValue
			projectImage["imageSizeThumbnailMimeType"] = image["media_details"]["sizes"]["thumbnail"]["mime_type"].stringValue
			
			projectImage["imageSizeMedium"] = image["media_details"]["sizes"]["medium"]["source_url"].stringValue
			projectImage["imageSizeMediumWidth"] = image["media_details"]["sizes"]["medium"]["width"].stringValue
			projectImage["imageSizeMediumHeight"] = image["media_details"]["sizes"]["medium"]["height"].stringValue
			projectImage["imageSizeMediumMimeType"] = image["media_details"]["sizes"]["medium"]["mime_type"].stringValue
			
			projectImage["imageSizeLarge"] = image["media_details"]["sizes"]["large"]["source_url"].stringValue
			projectImage["imageSizeLargeWidth"] = image["media_details"]["sizes"]["large"]["width"].stringValue
			projectImage["imageSizeLargeHeight"] = image["media_details"]["sizes"]["large"]["height"].stringValue
			projectImage["imageSizeLargeMimeType"] = image["media_details"]["sizes"]["large"]["mime_type"].stringValue
			
			projectImage["imageSizeFeature"] = image["media_details"]["sizes"]["feature_image"]["source_url"].stringValue
			projectImage["imageSizeFeatureWidth"] = image["media_details"]["sizes"]["feature_image"]["width"].stringValue
			projectImage["imageSizeFeatureHeight"] = image["media_details"]["sizes"]["feature_image"]["height"].stringValue
			projectImage["imageSizeFeatureMimeType"] = image["media_details"]["sizes"]["feature_image"]["mime_type"].stringValue
			
			projectImage["imageSizeFull"] = image["media_details"]["sizes"]["full"]["source_url"].stringValue
			projectImage["imageSizeFullWidth"] = image["media_details"]["sizes"]["full"]["width"].stringValue
			projectImage["imageSizeFullHeight"] = image["media_details"]["sizes"]["full"]["height"].stringValue
			projectImage["imageSizeFullMimeType"] = image["media_details"]["sizes"]["full"]["mime_type"].stringValue
			
			//imagesList?.append(projectImage)
			
			if let currentProject = projects?[index] {
				
				// SAVE TO REALM DB
				do {
					try realm.write {
						//realm.add(imagesList)
						currentProject.projectImages.append(projectImage)
						print("\(index): Saved project images!")
					}
				} catch {
					print("Error saving images for currentProject, Error: \(error)")
				}
			}
			
		} // end for
		
	}
	
	
	//MARK: - Update Projects
	/***************************************************************/
	
	func updateUIWithProjectData() {
		
		print("updateUIWithProjectData...")
		
		loadProjects()
		
	}
	
}

// MARK: - Private
private extension CollectionViewController {
	func projectForIndexPath(_ indexPath: IndexPath) -> Project {
		return projects![indexPath.row]
	}
}
