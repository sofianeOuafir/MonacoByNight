//
//  Element.swift
//  TD4
//
//  Created by GELE Axel on 30/01/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import Foundation

class Element {
    
    var name : String
    var image : URL
    var description : String
    var image_large : String
    
    init (name : String, image : URL, description : String, image_large : String){
        self.name = name
        self.image = image
        self.description = description
        self.image_large = image_large
    }
    
}
