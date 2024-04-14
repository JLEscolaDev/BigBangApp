//
//  BigBangModelDTO.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import Foundation

struct BigBangModelDTO: Codable, Hashable, ModelConvertible {
    
    let id: Int
    let url: URL
    let name: String
    let season, number: Int
    let airDate: String
    let runtime: Int
    let image: String
    let summary: String
    
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
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BigBangModelDTO.CodingKeys> = try decoder.container(keyedBy: BigBangModelDTO.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: BigBangModelDTO.CodingKeys.id)
        self.url = try container.decode(URL.self, forKey: BigBangModelDTO.CodingKeys.url)
        self.name = try container.decode(String.self, forKey: BigBangModelDTO.CodingKeys.name)
        self.season = try container.decode(Int.self, forKey: BigBangModelDTO.CodingKeys.season)
        self.number = try container.decode(Int.self, forKey: BigBangModelDTO.CodingKeys.number)
        self.airDate = try container.decode(String.self, forKey: BigBangModelDTO.CodingKeys.airDate)
        self.runtime = try container.decode(Int.self, forKey: BigBangModelDTO.CodingKeys.runtime)
        self.image = try container.decode(String.self, forKey: BigBangModelDTO.CodingKeys.image)
        self.summary = try container.decode(String.self, forKey: BigBangModelDTO.CodingKeys.summary)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<BigBangModelDTO.CodingKeys> = encoder.container(keyedBy: BigBangModelDTO.CodingKeys.self)
        
        try container.encode(self.id, forKey: BigBangModelDTO.CodingKeys.id)
        try container.encode(self.url, forKey: BigBangModelDTO.CodingKeys.url)
        try container.encode(self.name, forKey: BigBangModelDTO.CodingKeys.name)
        try container.encode(self.season, forKey: BigBangModelDTO.CodingKeys.season)
        try container.encode(self.number, forKey: BigBangModelDTO.CodingKeys.number)
        try container.encode(self.airDate, forKey: BigBangModelDTO.CodingKeys.airDate)
        try container.encode(self.runtime, forKey: BigBangModelDTO.CodingKeys.runtime)
        try container.encode(self.image, forKey: BigBangModelDTO.CodingKeys.image)
        try container.encode(self.summary, forKey: BigBangModelDTO.CodingKeys.summary)
    }
    
    func toModel() -> BigBangModel {
        BigBangModel(
            id: self.id,
            url: self.url,
            name: self.name,
            season: self.season,
            number: self.number,
            airDate: self.airDate,
            runtime: self.runtime,
            image: self.image,
            summary: self.summary,
            favorite: false,
            seen: false
        )
    }
    
}

protocol ModelConvertible {
    associatedtype ModelType
    func toModel() -> ModelType
}

