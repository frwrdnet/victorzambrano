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
		
		//imageTableView.rowHeight = CGFloat(tableRowHeight)
		imageTableView.estimatedRowHeight = 50.0
		imageTableView.rowHeight = UITableViewAutomaticDimension
		imageTableView.separatorColor = UIColor.clear
		
		showProject()
		
		imageTableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// what to do exactly when the view is about to be shown
		if (navigationController?.navigationBar) != nil {
			
			//title = selectedProject?.projectTitle ?? "Project"
			title = "Project"
		}
	}
	
	@IBOutlet weak var projectPageTitle: UILabel!
	@IBOutlet weak var projectPageData: UILabel!
	@IBOutlet weak var projectPageDescription: UITextView!
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
		
		projectPageTitle.text = selectedProject?.projectTitle ?? "Project Title"
		projectPageData.text = selectedProject?.projectDate ?? "Project Date"
		projectPageDescription.text = selectedProject?.projectExcerpt ?? "Project Excerpt"
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("numberOfRowsInSection")
		return selectedProject?.projectImages.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageCell
		
		cell.imageCellTitle.text = "" //selectedProject?.projectImages[indexPath.row].title ?? "Image Name"
		
		cell.imageCellImage?.image = UIImage(named: "placeholder-thumbnail-fullwidth")
		cell.imageCellImage?.moa.url = selectedProject?.projectImages[indexPath.row].imageLargeURL
		
		// resize image to fit cell
		let imageWidth = CGFloat(truncating: NumberFormatter().number(from: (selectedProject?.projectImages[indexPath.row].imageLargeWidth)!)!)
		let imageHeight = CGFloat(truncating: NumberFormatter().number(from: (selectedProject?.projectImages[indexPath.row].imageLargeHeight)!)!)

		let widthPerItem = CGFloat(imageTableView.bounds.size.width)
		let heightPerItem = (widthPerItem * imageHeight) / imageWidth
	
		cell.imageCellImage.sizeThatFits(CGSize(width: widthPerItem, height: heightPerItem))
		
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
