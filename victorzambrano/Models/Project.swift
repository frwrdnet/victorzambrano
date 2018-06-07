//
//  Project.swift
//  victorzambrano
//
//  Created by Victor Zambrano on 6/4/18.
//  Copyright © 2018 Victor Zambrano. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Project: Object {
	@objc dynamic var projectID = "" 						// project.id
	@objc dynamic var projectSlug = "" 					// project.slug
	@objc dynamic var projectDate = "" 					// project.date
	@objc dynamic var projectSelfJsonLink = "" 			// project._links.self.href
	@objc dynamic var projectURL = ""						// project.link  ////project.guid.rendered
	@objc dynamic var projectContent = ""					// project.content.rendered
	@objc dynamic var projectTitle = ""					// project.title.rendered
	@objc dynamic var projectExcerpt = ""					// project.excerpt.rendered
	var projectImages = ProjectImages()
}
