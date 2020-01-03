//
//  UserSearchResult.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 12/19/19.
//  Copyright © 2019 Grady Vickery. All rights reserved.
//

import Foundation

struct StatResponse: Codable {
    let status: String
    let meta: Meta
    let data: UserData
}

struct Meta: Codable {
    let count: Int
}
struct UserData {
    struct Id : Codable {
        let idString : String
        let statistics: Statistics
        let globalRating: Int
    }
    var idArray: [Id]
    
    init(idArray: [Id] = []) {
        self.idArray = idArray
    }
}

struct Statistics: Codable {
    let max_xp: Int
    let trees_cut: Int
    let all: All
    
    struct All: Codable {
        let spotted: Int
    }
}



// Extensions for UserData struct...Encodable/Decodable
extension UserData: Encodable {
    struct IdKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let statistics = IdKey(stringValue: "statistics")!
        static let globalRating = IdKey(stringValue: "global_rating")!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: IdKey.self)
        
        for id in idArray {
            let idKey = IdKey(stringValue: id.idString)!
            var idContainer = container.nestedContainer(keyedBy: IdKey.self, forKey: idKey)
            try idContainer.encode(id.statistics, forKey: .statistics)
            try idContainer.encode(id.globalRating, forKey: .globalRating)

        }
    }
}

extension UserData: Decodable {
    public init(from decoder: Decoder) throws {
        var idArray = [Id]()
        let container = try decoder.container(keyedBy: IdKey.self)
        for key in container.allKeys {
            let idContainer = try container.nestedContainer(keyedBy: IdKey.self, forKey: key)
            
            let statistics = try idContainer.decode(Statistics.self, forKey: .statistics)
            let globalRating = try idContainer.decode(Int.self, forKey: .globalRating)
            let id = Id(idString: key.stringValue, statistics: statistics, globalRating: globalRating)
            idArray.append(id)
        }
        self.init(idArray: idArray)
    }
}

    






