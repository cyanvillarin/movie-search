//
//  MoviesList.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import Foundation

// MoviesList is a Decodable which means we could use JSONDecoder().decode() here
// It contains the results which is [Movie] -> array of Movie
// Movie is also Decodable, so if JSONDecoder().decode(MoviesList.self, from: data) is executed
// Movie will also be decoded automatically
struct MoviesList: Decodable {
    var page: Int!
    var results: [Movie]
}
