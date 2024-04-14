//
//  BigBangModel.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import Foundation

struct BigBangModel: Codable, Hashable {
    init(id: Int, url: URL, name: String, season: Int, number: Int, airDate: String, runtime: Int, image: String, summary: String, favorite: Bool, seen: Bool) {
        self.id = id
        self.url = url
        self.name = name
        self.season = season
        self.number = number
        self.airDate = airDate
        self.runtime = runtime
        self.image = image
        self.summary = summary
        self.favorite = favorite
        self.seen = seen
    }
    
    let id: Int
    let url: URL
    let name: String
    let season, number: Int
    let airDate: String
    let runtime: Int
    let image: String
    let summary: String
    let favorite: Bool
    let seen: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case season
        case number
        case airDate = "airdate"
        case runtime
        case image
        case summary
        case favorite
        case seen
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BigBangModel.CodingKeys> = try decoder.container(keyedBy: BigBangModel.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: BigBangModel.CodingKeys.id)
        self.url = try container.decode(URL.self, forKey: BigBangModel.CodingKeys.url)
        self.name = try container.decode(String.self, forKey: BigBangModel.CodingKeys.name)
        self.season = try container.decode(Int.self, forKey: BigBangModel.CodingKeys.season)
        self.number = try container.decode(Int.self, forKey: BigBangModel.CodingKeys.number)
        self.airDate = try container.decode(String.self, forKey: BigBangModel.CodingKeys.airDate)
        self.runtime = try container.decode(Int.self, forKey: BigBangModel.CodingKeys.runtime)
        self.image = try container.decode(String.self, forKey: BigBangModel.CodingKeys.image)
        self.summary = try container.decode(String.self, forKey: BigBangModel.CodingKeys.summary)
        self.favorite = try container.decode(Bool.self, forKey: BigBangModel.CodingKeys.favorite)
        self.seen = try container.decode(Bool.self, forKey: BigBangModel.CodingKeys.seen)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<BigBangModel.CodingKeys> = encoder.container(keyedBy: BigBangModel.CodingKeys.self)
        
        try container.encode(self.id, forKey: BigBangModel.CodingKeys.id)
        try container.encode(self.url, forKey: BigBangModel.CodingKeys.url)
        try container.encode(self.name, forKey: BigBangModel.CodingKeys.name)
        try container.encode(self.season, forKey: BigBangModel.CodingKeys.season)
        try container.encode(self.number, forKey: BigBangModel.CodingKeys.number)
        try container.encode(self.airDate, forKey: BigBangModel.CodingKeys.airDate)
        try container.encode(self.runtime, forKey: BigBangModel.CodingKeys.runtime)
        try container.encode(self.image, forKey: BigBangModel.CodingKeys.image)
        try container.encode(self.summary, forKey: BigBangModel.CodingKeys.summary)
        try container.encode(self.favorite, forKey: BigBangModel.CodingKeys.favorite)
        try container.encode(self.seen, forKey: BigBangModel.CodingKeys.seen)
    }
    
    
}

