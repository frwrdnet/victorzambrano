//
//  ImageViewerViewController.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/12/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import UIKit
import moa
import Auk

class ImageViewerViewController: UIViewController {
	
	var selectedImage: ProjectImage?
	var selectedIndex: IndexPath?
	
	@IBOutlet weak var viewerImage: UIImageView!
	@IBOutlet weak var viewerImageTitle: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		showImage()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// what to do exactly when the view is about to be shown
		if (navigationController?.navigationBar) != nil {
			title = selectedImage?.title ?? "Image Viewer"
		}
	}
	
	func showImage() {
		if let t = selectedImage?.title {
			viewerImageTitle.text = t
		}
		viewerImage.moa.errorImage = UIImage(named: "placeholder-thumbnail-fullwidth")
		viewerImage.moa.url = selectedImage?.imageFullURL
	}
}
