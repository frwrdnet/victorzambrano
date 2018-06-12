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
import moa

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let realm = try! Realm()
	
	var projects: Results<Project>?
	var projectsLoaded = false
	
	var selectedProject: Project?
	
	//
   /*
	Portfolio Projects: Based on WordPress API
	Project Types:
	- Architecture:		64
	- Exhibition:		65
	- Featured:			66 <-- Selected Type to Show
	- Graphic:			67
	- Interactive:		68
	- Mobile:			69
	- NDA:				70
	- Private:			71
	- Product:			72
	- Projects:			73
	- Service:			74
	- Video:			75
	- Web:				76
	*/
	let postURLFeatured = "https://victorzambrano.com/wp-json/wp/v2/jetpack-portfolio?jetpack-portfolio-type=66"
	let postURLProjects = "https://victorzambrano.com/wp-json/wp/v2/jetpack-portfolio"
	let postURLProjectsStatic = "https://victorzambrano.com/app/victorzambrano-featured-projects-20180611.json"
	var postURL = ""
	
	let reuseIdentifier = "projectCell"
	let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
	let itemsPerRow: CGFloat = 1
	let itemsPerColumn: CGFloat = 6

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		postURL = postURLProjects
		
		loadProjects()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// what to do exactly when the view is about to be shown
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("collectionView - numberOfSections: \(String(describing: projects?.count ?? 1))")
		return 1 //projects?.count ?? 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("collectionView - numberOfItemsInSection: \(String(describing: projects?.count ?? 1))")
		return projects?.count ?? 1
	}
	
	@IBDesignable class TopAlignedLabel: UILabel {
		override func drawText(in rect: CGRect) {
			if let stringText = text {
				let stringTextAsNSString = stringText as NSString
				let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
																		options: NSStringDrawingOptions.usesLineFragmentOrigin,
																		attributes: [kCTFontAttributeName as NSAttributedStringKey: font],
																		context: nil).size
				super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
			} else {
				super.drawText(in: rect)
			}
		}
		override func prepareForInterfaceBuilder() {
			super.prepareForInterfaceBuilder()
			layer.borderWidth = 1
			layer.borderColor = UIColor.black.cgColor
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		print("collectionView - cellForItemAt: \(indexPath.item)")
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProjectCell
		//let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ProjectCell
			
		if let project = projects?[indexPath.item]  { //projectForIndexPath(indexPath)
			
			// project has at least one featured image
			if project.featuredImage.count > 0 {
			
				print("----\n\(indexPath.item): Project title: \(project.projectTitle) - id: \(project.projectID) - images: \(project.projectImages.count)")
			
				cell.projectThumbTitle.text = project.projectTitle
				cell.projectThumbData.text = project.projectDate //project.projectExcerpt
			
				var imageWidth = CGFloat(375.0)
				var imageHeight = CGFloat(225.0)
			
				cell.projectThumbImage.moa.errorImage = UIImage(named: "placeholder-thumbnail-fullwidth-150x15")
				cell.projectThumbImage.image = UIImage(named: "placeholder-thumbnail-fullwidth-150x150")
			
				//if project.projectImages.count > 0 {
				
					if let test0 = project.featuredImage.first?.imageLargeWidth {
						print("project.featuredImage.imageFullURL: \(String(describing: project.featuredImage.first?.imageLargeURL))")

						cell.projectThumbImage.moa.url = project.featuredImage.first?.imageLargeURL

						imageWidth = CGFloat(truncating: NumberFormatter().number(from: (project.featuredImage.first?.imageLargeWidth)!)!)
						imageHeight = CGFloat(truncating: NumberFormatter().number(from: (project.featuredImage.first?.imageLargeHeight)!)!)

					} else if let test1 = project.projectImages.first?.imageWidth {
						print("project.projectImages.first?.url: \(String(describing: project.projectImages.first?.url))")

						cell.projectThumbImage.moa.url = project.projectImages.first?.url

						imageWidth = CGFloat(truncating: NumberFormatter().number(from: (project.projectImages.first?.imageWidth)!)!)
						imageHeight = CGFloat(truncating: NumberFormatter().number(from: (project.projectImages.first?.imageHeight)!)!)

					} else {
						print("generic image.")
						imageWidth = CGFloat(collectionView.bounds.size.width) - sectionInsets.left - sectionInsets.right
						imageHeight = CGFloat((imageWidth * 3) / 4)

					}
				
				//}
			
				let containerWidth = CGFloat(collectionView.bounds.size.width)
				let widthPerItem = containerWidth - sectionInsets.left - sectionInsets.right
				let heightPerItem = (widthPerItem * imageHeight) / imageWidth
			
				print("collectionView - cellForItemAt: width: \(widthPerItem) height: \(heightPerItem)")
			
				cell.projectThumbImage.sizeThatFits(CGSize(width: widthPerItem, height: heightPerItem))
				
			}
		
		}
		
		//cell.contentView.isHidden = false;
		//cell.contentView.alpha = 0
		
		//if projectsLoaded {
			//cell.contentView.isHidden = true;
			//UIView.animate(withDuration: 1.3, animations: {
				//cell.contentView.alpha = 1.0
			//})
		//}
		
		// Configure the cell
		return cell
		
	}
	
//	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		if projectsLoaded {
//			UIView.animate(withDuration: 0.8, animations: {
//				cell.contentView.alpha = 1.0
//			})
//		}
//	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//		let availableWidth = view.frame.width - paddingSpace
//		widthPerItem = availableWidth / itemsPerRow
//
//		let availableHeight = view.frame.height - paddingSpace
//		heightPerItem = availableHeight / itemsPerColumn
			
		// Set cell width to 100%
		let widthPerItem = collectionView.bounds.size.width - sectionInsets.left - sectionInsets.right // CGFloat(150.0)
		let heightPerItem = CGFloat(330.0)
		
		print("collectionView - sizeForItemAt: width: \(widthPerItem) height: \(heightPerItem)")

		return CGSize(width: widthPerItem, height: heightPerItem)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		print("collectionView - insetForSectionAt")

		return sectionInsets

	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

		print("collectionView - minimumLineSpacingForSectionAt")

		return sectionInsets.left

	}
	
	func loadProjects() {
		
		projectsLoaded = false
		
		print("loadProjects...")

		print("Getting project data...")
		getProjectData(url: postURL, parameters: ["":""])
		
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
	
	func getProjectFeatureImageData(url: String, parameters: [String : String], index: Int) {
		
		print("getProjectImagesData...")
		
		Alamofire.request(url, method: .get, parameters: parameters)
			.responseJSON { response in
				if response.result.isSuccess {
					
					print("Sucess! Got the projects data")
					let image : JSON = JSON(response.result.value!)
					
					self.updateProjectFeatureImageData(json: image, index: index)
					
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
			
			for proj in json {
				
				let project = proj.1
				
				if realm.objects(Project.self).filter("projectSlug CONTAINS %@", project["slug"].stringValue).count <= 0 {
					
					// newProject
					print("----\nnewProject = \(project["slug"].stringValue) (\(project["id"].stringValue))")
					
					let newProject = Project()
					newProject.projectID = project["id"].stringValue.decodingHTMLEntities()
					newProject.projectSlug = project["slug"].stringValue.decodingHTMLEntities()
					newProject.projectDate = project["date"].stringValue.decodingHTMLEntities()
					newProject.projectSelfJsonLink = project["_links"]["self"][0]["href"].stringValue.decodingHTMLEntities()
					newProject.projectURL = project["link"].stringValue.decodingHTMLEntities()
					newProject.projectContent = project["content"]["rendered"].stringValue.decodingHTMLEntities()
					newProject.projectTitle = project["title"]["rendered"].stringValue.decodingHTMLEntities().html2String
					newProject.projectExcerpt = project["excerpt"]["rendered"].stringValue.decodingHTMLEntities().html2String
					
					// SAVE TO REALM DB
					do {
						try realm.write {
							realm.add(newProject)
							
							// Retrieve project images from json
							let imagesURL = project["_links"]["wp:attachment"][0]["href"].stringValue
							print("imagesURL: \(imagesURL)")
							getProjectImagesData(url: imagesURL, parameters: ["" : ""], index: Int(index))
							
							// Retrieve project featured image from json
							let featuredImageURL = project["_links"]["wp:featuredmedia"][0]["href"].stringValue
							print("featuredImageURL: \(featuredImageURL)")
							getProjectFeatureImageData(url: featuredImageURL, parameters: ["" : ""], index: Int(index))
							
							projects = realm.objects(Project.self).sorted(byKeyPath: "projectDate", ascending: true) //selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
							print("Saved newProject \(project["title"]["rendered"].stringValue) (\(index)) info!")
						}
					} catch {
						print("Error saving done status for newProject, Error: \(error)")
					}
				
				} else {
					print("Could not find 'project[\"id\"].int'")
				}
				
				index = index + 1
			}
		
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
			
			if image["media_type"].stringValue == "image" {
			
				//print("\(image)\n---")
			
				projectImage["url"] = cleanUpURL(url: image["guid"]["rendered"].stringValue)
				projectImage["link"] = cleanUpURL(url: image["link"].stringValue)
				projectImage["title"] = image["title"]["rendered"].stringValue
				projectImage["slug"] = image["slug"].stringValue
				projectImage["mediaType"] = image["media_type"].stringValue
				projectImage["mimeType"] = image["mime_type"].stringValue
				projectImage["imageWidth"] = image["media_details"]["width"].stringValue
				projectImage["imageHeight"] = image["media_details"]["height"].stringValue
				projectImage["imageFile"] = image["media_details"]["height"].stringValue
			
				projectImage["imageThumbnailURL"] = cleanUpURL(url: image["media_details"]["sizes"]["thumbnail"]["source_url"].stringValue)
				projectImage["imageThumbnailWidth"] = image["media_details"]["sizes"]["thumbnail"]["width"].stringValue
				projectImage["imageThumbnailHeight"] = image["media_details"]["sizes"]["thumbnail"]["height"].stringValue
				projectImage["imageThumbnailMimeType"] = image["media_details"]["sizes"]["thumbnail"]["mime_type"].stringValue
			
				projectImage["imageMediumURL"] = cleanUpURL(url: image["media_details"]["sizes"]["medium"]["source_url"].stringValue)
				projectImage["imageMediumWidth"] = image["media_details"]["sizes"]["medium"]["width"].stringValue
				projectImage["imageMediumHeight"] = image["media_details"]["sizes"]["medium"]["height"].stringValue
				projectImage["imageMediumMimeType"] = image["media_details"]["sizes"]["medium"]["mime_type"].stringValue
			
				projectImage["imageLargeURL"] = cleanUpURL(url: image["media_details"]["sizes"]["large"]["source_url"].stringValue)
				projectImage["imageLargeWidth"] = image["media_details"]["sizes"]["large"]["width"].stringValue
				projectImage["imageLargeHeight"] = image["media_details"]["sizes"]["large"]["height"].stringValue
				projectImage["imageLargeMimeType"] = image["media_details"]["sizes"]["large"]["mime_type"].stringValue
			
				projectImage["imageFeatureURL"] = cleanUpURL(url: image["media_details"]["sizes"]["feature_image"]["source_url"].stringValue)
				projectImage["imageFeatureWidth"] = image["media_details"]["sizes"]["feature_image"]["width"].stringValue
				projectImage["imageFeatureHeight"] = image["media_details"]["sizes"]["feature_image"]["height"].stringValue
				projectImage["imageFeatureMimeType"] = image["media_details"]["sizes"]["feature_image"]["mime_type"].stringValue
			
				projectImage["imageFullURL"] = cleanUpURL(url: image["media_details"]["sizes"]["full"]["source_url"].stringValue)
				projectImage["imageFullWidth"] = image["media_details"]["sizes"]["full"]["width"].stringValue
				projectImage["imageFullHeight"] = image["media_details"]["sizes"]["full"]["height"].stringValue
				projectImage["imageFullMimeType"] = image["media_details"]["sizes"]["full"]["mime_type"].stringValue
			
				if let currentProject = projects?[index] {
					// SAVE TO REALM DB
					do {
						try realm.write {
							realm.add(projectImage)
							currentProject.projectImages.append(projectImage)
							print("Saved project image: \(String(describing: projectImage.slug))!")
						}
					} catch {
						print("Error saving images for currentProject, Error: \(error)")
					}
				}
			}
			
		} // end for
		
		collectionView?.reloadData()
		
	}
	
	func updateProjectFeatureImageData(json: JSON, index: Int) {
		print("----\n updateProjectFeatureImageData \(index)")
		print("currentProject: \(String(describing: projects?[index].projectSlug))")
		
		let image = json
			
		let featuredImage = ProjectImage()
			
		//if image["media_details"].count > 0 {
		if (image["guid"]["rendered"].stringValue != "") {
			print("image[\"guid\"][\"rendered\"].stringValue: \(image["guid"]["rendered"].stringValue) - exists: \(image["guid"]["rendered"].exists())")
			
			//print("\(image)\n---")
			
			featuredImage["url"] = cleanUpURL(url: image["guid"]["rendered"].stringValue)
			featuredImage["link"] = cleanUpURL(url: image["link"].stringValue)
			featuredImage["title"] = image["title"]["rendered"].stringValue
			featuredImage["slug"] = image["slug"].stringValue
			featuredImage["mediaType"] = image["media_type"].stringValue
			featuredImage["mimeType"] = image["mime_type"].stringValue
			featuredImage["imageWidth"] = image["media_details"]["width"].stringValue
			featuredImage["imageHeight"] = image["media_details"]["height"].stringValue
			featuredImage["imageFile"] = image["media_details"]["height"].stringValue
			
			featuredImage["imageThumbnailURL"] = cleanUpURL(url: image["media_details"]["sizes"]["thumbnail"]["source_url"].stringValue)
			featuredImage["imageThumbnailWidth"] = image["media_details"]["sizes"]["thumbnail"]["width"].stringValue
			featuredImage["imageThumbnailHeight"] = image["media_details"]["sizes"]["thumbnail"]["height"].stringValue
			featuredImage["imageThumbnailMimeType"] = image["media_details"]["sizes"]["thumbnail"]["mime_type"].stringValue
			
			featuredImage["imageMediumURL"] = cleanUpURL(url: image["media_details"]["sizes"]["medium"]["source_url"].stringValue)
			featuredImage["imageMediumWidth"] = image["media_details"]["sizes"]["medium"]["width"].stringValue
			featuredImage["imageMediumHeight"] = image["media_details"]["sizes"]["medium"]["height"].stringValue
			featuredImage["imageMediumMimeType"] = image["media_details"]["sizes"]["medium"]["mime_type"].stringValue
			
			featuredImage["imageLargeURL"] = cleanUpURL(url: image["media_details"]["sizes"]["large"]["source_url"].stringValue)
			featuredImage["imageLargeWidth"] = image["media_details"]["sizes"]["large"]["width"].stringValue
			featuredImage["imageLargeHeight"] = image["media_details"]["sizes"]["large"]["height"].stringValue
			featuredImage["imageLargeMimeType"] = image["media_details"]["sizes"]["large"]["mime_type"].stringValue
			
			featuredImage["imageFeatureURL"] = cleanUpURL(url: image["media_details"]["sizes"]["feature_image"]["source_url"].stringValue)
			featuredImage["imageFeatureWidth"] = image["media_details"]["sizes"]["feature_image"]["width"].stringValue
			featuredImage["imageFeatureHeight"] = image["media_details"]["sizes"]["feature_image"]["height"].stringValue
			featuredImage["imageFeatureMimeType"] = image["media_details"]["sizes"]["feature_image"]["mime_type"].stringValue
			
			featuredImage["imageFullURL"] = cleanUpURL(url: image["media_details"]["sizes"]["full"]["source_url"].stringValue)
			featuredImage["imageFullWidth"] = image["media_details"]["sizes"]["full"]["width"].stringValue
			featuredImage["imageFullHeight"] = image["media_details"]["sizes"]["full"]["height"].stringValue
			featuredImage["imageFullMimeType"] = image["media_details"]["sizes"]["full"]["mime_type"].stringValue
			
			if let currentProject = projects?[index] {
				// SAVE TO REALM DB
				do {
					try realm.write {
						realm.add(featuredImage)
						currentProject.featuredImage.append(featuredImage)
						print("Saved featured image: \(String(describing: featuredImage.slug))!")
					}
				} catch {
					print("Error saving images for currentProject, Error: \(error)")
				}
			} // end if
			
		} // end if
		
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
	
	
	//MARK: - Update Projects
	/***************************************************************/
	
	func updateUIWithProjectData() {
		
		print("========\n updateUIWithProjectData... \n========")
		
		projects = realm.objects(Project.self).sorted(byKeyPath: "projectDate", ascending: false)
		
		projectsLoaded = true
		
		collectionView?.reloadData()
	}
	
}

func cleanUpURL(url: String) -> String {
	var replaceURL:String = url
	replaceURL = replaceURL.replacingOccurrences(of: "http://", with: "https://")
	replaceURL = replaceURL.replacingOccurrences(of: "frwrdnet.webfactional.com", with: "victorzambrano.com")
	replaceURL = replaceURL.replacingOccurrences(of: "frwrd.net", with: "victorzambrano.com")
	return replaceURL
}

// MARK: - Extensions

extension Data {
	var html2AttributedString: NSAttributedString? {
		do {
			return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch {
			print("error:", error)
			return  nil
		}
	}
	var html2String: String {
		return html2AttributedString?.string ?? ""
	}
}

extension String {
	var html2AttributedString: NSAttributedString? {
		return Data(utf8).html2AttributedString
	}
	var html2String: String {
		return html2AttributedString?.string ?? ""
	}
}

// Swift 4
// Check out the history for contributions and acknowledgements.
extension String {
	/// Returns a new string made by replacing all HTML character entity references with the corresponding character.
	///
	/// - Returns: decoded string
	func decodingHTMLEntities() -> String {
		var result = String()
		var position = startIndex
		
		// Get the range to the next '&'
		while let ampRange = range(of: "&", range: position ..< endIndex) {
			result += self[position ..< ampRange.lowerBound]
			position = ampRange.lowerBound
			
			// Get the range to the next ';'
			if let semiRange = range(of: ";", range: position ..< endIndex ) {
				if let nextAmpRange = range(of: "&", range: index(position, offsetBy: 1) ..< endIndex ),
					nextAmpRange.upperBound < semiRange.upperBound {
					// We have an other "&" before the next ";", let's add it and step over.
					result += "&"
					position = index(ampRange.lowerBound, offsetBy: 1)
				} else {
					let entity = String(self[position ..< semiRange.upperBound])
					if let decoded = decode(entity: entity) {
						// Add the decoded character.
						result.append(decoded)
					} else {
						// Character wasn't decoded, append the entry.
						result += entity
					}
					position = semiRange.upperBound
				}
			} else {
				// No remaining ';'.
				break
			}
		}
		
		// Add remaining characters.
		result += self[position ..< endIndex]
		return result
	}
}

private extension String {
	
	/// Convert the numeric value to the corresponding Unicode character
	///    e.g.
	///    decodeNumeric("64", 10) -> "@"
	///    decodeNumeric("20ac", 16) -> "€"
	///
	/// - Parameters:
	///   - string: the string to decode
	///   - base: base value of the integer
	/// - Returns: the resulting character
	func decodeNumeric(string: String, base: Int32) -> Character? {
		let code = UInt32(strtoul(string, nil, base))
		if let unicodeScalar = UnicodeScalar(code) {
			return Character(unicodeScalar)
		}
		return nil
	}
	
	/// Decode the HTML character entity to the corresponding
	/// Unicode character, return `nil` for invalid input.
	///     decode("&#64;")    -> "@"
	///     decode("&#x20ac;") -> "€"
	///     decode("&lt;")     -> "<"
	///     decode("&foo;")    -> nil
	///
	/// - Parameter entity: The entity reference
	/// - Returns: the resulting character
	func decode(entity: String) -> Character? {
		if let character = String.characterEntities[entity] {
			return character
		} else if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
			let number = String(entity[entity.index(entity.startIndex, offsetBy: 3)...].dropLast())
			return decodeNumeric(string: number, base: 16)
		} else if entity.hasPrefix("&#") {
			let number = String(entity[entity.index(entity.startIndex, offsetBy: 2)...].dropLast())
			return decodeNumeric(string: number, base: 10)
		} else {
			return nil
		}
	}
	
	// Mapping from XML/HTML character entity reference to character
	static let characterEntities: [String: Character] = [
		// Taken from http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
		// Complete refrence here https://www.w3.org/TR/xml-entity-names/
		"&quot;": "\u{0022}",
		"&amp;": "\u{0026}",
		"&apos;": "\u{0027}",
		"&lt;": "\u{003C}",
		"&gt;": "\u{003E}",
		"&nbsp;": "\u{00A0}",
		"&iexcl;": "\u{00A1}",
		"&cent;": "\u{00A2}",
		"&pound;": "\u{00A3}",
		"&curren;": "\u{00A4}",
		"&yen;": "\u{00A5}",
		"&brvbar;": "\u{00A6}",
		"&sect;": "\u{00A7}",
		"&uml;": "\u{00A8}",
		"&copy;": "\u{00A9}",
		"&ordf;": "\u{00AA}",
		"&laquo;": "\u{00AB}",
		"&not;": "\u{00AC}",
		"&shy;": "\u{00AD}",
		"&reg;": "\u{00AE}",
		"&macr;": "\u{00AF}",
		"&deg;": "\u{00B0}",
		"&plusmn;": "\u{00B1}",
		"&sup2;": "\u{00B2}",
		"&sup3;": "\u{00B3}",
		"&acute;": "\u{00B4}",
		"&micro;": "\u{00B5}",
		"&para;": "\u{00B6}",
		"&middot;": "\u{00B7}",
		"&cedil;": "\u{00B8}",
		"&sup1;": "\u{00B9}",
		"&ordm;": "\u{00BA}",
		"&raquo;": "\u{00BB}",
		"&frac14;": "\u{00BC}",
		"&frac12;": "\u{00BD}",
		"&frac34;": "\u{00BE}",
		"&iquest;": "\u{00BF}",
		"&Agrave;": "\u{00C0}",
		"&Aacute;": "\u{00C1}",
		"&Acirc;": "\u{00C2}",
		"&Atilde;": "\u{00C3}",
		"&Auml;": "\u{00C4}",
		"&Aring;": "\u{00C5}",
		"&AElig;": "\u{00C6}",
		"&Ccedil;": "\u{00C7}",
		"&Egrave;": "\u{00C8}",
		"&Eacute;": "\u{00C9}",
		"&Ecirc;": "\u{00CA}",
		"&Euml;": "\u{00CB}",
		"&Igrave;": "\u{00CC}",
		"&Iacute;": "\u{00CD}",
		"&Icirc;": "\u{00CE}",
		"&Iuml;": "\u{00CF}",
		"&ETH;": "\u{00D0}",
		"&Ntilde;": "\u{00D1}",
		"&Ograve;": "\u{00D2}",
		"&Oacute;": "\u{00D3}",
		"&Ocirc;": "\u{00D4}",
		"&Otilde;": "\u{00D5}",
		"&Ouml;": "\u{00D6}",
		"&times;": "\u{00D7}",
		"&Oslash;": "\u{00D8}",
		"&Ugrave;": "\u{00D9}",
		"&Uacute;": "\u{00DA}",
		"&Ucirc;": "\u{00DB}",
		"&Uuml;": "\u{00DC}",
		"&Yacute;": "\u{00DD}",
		"&THORN;": "\u{00DE}",
		"&szlig;": "\u{00DF}",
		"&agrave;": "\u{00E0}",
		"&aacute;": "\u{00E1}",
		"&acirc;": "\u{00E2}",
		"&atilde;": "\u{00E3}",
		"&auml;": "\u{00E4}",
		"&aring;": "\u{00E5}",
		"&aelig;": "\u{00E6}",
		"&ccedil;": "\u{00E7}",
		"&egrave;": "\u{00E8}",
		"&eacute;": "\u{00E9}",
		"&ecirc;": "\u{00EA}",
		"&euml;": "\u{00EB}",
		"&igrave;": "\u{00EC}",
		"&iacute;": "\u{00ED}",
		"&icirc;": "\u{00EE}",
		"&iuml;": "\u{00EF}",
		"&eth;": "\u{00F0}",
		"&ntilde;": "\u{00F1}",
		"&ograve;": "\u{00F2}",
		"&oacute;": "\u{00F3}",
		"&ocirc;": "\u{00F4}",
		"&otilde;": "\u{00F5}",
		"&ouml;": "\u{00F6}",
		"&divide;": "\u{00F7}",
		"&oslash;": "\u{00F8}",
		"&ugrave;": "\u{00F9}",
		"&uacute;": "\u{00FA}",
		"&ucirc;": "\u{00FB}",
		"&uuml;": "\u{00FC}",
		"&yacute;": "\u{00FD}",
		"&thorn;": "\u{00FE}",
		"&yuml;": "\u{00FF}",
		"&OElig;": "\u{0152}",
		"&oelig;": "\u{0153}",
		"&Scaron;": "\u{0160}",
		"&scaron;": "\u{0161}",
		"&Yuml;": "\u{0178}",
		"&fnof;": "\u{0192}",
		"&circ;": "\u{02C6}",
		"&tilde;": "\u{02DC}",
		"&Alpha;": "\u{0391}",
		"&Beta;": "\u{0392}",
		"&Gamma;": "\u{0393}",
		"&Delta;": "\u{0394}",
		"&Epsilon;": "\u{0395}",
		"&Zeta;": "\u{0396}",
		"&Eta;": "\u{0397}",
		"&Theta;": "\u{0398}",
		"&Iota;": "\u{0399}",
		"&Kappa;": "\u{039A}",
		"&Lambda;": "\u{039B}",
		"&Mu;": "\u{039C}",
		"&Nu;": "\u{039D}",
		"&Xi;": "\u{039E}",
		"&Omicron;": "\u{039F}",
		"&Pi;": "\u{03A0}",
		"&Rho;": "\u{03A1}",
		"&Sigma;": "\u{03A3}",
		"&Tau;": "\u{03A4}",
		"&Upsilon;": "\u{03A5}",
		"&Phi;": "\u{03A6}",
		"&Chi;": "\u{03A7}",
		"&Psi;": "\u{03A8}",
		"&Omega;": "\u{03A9}",
		"&alpha;": "\u{03B1}",
		"&beta;": "\u{03B2}",
		"&gamma;": "\u{03B3}",
		"&delta;": "\u{03B4}",
		"&epsilon;": "\u{03B5}",
		"&zeta;": "\u{03B6}",
		"&eta;": "\u{03B7}",
		"&theta;": "\u{03B8}",
		"&iota;": "\u{03B9}",
		"&kappa;": "\u{03BA}",
		"&lambda;": "\u{03BB}",
		"&mu;": "\u{03BC}",
		"&nu;": "\u{03BD}",
		"&xi;": "\u{03BE}",
		"&omicron;": "\u{03BF}",
		"&pi;": "\u{03C0}",
		"&rho;": "\u{03C1}",
		"&sigmaf;": "\u{03C2}",
		"&sigma;": "\u{03C3}",
		"&tau;": "\u{03C4}",
		"&upsilon;": "\u{03C5}",
		"&phi;": "\u{03C6}",
		"&chi;": "\u{03C7}",
		"&psi;": "\u{03C8}",
		"&omega;": "\u{03C9}",
		"&thetasym;": "\u{03D1}",
		"&upsih;": "\u{03D2}",
		"&piv;": "\u{03D6}",
		"&ensp;": "\u{2002}",
		"&emsp;": "\u{2003}",
		"&thinsp;": "\u{2009}",
		"&zwnj;": "\u{200C}",
		"&zwj;": "\u{200D}",
		"&lrm;": "\u{200E}",
		"&rlm;": "\u{200F}",
		"&ndash;": "\u{2013}",
		"&mdash;": "\u{2014}",
		"&lsquo;": "\u{2018}",
		"&rsquo;": "\u{2019}",
		"&sbquo;": "\u{201A}",
		"&ldquo;": "\u{201C}",
		"&rdquo;": "\u{201D}",
		"&bdquo;": "\u{201E}",
		"&dagger;": "\u{2020}",
		"&Dagger;": "\u{2021}",
		"&bull;": "\u{2022}",
		"&hellip;": "\u{2026}",
		"&permil;": "\u{2030}",
		"&prime;": "\u{2032}",
		"&Prime;": "\u{2033}",
		"&lsaquo;": "\u{2039}",
		"&rsaquo;": "\u{203A}",
		"&oline;": "\u{203E}",
		"&frasl;": "\u{2044}",
		"&euro;": "\u{20AC}",
		"&image;": "\u{2111}",
		"&weierp;": "\u{2118}",
		"&real;": "\u{211C}",
		"&trade;": "\u{2122}",
		"&alefsym;": "\u{2135}",
		"&larr;": "\u{2190}",
		"&uarr;": "\u{2191}",
		"&rarr;": "\u{2192}",
		"&darr;": "\u{2193}",
		"&harr;": "\u{2194}",
		"&crarr;": "\u{21B5}",
		"&lArr;": "\u{21D0}",
		"&uArr;": "\u{21D1}",
		"&rArr;": "\u{21D2}",
		"&dArr;": "\u{21D3}",
		"&hArr;": "\u{21D4}",
		"&forall;": "\u{2200}",
		"&part;": "\u{2202}",
		"&exist;": "\u{2203}",
		"&empty;": "\u{2205}",
		"&nabla;": "\u{2207}",
		"&isin;": "\u{2208}",
		"&notin;": "\u{2209}",
		"&ni;": "\u{220B}",
		"&prod;": "\u{220F}",
		"&sum;": "\u{2211}",
		"&minus;": "\u{2212}",
		"&lowast;": "\u{2217}",
		"&radic;": "\u{221A}",
		"&prop;": "\u{221D}",
		"&infin;": "\u{221E}",
		"&ang;": "\u{2220}",
		"&and;": "\u{2227}",
		"&or;": "\u{2228}",
		"&cap;": "\u{2229}",
		"&cup;": "\u{222A}",
		"&int;": "\u{222B}",
		"&there4;": "\u{2234}",
		"&sim;": "\u{223C}",
		"&cong;": "\u{2245}",
		"&asymp;": "\u{2248}",
		"&ne;": "\u{2260}",
		"&equiv;": "\u{2261}",
		"&le;": "\u{2264}",
		"&ge;": "\u{2265}",
		"&sub;": "\u{2282}",
		"&sup;": "\u{2283}",
		"&nsub;": "\u{2284}",
		"&sube;": "\u{2286}",
		"&supe;": "\u{2287}",
		"&oplus;": "\u{2295}",
		"&otimes;": "\u{2297}",
		"&perp;": "\u{22A5}",
		"&sdot;": "\u{22C5}",
		"&lceil;": "\u{2308}",
		"&rceil;": "\u{2309}",
		"&lfloor;": "\u{230A}",
		"&rfloor;": "\u{230B}",
		"&lang;": "\u{2329}",
		"&rang;": "\u{232A}",
		"&loz;": "\u{25CA}",
		"&spades;": "\u{2660}",
		"&clubs;": "\u{2663}",
		"&hearts;": "\u{2665}",
		"&diams;": "\u{2666}",
		
		// Special cases from Windows-1252. https://en.wikipedia.org/wiki/Windows-1252
		"&#128;": "\u{20AC}",
		"&#130;": "\u{201A}",
		"&#131;": "\u{0192}",
		"&#132;": "\u{201E}",
		"&#133;": "\u{2026}",
		"&#134;": "\u{2020}",
		"&#135;": "\u{2021}",
		"&#136;": "\u{02C6}",
		"&#138;": "\u{0160}",
		"&#139;": "\u{2039}",
		"&#140;": "\u{0152}",
		"&#142;": "\u{017D}",
		"&#145;": "\u{2018}",
		"&#146;": "\u{2019}",
		"&#147;": "\u{201C}",
		"&#148;": "\u{201D}",
		"&#149;": "\u{2022}",
		"&#150;": "\u{2013}",
		"&#151;": "\u{2014}",
		"&#152;": "\u{02DC}",
		"&#153;": "\u{2122}",
		"&#154;": "\u{0161}",
		"&#155;": "\u{203A}",
		"&#156;": "\u{0153}",
		"&#158;": "\u{017E}",
		"&#159;": "\u{0178}"
	]
}

// MARK: - Private
private extension CollectionViewController {
	func projectForIndexPath(_ indexPath: IndexPath) -> Project {
		return projects![indexPath.item]
	}
}
