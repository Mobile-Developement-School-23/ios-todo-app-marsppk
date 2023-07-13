//
//  DefaultNetworkingService.swift
//  toDoList
//
//  Created by Maria Slepneva on 08.07.2023.
//

import Foundation

protocol NetworkServiceDelegate: AnyObject {
    func addElement(item: TodoItem) async throws
    func getList() async throws -> List?
    func getItem(id: String) async throws -> Element?
    func changeItem(item: TodoItem) async throws
    func deleteItem(id: String) async throws
    func updateList(items: [TodoItem]) async throws
}

final class DefaultNetworkingService: NetworkServiceDelegate {
    
    private let token: String
    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private let httpStatusCodeSuccess = 200..<300
    private(set) var revision = 0
    
    init (token: String) {
           self.token = token
       }
    
    func addElement(item: TodoItem) async throws {
        let toDoItem = item.asNetworking
        let body = PostElement(element: toDoItem)
        let data = try? JSONEncoder().encode(body)
        guard let data = data else { return }
        guard let url = URL(string: "\(self.baseURL)/list") else { return }
        let headers = ["X-Last-Known-Revision": String(revision)]
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            if self.httpStatusCodeSuccess.contains(400) {
                throw DefaultNetworkingServiceError.badRevision
            }
            throw DefaultNetworkingServiceError.failedResponse(response)
        }
    }
    
    func getList() async throws -> List? {
        guard let url = URL(string: "\(self.baseURL)/list") else { return nil }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (ans, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.failedResponse(response)
        }
        let data = try? JSONDecoder().decode(List.self, from: ans)
        guard let data = data else {
            throw DefaultNetworkingServiceError.decodeError
        }
        return data
    }
    
    func getItem(id: String) async throws -> Element? {
        guard let url = URL(string: "\(self.baseURL)/list/\(id)") else { return nil }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (ans, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            if self.httpStatusCodeSuccess.contains(404) {
                throw DefaultNetworkingServiceError.unknownElement(id)
            }
            else {
                throw DefaultNetworkingServiceError.failedResponse(response)
            }
        }
        let data = try? JSONDecoder().decode(Element.self, from: ans)
        guard let data = data else {
            throw DefaultNetworkingServiceError.decodeError
        }
        return data
    }
    
    func changeItem(item: TodoItem) async throws {
        let toDoItem = item.asNetworking
        let body = PostElement(element: toDoItem)
        let headers = ["X-Last-Known-Revision": String(revision)]
        let data = try? JSONEncoder().encode(body)
        guard let data = data else { return }
        guard let url = URL(string: "\(self.baseURL)/list/\(item.id)") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            if self.httpStatusCodeSuccess.contains(400) {
                throw DefaultNetworkingServiceError.badRevision
            }
            if self.httpStatusCodeSuccess.contains(404) {
                throw DefaultNetworkingServiceError.unknownElement(item.id)
            }
            throw DefaultNetworkingServiceError.failedResponse(response)
        }
    }
    
    func deleteItem(id: String) async throws {
        guard let url = URL(string: "\(self.baseURL)/list/\(id)") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        let headers = ["X-Last-Known-Revision": String(revision)]
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            if self.httpStatusCodeSuccess.contains(400) {
                throw DefaultNetworkingServiceError.badRevision
            }
            if self.httpStatusCodeSuccess.contains(404) {
                throw DefaultNetworkingServiceError.unknownElement(id)
            }
            throw DefaultNetworkingServiceError.failedResponse(response)
        }
    }
    
    func updateList(items: [TodoItem]) async throws {
        var list: [ToDoItemNetworking] = []
        for item in items {
            list.append(item.asNetworking)
        }
        let body = PatchList(list: list)
        let data = try? JSONEncoder().encode(body)
        guard let data = data else { return }
        guard let url = URL(string: "\(self.baseURL)/list") else { return }
        let headers = ["X-Last-Known-Revision": String(revision)]
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse(response)
        }
        guard self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.failedResponse(response)
        }
    }
}

enum DefaultNetworkingServiceError: Error {
    case unexpectedResponse (URLResponse)
    case failedResponse (HTTPURLResponse)
    case noConnection
    case decodeError
    case unknownElement (String)
    case badRevision
}
