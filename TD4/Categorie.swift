//
//  Categorie.swift
//  TD4
//
//  Created by GELE Axel on 30/01/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import Foundation

class Categorie {
    var sort : Int
    var name : String
    var elementList = [Element]()
    
    init (sort : Int, name : String){
        self.sort = sort
        self.name = name
    }
}
