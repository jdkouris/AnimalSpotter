//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by John Kouris on 10/4/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    private var animalNames: [String] = []
    let apiController = APIController()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        cell.textLabel?.text = animalNames[indexPath.row]

        return cell
    }

    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        apiController.fetchAllAnimalNames { (result) in
            do {
                let animalNames = try result.get()
                self.animalNames = animalNames
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                NSLog("Error fetching animal names: \(error)")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        }
    }

}
