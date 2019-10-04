//
//  APIController.swift
//  AnimalSpotter
//
//  Created by John Kouris on 10/4/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    // create function for sign up
//    func signUp(with user: User)
    
    // create function for sign in
    
}
