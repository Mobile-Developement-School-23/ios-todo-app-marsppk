//
//  1.swift
//  toDoList
//
//  Created by Maria Slepneva on 07.07.2023.
//

import Foundation
final class DefaultNetworkingServiceWithExtention {
    private let token: String
    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private let httpStatusCodeSuccess = 200..<300
    private(set) var revision = 4

    init (token: String) {
        self.token = token
    }

    func getItemExtention(id: String) async throws -> Element? {
        guard let url = URL(string: "\(self.baseURL)/list/\(id)") else { return nil }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (ans, response) = try await URLSession.shared.dataTask(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceWithExtentionErrors.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw DefaultNetworkingServiceWithExtentionErrors.failedResponse(response)
        }
        let data = try? JSONDecoder().decode(Element.self, from: ans)
        guard let data = data else {
            throw DefaultNetworkingServiceWithExtentionErrors.decodeError
        }
        return data
    }
}

enum DefaultNetworkingServiceWithExtentionErrors: Error {
    case unexpectedResponse (URLResponse)
    case failedResponse (HTTPURLResponse)
    case noConnection
    case decodeError
}
