//
//  QuoteService.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-30.
//
import Foundation
import Combine

// Quote model for handling JSON response
struct Quote: Decodable {
    let q: String  // Quote 
    let a: String  // Author
}

// Error handling for the API
enum QuoteServiceError: Error {
    case invalidURL
    case decodingError
    case networkError
}

// Service class for fetching quotes
class QuoteService {
    private let baseURL = "https://zenquotes.io/api/random"
    
    // Fetches a random quote from ZenQuotes API
    func fetchRandomQuote(completion: @escaping (Result<Quote, QuoteServiceError>) -> Void) {
        // Ensure the URL is valid
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Create a data task to fetch the quote
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network errors
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.networkError))
                return
            }
            
            // Ensure data is non-nil and decode JSON
            if let data = data {
                do {
                    let quotes = try JSONDecoder().decode([Quote].self, from: data)
                    if let firstQuote = quotes.first {
                        completion(.success(firstQuote))
                    } else {
                        completion(.failure(.decodingError))
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}

