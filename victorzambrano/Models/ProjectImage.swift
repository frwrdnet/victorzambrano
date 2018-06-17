//
//  ProjectImage.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/5/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectImage: Object {
	@objc dynamic var url: String?
	@objc dynamic var link: String?
	@objc dynamic var title: String?
	@objc dynamic var slug: String?
	
	@objc dynamic var mediaType: String?
	@objc dynamic var mimeType: String?
	
	@objc dynamic var imageFile: String?
	@objc dynamic var imageWidth: String?
	@objc dynamic var imageHeight: String?
	
	@objc dynamic var imageThumbnailURL: String?
	@objc dynamic var imageThumbnailWidth: String?
	@objc dynamic var imageThumbnailHeight: String?
	@objc dynamic var imageThumbnailMimeType: String?
	
	@objc dynamic var imageMediumURL: String?
	@objc dynamic var imageMediumWidth: String?
	@objc dynamic var imageMediumHeight: String?
	@objc dynamic var imageMediumMimeType: String?
	
	@objc dynamic var imageLargeURL: String?
	@objc dynamic var imageLargeWidth: String?
	@objc dynamic var imageLargeHeight: String?
	@objc dynamic var imageLargeMimeType: String?
	
	@objc dynamic var imageProjectURL: String?
	@objc dynamic var imageProjectWidth: String?
	@objc dynamic var imageProjectHeight: String?
	@objc dynamic var imageProjectMimeType: String?
	
	@objc dynamic var imageFeatureURL: String?
	@objc dynamic var imageFeatureWidth: String?
	@objc dynamic var imageFeatureHeight: String?
	@objc dynamic var imageFeatureMimeType: String?
	
	@objc dynamic var imageFullURL: String?
	@objc dynamic var imageFullWidth: String?
	@objc dynamic var imageFullHeight: String?
	@objc dynamic var imageFullMimeType: String?
}
