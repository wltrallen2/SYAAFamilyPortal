//
//  User.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/4/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//


struct User : Codable {
    let id:Int
    let userToken:String
    var isLinked:Bool = false
    
    static let `default` = User(id: 1, userToken: "wltrallen2", isLinked: true)
}
