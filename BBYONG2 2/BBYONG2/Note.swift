//
//  Note.swift
//  BBYONG
//
//  Created by yuseong on 8/10/24.
//

import Foundation

class Note: Identifiable {
    let id: UUID
    var title : String
    var description : String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.description = ""
    }
}
