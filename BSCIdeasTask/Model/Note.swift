//
//  Note.swift
//  BSCIdeasTask
//
//  Created by Radek Zmeskal on 25/05/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import SwiftyJSON

class Note: NSObject {
    
    let id: Int
    var title: String
    
    init(id: Int, title: String ) {
        self.id = id;
        self.title = title
    }
    
    init(json: [String: Any] ) {
        let jsonData = JSON(json)
        self.id = jsonData["id"].intValue
        if let title = jsonData["title"].string {
            self.title = title
        } else {
            self.title = ""
        }
    }
}
