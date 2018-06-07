//
//  ProjectImages.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/5/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectImages: Object {
	@objc dynamic var url = ""
	@objc dynamic var link = ""
	@objc dynamic var title = ""
	@objc dynamic var slug = ""
	@objc dynamic var mediaType = ""
	@objc dynamic var mimeType = ""
	@objc dynamic var imageFile = ""
	@objc dynamic var imageWidth = ""
	@objc dynamic var imageHeight = ""
	@objc dynamic var imageSizeThumbnail = ""
	@objc dynamic var imageSizeThumbnailWidth = ""
	@objc dynamic var imageSizeThumbnailHeight = ""
	@objc dynamic var imageSizeThumbnailMimeType = ""
	@objc dynamic var imageSizeMedium = ""
	@objc dynamic var imageSizeMediumWidth = ""
	@objc dynamic var imageSizeMediumHeight = ""
	@objc dynamic var imageSizeMediumMimeType = ""
	@objc dynamic var imageSizeLarge = ""
	@objc dynamic var imageSizeLargeWidth = ""
	@objc dynamic var imageSizeLargeHeight = ""
	@objc dynamic var imageSizeLargeMimeType = ""
	@objc dynamic var imageSizeFeature = ""
	@objc dynamic var imageSizeFeatureWidth = ""
	@objc dynamic var imageSizeFeatureHeight = ""
	@objc dynamic var imageSizeFeatureMimeType = ""
	@objc dynamic var imageSizeFull = ""
	@objc dynamic var imageSizeFullWidth = ""
	@objc dynamic var imageSizeFullHeight = ""
	@objc dynamic var imageSizeFullMimeType = ""
}
