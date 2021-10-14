//
//  Folders.swift
//  Memo
//
//  Created by Jared Juangco on 14/10/21.
//

import Foundation
import RealmSwift

class Folder: Object {
    @objc dynamic var title : String = ""
    
    let noteItems = List<NoteItem>()
    
}
