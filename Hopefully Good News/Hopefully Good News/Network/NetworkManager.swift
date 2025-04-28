//
//  NetworkManager.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation

actor NetworkManager {
    private let session: URLSession
   
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: NetworkRequest>(_ request: T) async throws -> T.Response {
        
        let urlRequest = try request.toURLRequest()
        
        let (data, response) = try await session.data(for: urlRequest)
        try validateResponse(response)
        
        return try decode(data: data, as: T.Response.self)
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
