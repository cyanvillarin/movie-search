//
//  Movie.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

struct Movie: Decodable {
    var title: String!
    var voteCount: Int!
    var overview: String!
    var posterPath: String?  // on the API documentation, poster_path can be NULL so we set this as Optional (String?)
    
    // Swift uses camelCase, and Backend/Server/API usually uses snake_case
    // This the key for the properties will be different
    // In this case, we have to use CodingKeys: String, CodingKey
    // Then use case per property
    /// if the property is already same with backend, do nothing
    /// if the property is not the same with backend, use the = "{backend key}"
    enum CodingKeys: String, CodingKey {
        case title
        case voteCount = "vote_count"
        case overview
        case posterPath = "poster_path"
    }
}
