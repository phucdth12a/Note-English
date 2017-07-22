//
//  Report.swift
//  1542257-1542258
//
//  Created by Phu on 5/16/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation

class Report {
    
    private var _id: Int64!
    private var _totalwordtrue: Int!
    private var _totalword: Int!
    private var _totaladdword: Int!
    private var _totallearnedword: Int!
    private var _totalphrasetrue: Int!
    private var _totalphrase: Int!
    private var _totaladdphrase: Int!
    private var _totallearnedphrase: Int!
    private var _totalidiomstrue: Int!
    private var _totalidioms: Int!
    private var _totaladdidioms: Int!
    private var _totallearnedidioms: Int!
    private var _created: String!
    
    var id: Int64 {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var totalwordtrue: Int {
        get {
            return _totalwordtrue
        }
        set {
            _totalwordtrue = newValue
        }
    }
    
    var totalword: Int {
        get {
            return _totalword
        }
        set {
            _totalword = newValue
        }
    }
    
    var totaladdword: Int {
        get {
            return _totaladdword
        }
        set {
            _totaladdword = newValue
        }
    }
    
    var totallearnedword: Int {
        get {
            return _totallearnedword
        }
        set {
            _totallearnedword = newValue
        }
    }
    
    var totalphrasetrue: Int {
        get {
            return _totalphrasetrue
        }
        set {
            _totalphrasetrue = newValue
        }
    }
    
    var totalphrase: Int {
        get {
            return _totalphrase
        }
        set {
            _totalphrase = newValue
        }
    }
    
    var totaladdphrase: Int {
        get {
            return _totaladdphrase
        }
        set {
            _totaladdphrase = newValue
        }
    }
    
    var totallearnedphrase: Int {
        get {
            return _totallearnedphrase
        }
        set {
            _totallearnedphrase = newValue
        }
    }
    
    var totalidiomstrue: Int {
        get {
            return _totalidiomstrue
        }
        set {
            _totalidiomstrue = newValue
        }
    }
    
    var totalidioms: Int {
        get {
            return _totalidioms
        }
        set {
            _totalidioms = newValue
        }
    }
    
    var totaladdidioms: Int {
        get {
            return _totaladdidioms
        }
        set {
            _totaladdidioms = newValue
        }
    }
    
    var totallearnedidioms: Int {
        get {
            return _totallearnedidioms
        }
        set {
            _totallearnedidioms = newValue
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
    
    init(id: Int64, totalwordtrue: Int, totalword: Int, totaladdword: Int, totallearnedword: Int, totalphrasetrue: Int, totalphrase: Int, totaladdphrase: Int, totallearnedphrase: Int, totalidiomstrue: Int, totalidioms: Int, totaladdidioms: Int, totallearnedidioms: Int, created: String) {
        _id = id
        _totalwordtrue = totalwordtrue
        _totalword = totalword
        _totaladdword = totaladdword
        _totallearnedword = totallearnedword
        _totalphrasetrue = totalphrasetrue
        _totalphrase = totalphrase
        _totaladdphrase = totaladdphrase
        _totallearnedphrase = totallearnedphrase
        _totalidiomstrue = totalidiomstrue
        _totalidioms = totalidioms
        _totaladdidioms = totaladdidioms
        _totallearnedidioms = totallearnedidioms
        _created = created
    }
    
}
