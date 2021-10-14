//
//  Item.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import Foundation
import RealmSwift

class NoteItem: Object {
    @objc dynamic var text : String = ""
    @objc dynamic var title : String = ""
    
}
