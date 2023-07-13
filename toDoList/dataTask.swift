//
//  dataTask.swift
//  toDoList
//
//  Created by Maria Slepneva on 07.07.2023.
//

import Foundation

extension URLSession {
    func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?

        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    let dataTask = self.dataTask(with: request) { data, response, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let data = data, let response = response {
                            continuation.resume(returning: (data, response))
                        } else {
                            continuation.resume(throwing: URLError(.unknown))
                        }
                    }
                    dataTask.resume()
                }
            },
            onCancel: { [weak dataTask] in
                dataTask?.cancel()
            }
        )
    }
}
