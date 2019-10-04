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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            
        }
    }

}
