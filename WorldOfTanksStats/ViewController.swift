//
//  ViewController.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 12/19/19.
//  Copyright © 2019 Grady Vickery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var searchResults = [Datas.Id]()
    var account_id = 0
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var treesCutLabel: UILabel!
    @IBOutlet weak var maxXpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func searchForUserName(_ sender: Any) {
        
        if !textField.text!.isEmpty {
            
            playerNameLabel.text = textField.text!
            searchResults = []
        
            let url = userNameSearch(searchText: textField.text!)
                let queue = DispatchQueue.global()
                queue.async {
            
                    if let data = self.performRequest(with: url) {
                        let results = self.parseForUserId(data: data)
                        let id = results[0].account_id
                        self.account_id = id
                        queue.async {
                            let newUrl = self.userStatSearch(searchNum: id)
                            if let newData = self.performRequest(with: newUrl) {
                                let newResults = self.parseForStats(data: newData)
                                self.searchResults = newResults
                                

                                DispatchQueue.main.async {
                                    self.updateLabels()
                                }
                                return
                        }
                        
                    }
            
                }
            }
        }
    }
    
    func updateLabels() {
        maxXpLabel.text = String(searchResults[0].statistics.max_xp)
        treesCutLabel.text = String(searchResults[0].statistics.trees_cut)
    }
  
    // MARK:- helpers
    func userNameSearch(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://api-xbox-console.worldoftanks.com/wotx/account/list/?application_id=bd6f5796b394944b8e469b857b06a385&search=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }
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
        
    func parseForUserId(data: Data) -> [UserSearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultData.self, from: data)
            return result.data
        } catch {
            print("JSON error11 \(error)")
            return [UserSearchResult]()
        }
    }
    
    // parsing second fetch via account_id
    func parseForStats(data: Data) -> [Datas.Id] {
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(UserResponse.self, from: data)
            let stats = result.data.idArray[0]
           
            
            return [stats]
        } catch {
            print("JSON error22∫ \(error)")
            return []
        }
    }
    
    
}

