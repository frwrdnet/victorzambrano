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

class ProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
	
	//let realm = try! Realm()
	
	//var projects: Results<Project>?
	//var projectsLoaded = false
	
	var selectedProject: Project?
	
	let reuseIdentifier = "pictureCell"
	let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		showProject()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// what to do exactly when the view is about to be shown
		if (navigationController?.navigationBar) != nil {
			//navBar.barTintColor = UIColor.lightGray
			
			title = selectedProject?.projectTitle ?? "Project"
		}
	}

	@IBOutlet weak var projectPageTitle: UILabel!
	@IBOutlet weak var projectPageData: UILabel!
	@IBOutlet weak var projectPageDescription: UITextView!
	@IBOutlet weak var projectPageScroller: UIScrollView!
	
	@IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
		performSegue(withIdentifier: "openImageViewer", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! ImageViewerViewController
		
		if let indexPath = projectPageScroller.auk.currentPageIndex {
			destinationVC.selectedImage = selectedProject?.projectImages[indexPath]
		}
	}
	
	func loadProject() {
		// load project data model
	}
	
	func showProject() {
		// show project data model
		
		projectPageScroller.auk.settings.preloadRemoteImagesAround = 1
		
		projectPageTitle.text = selectedProject?.projectTitle ?? "Project Title"
		projectPageData.text = selectedProject?.projectDate ?? "Project Date"
		projectPageDescription.text = selectedProject?.projectExcerpt ?? "Project Excerpt"
		
		/*
		Here is what you need to do to add an image tap handler to the scroll view.
		• In the Storyboard drag a Tap Gesture Recognizer into your scroll view.
		• Show assistant editor with your view controller code.
		• Do the control-drag from the tap gesture recognizer in the storyboard into your view controller code.
		• A dialog will appear, change the Connection to action and enter the name of the method.
		•  This method will be called when the scroll view is tapped. Use the auk.currentPageIndex property of your scroll view to get the index of the current page.
		*/
		if let images = selectedProject?.projectImages {
			for image in images {
				projectPageScroller.auk.show(url: image.imageLargeURL!, accessibilityLabel: image.title)
			}
		}
	}
}
