//
//  Vocabulary.swift
//  1542257-1542258
//
//  Created by Phu on 5/16/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation

class Vocabulary {
    
    private var _id: Int64!
    private var _cat_id: Int64!
    private var _type_id: Int64?
    private var _name_en: String!
    private var _name_vn: String!
    private var _pronunciation: String?
    private var _example: String?
    private var _image: String?
    private var _status: Bool!
    private var _created: String!
    
    var id: Int64 {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var cat_id: Int64 {
        get {
            return _cat_id
        }
        set {
            _cat_id = newValue
        }
    }
    
    var type_id: Int64? {
        get {
            return _type_id
        }
        set {
            _type_id = newValue
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
    
    var pronunciation: String? {
        get {
            return _pronunciation
        }
        set {
            _pronunciation = newValue
        }
    }
    
    var example: String? {
        get {
            return _example
        }
        set {
            _example = newValue
        }
    }
    
    var image: String? {
        get {
            return _image
        }
        set {
            _image = newValue
        }
    }
    
    var status: Bool {
        get {
            return _status
        }
        set {
            _status = newValue
        }
    }
    
    var created: String {
        get {
            return _created
        }
        set {
            _created = newValue
        }
    }
    
    init(id: Int64, cat_id: Int64, type_id: Int64?, name_en: String, name_vn: String, pronunciation: String?, example: String?, image: String?, status: Bool, created: String) {
        _id = id
        _cat_id = cat_id
        _type_id = type_id
        _name_en = name_en
        _name_vn = name_vn
        _pronunciation = pronunciation
        _example = example
        _image = image
        _status = status
        _created = created
    }
    
}
