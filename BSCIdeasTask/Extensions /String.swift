//
//  String.swift
//  BSCIdeasTask
//
//  Created by Radek Zmeskal on 27/05/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
