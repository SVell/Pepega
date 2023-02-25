//
//  HTTPManager.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import Foundation

class HTTPManager {
    static var shared: HTTPManager = {
        let instance = HTTPManager()
        return instance
    }()
    
   var cache:Data
   
    private init(){
        cache = Data()
    }
}

