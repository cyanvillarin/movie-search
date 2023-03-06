//
//  ClassVsStruct.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import Foundation

// Class
// MovieClass(title: "testString", votes: 1)
// class needs to declare the init()
class MovieClass {
    var title: String!
    var votes: Int!

    init(title: String!, votes: Int!) {
        self.title = title
        self.votes = votes
    }
}

// Struct
// MovieStruct(title: "testString", votes: 1)
// struct doesn't need to declare the init()
struct MovieStruct {
    var title: String!
    var votes: Int!
}

