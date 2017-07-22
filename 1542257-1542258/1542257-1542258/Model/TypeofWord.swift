//
//  TypeofWord.swift
//  1542257-1542258
//
//  Created by Phu on 5/16/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation

class TypeofWord {
    
    private var _id: Int64!
    private var _name_en: String!
    private var _name_vn: String!
    
    var id: Int64 {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var name_en: String {
        get {
            return _name_en
        }
        set {
            _name_en = newValue
        }
    }
    
    var name_vn: String {
        get {
            return _name_vn
        }
        set {
            _name_vn = newValue
        }
    }
    
    init(id: Int64, name_en: String, name_vn: String) {
        _id = id
        _name_en = name_en
        _name_vn = name_vn
    }
}
