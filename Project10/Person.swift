//
//  Person.swift
//  Project10
//
//  Created by Mehmet Can Şimşek on 29.06.2022.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
