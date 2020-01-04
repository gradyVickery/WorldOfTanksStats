//
//  ViewController.swift
//  WorldOfTanksStats
//
//  Created by Grady Vickery on 12/19/19.
//  Copyright © 2019 Grady Vickery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var searchResults = [UserData.Id]()
    var hasSearched = false
    var badSearch = false

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var treesCutLabel: UILabel!
    @IBOutlet weak var maxXpLabel: UILabel!
    @IBOutlet weak var globalRatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    @IBAction func searchForUserName(_ sender: Any) {
        if !textField.text!.isEmpty {
            hasSearched = true
            badSearch = false
            searchResults = []
            
            // first fetch with userName to obtain user "#######"
            let url = userNameSearch(searchText: textField.text!)
                let queue = DispatchQueue.global()
                queue.async {
                    if let data = performRequest(with: url) {
                        let results = parseForUserId(data: data)
                        
                        // check for no results returned
                        if results.count == 0 {
                            DispatchQueue.main.async {
                                self.badSearch = true
                                self.updateLabels()
                            }
                            return
                        }
                        
                        // Update name label with username on main thread
                        DispatchQueue.main.async {
                            self.playerNameLabel.text = self.textField.text!
                        }
                        
                        let userId = results[0].account_id
                        queue.async {
                            
                            // fetch with user id "######"
                            let newUrl = userStatSearch(searchNum: userId)
                            if let newData = performRequest(with: newUrl) {
                                let newResults = parseForStats(data: newData)
                                self.searchResults = newResults
                                
                                // Dispatch.main to update UI
                                DispatchQueue.main.async {
                                    self.updateLabels()
                                }
                        }
                    }
                }
            }
        }
    }
    
    // MARK:- helpers
    func updateLabels() {
        if hasSearched && !badSearch {
            maxXpLabel.text = String(searchResults[0].statistics.max_xp)
            treesCutLabel.text = String(searchResults[0].statistics.trees_cut)
            globalRatingLabel.text = String(searchResults[0].globalRating)
            print(searchResults[0].statistics.all.spotted)
            
        } else if badSearch {
            clearLabels()
            playerNameLabel.text = "Player not found, please try again"
        } else {
            clearLabels()
        }
    }
  
    func clearLabels() {
        playerNameLabel.text = ""
        maxXpLabel.text = ""
        treesCutLabel.text = ""
        globalRatingLabel.text = ""
    }
}

