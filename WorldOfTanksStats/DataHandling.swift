//
//  DataHandling.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 1/3/20.
//  Copyright © 2020 Grady Vickery. All rights reserved.
//

import Foundation

// First search with user name to obtain ID
func userNameSearch(searchText: String) -> URL {
     let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
     let urlString = String(format: "https://api-xbox-console.worldoftanks.com/wotx/account/list/?application_id=bd6f5796b394944b8e469b857b06a385&search=%@", encodedText)
     let url = URL(string: urlString)
     return url!
 }

// Second search with user ID...obtains game stats
 func userStatSearch(searchNum: Int) -> URL {
     let urlString = String(format: "https://api-xbox-console.worldoftanks.com/wotx/account/info/?application_id=bd6f5796b394944b8e469b857b06a385&account_id=%@", String(searchNum))
     let url = URL(string: urlString)
     return url!
 }

 func performRequest(with url: URL) -> Data? {
     do {
         return try Data(contentsOf: url)
     } catch {
         print("Download Error: \(error.localizedDescription)")
         return nil
     }
 }
 
 func parseForUserId(data: Data) -> [NameSearchResult] {
     do {
         let decoder = JSONDecoder()
         let result = try decoder.decode(UserNameResponse.self, from: data)
         return result.data
     } catch {
         print("JSON Error: \(error)")
         return []
     }
 }
 
 // parsing second fetch via account_id
 func parseForStats(data: Data) -> [UserData.Id] {
     
     do {
         let decoder = JSONDecoder()
         let result = try decoder.decode(StatResponse.self, from: data)
         let stats = result.data.idArray[0]
         return [stats]
     } catch {
         print("JSON Error: \(error)")
         return []
     }
 }
