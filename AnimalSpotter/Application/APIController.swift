//
//  APIController.swift
//  AnimalSpotter
//
//  Created by John Kouris on 10/4/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Helper enums

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
}

enum HeaderName: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    var bearer: Bearer?
    
    // MARK: - Sign up
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        // Build the URL
        let requestURL = baseUrl
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: HeaderName.contentType.rawValue)
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        // Perform the request (data task)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JohnKouris.AnimalSpotter", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            // nil means there was no error, everything succeeded
            completion(nil)
        }.resume()
    }
    
    // MARK: - Sign in
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let requestURL = baseUrl
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: HeaderName.contentType.rawValue)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JohnKouris.AnimalSpotter", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.JohnKouris.AnimalSpotter", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Fetch all animal names
    
    // The Result enum is going to have an [String] for its success and a NetworkingError for its failure
    func fetchAllAnimalNames(completion: @escaping (Result<[String], NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseUrl.appendingPathComponent("animals").appendingPathComponent("all")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // "Bearer DLEVQL2eruEWt4leWLcxL5Qb94dMcw0ACVyesOV6YGA="
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderName.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching animal names: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let animalNames = try JSONDecoder().decode([String].self, from: data)
                completion(.success(animalNames))
            } catch {
                NSLog("Error decoding animal names: \(error)")
                completion(.failure(.badDecode))
            }
        }.resume()
    }
    
    func fetchDetails(for animalName: String, completion: @escaping (Result<Animal, NetworkingError>) -> Void) {
        
    }
    
}
