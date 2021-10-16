//
//  Constants.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import Foundation

struct K {
    static let itemCellIdentifier = "itemCellIdentifier"
    static let folderCellIdentifier = "folderCellIdentifier"
    
    struct Segues {
        static let goToTextEditView = "goToTextEditView"
        static let goInsideSelectedFolder = "goInsideSelectedFolder"
    }
    
    struct Persistence {
        static let noteItems = "noteItems"
        static let textContent = "textContent"
        
    }
}
