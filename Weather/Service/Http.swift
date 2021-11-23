//
//  Http.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

public enum ErrorCode {
    case NetworkError
    case HTTPError
    case ParsingError
    case AuthenticationError
    case Cancelled
}

class BaseError {
    let errorCode: ErrorCode
    let description: String

    init(errorCode: ErrorCode, description: String) {
        self.errorCode = errorCode
        self.description = description
    }

    init(errorCode: ErrorCode) {
        self.errorCode = errorCode
        self.description = ""
    }

    func log() {
        print("ErrorCode: \(errorCode), Description: \(description)")
    }
}


public class Http: NSObject {

    public static let shared = Http.init()

    private let maxConcurrentConnection: Int = 3
    private let operationQueue: OperationQueue
    private var urlSession: URLSession!
    private var redirectClosures: [String: (String?) -> Void] = [:]

    private override init() {
        operationQueue = OperationQueue.init()
        operationQueue.maxConcurrentOperationCount = maxConcurrentConnection
        super.init()
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: operationQueue)
    }

    func makeNewRequest(req: URLRequest, completion: @escaping (Data?) -> Void, failure: @escaping (BaseError) -> Void) -> URLSessionDataTask {

        let dataTask = urlSession.dataTask(with: req) { data, response, error in
            // Cancelled requests
            if let error = error {
                if error.localizedDescription == "cancelled" {
                    failure(BaseError(errorCode: .Cancelled))
                }
                else {
                    failure(BaseError(errorCode: .NetworkError, description: error.localizedDescription))
                }
                return
            }
            
            // No network
            guard let httpResponse = response as? HTTPURLResponse else {
                failure(BaseError(errorCode: .NetworkError))
                return
            }
            
            // Request completed, but may contain HTTP or parseing errors
            switch httpResponse.statusCode {
            case 200:
                completion(data)
            case 401:
                failure(BaseError(errorCode: .AuthenticationError))
            default:
                if let data = data, let dataStr = String(data: data, encoding: .utf8) {
                    failure(BaseError(errorCode: .HTTPError, description: "HTTP \(httpResponse.statusCode): \(dataStr)"))
                }
                else {
                    failure(BaseError(errorCode: .HTTPError, description: "HTTP \(httpResponse.statusCode):"))
                }
            }
        }
        return dataTask
    }

    func getRedirectUrl(urlString: String, completion: @escaping (String?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { completion(nil); return nil }
        redirectClosures[urlString] = completion
        let task = makeNewRequest(req: URLRequest(url: url)) { data in
        } failure: { error in
        }
        return task
    }
}

extension Http: URLSessionDelegate, URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if let originUrlString = response.url?.absoluteString,
           let response = response as HTTPURLResponse?,
           let urlString = response.allHeaderFields["Location"] as? String {
            (self.redirectClosures[originUrlString])!(urlString)
            self.redirectClosures.removeValue(forKey: urlString)
        }
        completionHandler(nil)
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//        completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
