//
//  DataItem.swift
//  TableViewDemo
//
//  Created by Shawn Pellacani on 24/10/2016.
//  Copyright © 2016 Shawn Pellacani. All rights reserved.
//

import UIKit

class DataItem {
    var title: String
    var subtitle: String
    var image: UIImage?
    
    init(title: String, subtitle: String, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        if let imageName = imageName {
            if let img = UIImage(named: imageName) {
                image = img
            }
        }
    }
}
