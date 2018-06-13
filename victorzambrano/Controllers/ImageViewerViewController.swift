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
		// Do any additional setup after loading the view, typically from a nib.
		
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
		
		if let w = selectedImage?.imageWidth {
			if let h = selectedImage?.imageHeight {
				viewerImage.moa.url = selectedImage?.imageFullURL
				
//				let imageWidth = CGFloat(truncating: NumberFormatter().number(from: (selectedImage?.imageWidth)!)!)
//				let imageHeight = CGFloat(truncating: NumberFormatter().number(from: (selectedImage?.imageHeight)!)!)
//				
//				let widthPerItem = CGFloat(viewerImage.bounds.size.width)
//				let heightPerItem = (widthPerItem * imageHeight) / imageWidth
//				
//				print("viewerImage: width: \(widthPerItem) height: \(heightPerItem)")
//				
//				viewerImage.sizeThatFits(CGSize(width: widthPerItem, height: heightPerItem))
			}
		}
	}
}
