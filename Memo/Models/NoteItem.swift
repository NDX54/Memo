//
//  Item.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import Foundation
import RealmSwift

class NoteItem: Object {
    @objc dynamic var noteTextContent : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var id : UUID?
    @objc dynamic var dateCreated : Date = Date()
    
    var parentFolder = LinkingObjects(fromType: Folder.self, property: K.Persistence.noteItems)
}
