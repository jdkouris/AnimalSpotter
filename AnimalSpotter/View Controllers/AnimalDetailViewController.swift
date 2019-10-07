//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by John Kouris on 10/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {

    @IBOutlet var timeSeenLabel: UILabel!
    @IBOutlet var coordinatesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var animalImageView: UIImageView!
    
    var apiController: APIController?
    var animalName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetails()
    }
    
    func getDetails() {
        guard let animalName = animalName else { return }
        apiController?.fetchDetails(for: animalName, completion: { (result) in
            do {
                let animal = try result.get()
                
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                
                self.apiController?.fetchImage(at: animal.imageURL, completion: { (image) in
                    DispatchQueue.main.async {
                        self.animalImageView.image = image
                    }
                })
            } catch {
                NSLog("Error fetching animal details: \(error)")
            }
        })
    }

    func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "Lat: \(animal.latitude), long: \(animal.longitude)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        timeSeenLabel.text = formatter.string(from: animal.timeSeen)
    }

}
