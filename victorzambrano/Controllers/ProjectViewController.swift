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
	
	var selectedProject: Project?
	var selectedImage: ProjectImage?
	
	let reuseIdentifier = "pictureCell"
	let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
	let tableRowHeight = 340.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		imageTableView.rowHeight = CGFloat(81.0)
		//imageTableView.estimatedRowHeight = 50.0
		//imageTableView.rowHeight = UITableViewAutomaticDimension
		//imageTableView.separatorColor = UIColor.clear
		
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
		let title = selectedProject?.projectTitle ?? "Project Title"
		let date = selectedProject?.projectDate ?? "Project Date"
		let desc = selectedProject?.projectExcerpt ?? "Project Excerpt"
		
		print("title: \(title)")
		print("date: \(date)")
		print("desc: \(desc)")
		
		projectPageTitle.text = title
		projectPageData.text = formatDate(date: date)
		projectPageDescription.text = desc
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("numberOfRowsInSection")
		return selectedProject?.projectImages.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageCell
		
		// load placeholder image
		cell.imageCellImage?.image = UIImage(named: "placeholder-thumbnail-fullwidth")
		
		// load image title
		cell.imageCellTitle.text = selectedProject?.projectImages[indexPath.row].title ?? "Image Name"
		
		// set image let
		let image = selectedProject?.projectImages[indexPath.row]
		
		// if image
		if image?.imageProjectURL != "" {
			
			// load image (async)
			cell.imageCellImage?.moa.errorImage = UIImage(named: "placeholder-thumbnail-fullwidth")
			cell.imageCellImage?.moa.url = image?.imageProjectURL
			
		} else {
			
			cell.imageCellImage?.image = UIImage(named: "placeholder-thumbnail-fullwidth")
			
		}
		
		// resize project image to its orig size
		//cell.imageCellImage.sizeThatFits(CGSize(width: 480.0, height: 240.0))
		
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
