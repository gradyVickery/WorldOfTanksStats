//
//  UserSearchResult.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 12/19/19.
//  Copyright © 2019 Grady Vickery. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let status: String
    let meta: Meta
    let data: Datas
}

struct Meta: Codable {
    let count: Int
}
struct Datas {
    struct Id : Codable{
        let idName : String
        let statistics: Statistics
    }
    var idArray: [Id]
    
    init(idArray: [Id] = []) {
        self.idArray = idArray
    }
}

struct Statistics: Codable {
    let max_xp: Int
    let trees_cut: Int
}

extension Datas: Encodable {
    struct IdKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let statistics = IdKey(stringValue: "statistics")!
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: IdKey.self)
        
        for id in idArray {
            let idKey = IdKey(stringValue: id.idName)!
            var idContainer = container.nestedContainer(keyedBy: IdKey.self, forKey: idKey)
            try idContainer.encode(id.statistics, forKey: .statistics)

        }
    }
}

extension Datas: Decodable {
    public init(from decoder: Decoder) throws {
        var idArray = [Id]()
        let container = try decoder.container(keyedBy: IdKey.self)
        for key in container.allKeys {
            let idContainer = try container.nestedContainer(keyedBy: IdKey.self, forKey: key)
            let statistics = try idContainer.decode(Statistics.self, forKey: .statistics)
            let id = Id(idName: key.stringValue, statistics: statistics)
            idArray.append(id)
        }
        self.init(idArray: idArray)
    }
}

    
 // Search via User 'nickname' models below

class ResultData: Codable {
    var data = [UserSearchResult]()
}

class UserSearchResult: Codable, CustomStringConvertible {
    var nickname = ""
    var account_id = 0
    
    var description: String {
        return "\(account_id)"
    }
    
}





