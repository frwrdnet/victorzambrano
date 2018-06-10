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
		
		if let project = projects?[indexPath.row]  { //projectForIndexPath(indexPath)
			
			print("----\n Project title: \(project.projectTitle)")
			
			cell.projectThumbTitle.text = project.projectTitle
			cell.projectThumbImage.image = UIImage(named: "placeholder-thumbnail-fullwidth")
			
			//cell.projectThumbImage.image = getImageFromURL(imageURL: (project.projectImages.first?.imageThumbnailURL)!)
			
//			let imageHolder = getImageFromURL(imageName: project.projectImages.first?.slug ?? "image-\(project.projectSlug)", imageType: project.projectImages.first?.imageThumbnailURL ?? "jpg")
//			if imageHolder.size.height > 0 {
//				cell.projectThumbImage.image = imageHolder
//			}
			
//			let projectImage = URL(fileURLWithPath: (project.projectImages.first?.imageThumbnailURL)!)
//			do {
//				let imageData = try Data(contentsOf: projectImage)
//				cell.projectThumbImage.image = UIImage(data: imageData)
//			} catch {
//				print("Error getting image data \(error)")
//			}
		
		}
		
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
		
//		if let test0 = projects?[0].projectID {
//			print("Loading project data...")
//			projects = realm.objects(Project.self)
//		} else {
			print("Getting project data...")
			getProjectData(url: postURL, parameters: ["":""])
//		}
		
		//print("Projects: \(String(describing: projects))\n----")
		
	}

	
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
		
		print("json[0][\"slug\"].stringValue: \(json[0]["slug"].stringValue)")
		
		var index = 0
		
		if let temp1 = json[0]["date"].string {
			
			for proj in json {
				
				let project = proj.1
				
				if realm.objects(Project.self).filter("projectSlug CONTAINS %@", project["slug"].stringValue).count <= 0 {
				//if let temp2 = project["id"].int {
					
					// newProject
					
					print("newProject = \(project["slug"].stringValue)\n----")
					
					let newProject = Project()
					newProject.projectID = project["id"].stringValue
					newProject.projectSlug = project["slug"].stringValue
					newProject.projectDate = project["date"].stringValue
					newProject.projectSelfJsonLink = ""//project["_links"]["href"].stringValue
					newProject.projectURL = project["link"].stringValue
					newProject.projectContent = ""//project["content"]["rendered"].stringValue
					newProject.projectTitle = project["title"]["rendered"].stringValue
					newProject.projectExcerpt = project["excerpt"]["rendered"].stringValue
					
					// RETRIEVE PROJECT IMAGES FROM POST JSON
					let imagesURL = project["_links"]["wp:attachment"][0]["href"].stringValue
					print("imagesURL: \(imagesURL)")
					
					getProjectImagesData(url: imagesURL, parameters: ["" : ""], index: Int(index))
					
					// SAVE TO REALM DB
					//if realm.objects(Project.self).filter("projectID CONTAINS[cd] %@", project["id"].stringValue).count == 0 {
						do {
							try realm.write {
								realm.add(newProject)
								projects = realm.objects(Project.self) //selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
								print("Saved newProject \(index) info!")
							}
						} catch {
							print("Error saving done status for newProject, Error: \(error)")
						}
					//}
				
				} else {
					print("Could not find 'project[\"id\"].int'")
				}
				
				index = index + 1
			}
		} else {
			print("Oh oh, wrong JSON reading...")
		}

		print("Done getting projects from JSON\n----")
		
		projects = realm.objects(Project.self)
		
		updateUIWithProjectData()
    }
	
	func updateProjectImagesData(json: JSON, index: Int) {
		print("----\n updateProjectImagesData \(index)")
		print("currentProject: \(String(describing: projects?[index].projectSlug))")
		
		let images = json
		
		//let imagesList: List<ProjectImage>?
		
		for img in images {
		
			let projectImage = ProjectImage()
			
			let image = img.1
			
			//print("\(image)\n---")
			
			projectImage["url"] = image["guid"]["rendered"].stringValue
			projectImage["link"] = image["link"].stringValue
			projectImage["title"] = image["title"]["rendered"].stringValue
			projectImage["slug"] = image["slug"].stringValue
			projectImage["mediaType"] = image["media_type"].stringValue
			projectImage["mimeType"] = image["mime_type"].stringValue
			projectImage["imageWidth"] = image["media_details"]["width"].stringValue
			projectImage["imageHeight"] = image["media_details"]["height"].stringValue
			projectImage["imageFile"] = image["media_details"]["height"].stringValue
			
			projectImage["imageThumbnailURL"] = image["media_details"]["sizes"]["thumbnail"]["source_url"].stringValue
			projectImage["imageThumbnailWidth"] = image["media_details"]["sizes"]["thumbnail"]["width"].stringValue
			projectImage["imageThumbnailHeight"] = image["media_details"]["sizes"]["thumbnail"]["height"].stringValue
			projectImage["imageThumbnailMimeType"] = image["media_details"]["sizes"]["thumbnail"]["mime_type"].stringValue
			
			projectImage["imageMediumURL"] = image["media_details"]["sizes"]["medium"]["source_url"].stringValue
			projectImage["imageMediumWidth"] = image["media_details"]["sizes"]["medium"]["width"].stringValue
			projectImage["imageMediumHeight"] = image["media_details"]["sizes"]["medium"]["height"].stringValue
			projectImage["imageMediumMimeType"] = image["media_details"]["sizes"]["medium"]["mime_type"].stringValue
			
			projectImage["imageLargeURL"] = image["media_details"]["sizes"]["large"]["source_url"].stringValue
			projectImage["imageLargeWidth"] = image["media_details"]["sizes"]["large"]["width"].stringValue
			projectImage["imageLargeHeight"] = image["media_details"]["sizes"]["large"]["height"].stringValue
			projectImage["imageLargeMimeType"] = image["media_details"]["sizes"]["large"]["mime_type"].stringValue
			
			projectImage["imageFeatureURL"] = image["media_details"]["sizes"]["feature_image"]["source_url"].stringValue
			projectImage["imageFeatureWidth"] = image["media_details"]["sizes"]["feature_image"]["width"].stringValue
			projectImage["imageFeatureHeight"] = image["media_details"]["sizes"]["feature_image"]["height"].stringValue
			projectImage["imageFeatureMimeType"] = image["media_details"]["sizes"]["feature_image"]["mime_type"].stringValue
			
			projectImage["imageFullURL"] = image["media_details"]["sizes"]["full"]["source_url"].stringValue
			projectImage["imageFullWidth"] = image["media_details"]["sizes"]["full"]["width"].stringValue
			projectImage["imageFullHeight"] = image["media_details"]["sizes"]["full"]["height"].stringValue
			projectImage["imageFullMimeType"] = image["media_details"]["sizes"]["full"]["mime_type"].stringValue
			
			if let currentProject = projects?[index] {
				// SAVE TO REALM DB
				do {
					try realm.write {
						currentProject.projectImages.append(projectImage)
						print("Saved project image: \(projectImage.slug)!")
					}
				} catch {
					print("Error saving images for currentProject, Error: \(error)")
				}
			}
			
		} // end for
		
		collectionView?.reloadData()
		
	}
	
	func checkIfProjectExists(projectID: String) -> Bool {
		let foo = realm.objects(Project.self).filter("projectID CONTAINS[cd] %@", projectID)
		if foo.count > 0 {
			return false
		}
		return true
//		let predicate = NSPredicate(format: "date = %@", findDate as CVarArg)
//		let dateObject = self.realm.objects(ChartCount.self).filter(predicate).first
//
//		if dateObject?.date == findDate{
//			return dateObject
//		}
//		return nil
	}
	
	func getImageFromURL(imageURL: String) -> UIImage {
		var image: UIImage?
		let pictureURL = URL(string: imageURL)!
		
		// Creating a session object with the default configuration.
		// You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
		let session = URLSession(configuration: .default)
		
		// Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
		let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
			// The download has finished.
			if let e = error {
				print("Error downloading picture: \(e)")
			} else {
				// No errors found.
				// It would be weird if we didn't have a response, so check for that too.
				if let res = response as? HTTPURLResponse {
					print("Downloaded picture with response code \(res.statusCode)")
					if let imageData = data {
						// Finally convert that Data into an image and do what you wish with it.
						image = UIImage(data: imageData)
						// Do something with your image.
						print("Got the image!")
					} else {
						print("Couldn't get image: Image is nil")
					}
				} else {
					print("Couldn't get response code for some reason")
				}
			}
		}
		
		downloadPicTask.resume()
		
		return image!
	}
	
	
	//MARK: - Update Projects
	/***************************************************************/
	
	func updateUIWithProjectData() {
		
		print("========\n updateUIWithProjectData... \n========")
		
		collectionView?.reloadData()
	}
	
}

// MARK: - Private
private extension CollectionViewController {
	func projectForIndexPath(_ indexPath: IndexPath) -> Project {
		return projects![indexPath.row]
	}
}
