//
//  ProjectViewController.swift
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
import Auk

class ProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
	
	//let realm = try! Realm()
	
	//var projects: Results<Project>?
	//var projectsLoaded = false
	
	var selectedProject: Project?
	var selectedImage: ProjectImage?
	
	let reuseIdentifier = "pictureCell"
	let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
	let tableRowHeight = 340.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		imageTableView.rowHeight = CGFloat(tableRowHeight)
		
		showProject()
		
		imageTableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// what to do exactly when the view is about to be shown
		if (navigationController?.navigationBar) != nil {
			//navBar.barTintColor = UIColor.lightGray
			
			//title = selectedProject?.projectTitle ?? "Project"
			title = "Project"
			
			//imageTableView.reloadData()
		}
	}
	
	@IBOutlet weak var projectPageTitle: UILabel!
	@IBOutlet weak var projectPageData: UILabel!
	@IBOutlet weak var projectPageDescription: UITextView!
	//@IBOutlet weak var projectPageScroller: UIScrollView!
	@IBOutlet weak var imageTableView: UITableView!
	
	
	@IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: "openImageViewer", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! ImageViewerViewController

		if let viewImage = selectedImage {
			destinationVC.selectedImage = viewImage
		}
	}
	
	func loadProject() {
		// load project data model
	}
	
	func showProject() {
		// show project data model
		
		//projectPageScroller.auk.settings.preloadRemoteImagesAround = 1
		
		projectPageTitle.text = selectedProject?.projectTitle ?? "Project Title"
		projectPageData.text = selectedProject?.projectDate ?? "Project Date"
		projectPageDescription.text = selectedProject?.projectExcerpt ?? "Project Excerpt"
		
//		if let images = selectedProject?.projectImages {
//			for image in images {
				//projectPageScroller.auk.show(url: image.imageLargeURL!, accessibilityLabel: image.title)
//			}
//		}
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("numberOfRowsInSection")
		return selectedProject?.projectImages.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageCell
		
		cell.imageCellTitle.text = selectedProject?.projectImages[indexPath.row].title ?? "Image Name"
		
		cell.imageCellImage?.image = UIImage(named: "placeholder-thumbnail-fullwidth")
		cell.imageCellImage?.moa.url = selectedProject?.projectImages[indexPath.row].imageLargeURL
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		print("willDisplay: \(indexPath.row)")
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedImage = selectedProject?.projectImages[indexPath.row]
		performSegue(withIdentifier: "openImageViewer", sender: self)
	}
}
