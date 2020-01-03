//
//  UserNameResponse.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 1/3/20.
//  Copyright © 2020 Grady Vickery. All rights reserved.
//

import Foundation

class UserNameResponse: Codable {
    var data = [NameSearchResult]()
}

    class NameSearchResult: Codable {
        var nickname = ""
        var account_id = 0
}
