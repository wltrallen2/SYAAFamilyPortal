//
//  User.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/4/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//


struct User : IdCodable {    
    var id:Int
    let userToken:String
    var isLinked:Bool
    
    static let `default` = User(id: 1, userToken: "wltrallen2", isLinked: true)
}
