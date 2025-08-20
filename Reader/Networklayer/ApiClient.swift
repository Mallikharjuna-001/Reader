//
//  ApiClient.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation


class ApiClient{
    enum APIError:Error{
        case invalidURL,requestFailed,decodingFailed,unknown
    }
    
    func get<T:Decodable>(_ urlString:String) async throws -> T{
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.requestFailed
        }
        
        do {
            print(data)
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            throw APIError.decodingFailed
        }
        
    }
}
