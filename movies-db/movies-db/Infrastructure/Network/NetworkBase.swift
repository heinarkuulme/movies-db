//
//  NetworkBase.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

enum RequestMethods: String {
    case get = "GET"
    case post = "POST"
}

enum RequestEncondig {
    case json
    case url
}

protocol RequestBase {
    func makeRequest<Y: Codable, T: NetworkResponse<Y>>(
        printResponse: Bool,
        completion: @escaping (
            Result<T,
            NetworkError>
        ) -> Void
    )
    
    var path: String { get }
    var method: RequestMethods { get }
    var enconding: RequestEncondig { get }
    var header: [String: String]? { get }
    var params: [String: Any]? { get }
    var baseUrl: String { get }
}

extension RequestBase {
    var enconding: RequestEncondig {
        return .json
    }
    
    func getDefaultHeaders() -> [String: String]? {
        var headers = self.header ?? [:]
        
        if let token: String = InfoPlistManager.getValue(key: .ApiToken) {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    func buildUrl() -> URL? {
        let urlString = self.baseUrl + self.path
        return URL(string: urlString)
    }
    
    func makeRequest<Y: Codable, T: NetworkResponse<Y>>(
        printResponse: Bool = true,
        completion: @escaping (
            Result<T,
            NetworkError>) -> Void)
    {
        
        //check connection
        guard NetworkMonitor.shared.isConnectedToInternet() else {
            completion(.failure(NetworkError(statusCode: 400, message: "Sem conexão com a internet", error: "Sem Internet")))
            return
        }
        
        //monta a url
        guard let url = buildUrl() else {
            completion(
                .failure(
                    .init(
                        statusCode: 400,
                        message: "URL Inválida: \(self.path)",
                        error: "URL Inválida"
                    )
                )
            )
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        //monta os headers
        if let headers = getDefaultHeaders() {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        //monta os params
        if let params = self.params {
            switch self.enconding {
            case .json:
                request.httpBody = try? JSONSerialization
                    .data(withJSONObject: params, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
            case .url:
                if var components = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                ) {
                    components.queryItems = params
                        .map { URLQueryItem(name: $0.key, value: "\($0.value)")}
                    request.url = components.url
                }
            }
        }
        
        let requestCurl = generateCurlCommand(from: request)
        let reqStart = Date()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
            
            if let error = error {
                let netError = NetworkError( error: error, statusCode: statusCode)
                
                self.printResponseToConsole(
                    url: url,
                    statusCode: statusCode,
                    cUrl: requestCurl,
                    taskDuration: Date().timeIntervalSince(reqStart),
                    reqStart: reqStart,
                    error: netError,
                    printResponse: printResponse
                )
                
                completion(.failure(netError))
                return
            }
            
            if let data = data {
                let objResponse = T()
                do {
                    objResponse.response = try objResponse.parseData(data: data)
                    self.printResponseToConsole(
                        url: url,
                        statusCode: statusCode,
                        cUrl: requestCurl,
                        taskDuration: Date().timeIntervalSince(reqStart),
                        reqStart: reqStart,
                        printResponse: printResponse
                    )
                    
                    completion(.success(objResponse))
                    
                } catch let decodeError as NetworkError {
                    self.printResponseToConsole(
                        url: url,
                        statusCode: statusCode,
                        cUrl: requestCurl,
                        taskDuration: Date().timeIntervalSince(reqStart),
                        reqStart: reqStart,
                        error: decodeError,
                        printResponse: printResponse
                    )
                    completion(.failure(decodeError))
                } catch {
                    let netError = NetworkError(error: error, statusCode: statusCode)
                    self.printResponseToConsole(
                        url: url,
                        statusCode: statusCode,
                        cUrl: requestCurl,
                        taskDuration: Date().timeIntervalSince(reqStart),
                        reqStart: reqStart,
                        error: netError,
                        printResponse: printResponse
                    )
                    completion(.failure(netError))
                }
            } else {
                let netError = NetworkError(statusCode: 204, message: "Sem conteúdo na resposta", error: "Sem conteúdo")
                self.printResponseToConsole(
                    url: url,
                    statusCode: statusCode,
                    cUrl: requestCurl,
                    taskDuration: Date().timeIntervalSince(reqStart),
                    reqStart: reqStart,
                    error: netError,
                    printResponse: printResponse
                )
                completion(.failure(netError))
            }
        }
        task.resume()
    }
}

//printable
extension RequestBase {
    
    private func generateCurlCommand(from request: URLRequest) -> String {
        var curl = "curl"
        if let method = request.httpMethod {
            curl += " -X \(method)"
        }
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                curl += " -H '\(key): \(value)'"
            }
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            curl += " -d '\(bodyString)'"
        }
        if let url = request.url {
            curl += " \(url.absoluteString)"
        }
        return curl
    }
    
    private func printResponseToConsole(url: URL,
                                            responseData: Data? = nil,
                                            statusCode: Int?,
                                            cUrl: String,
                                            taskDuration: Double = 0.0,
                                            reqStart: Date,
                                            error: NetworkError? = nil,
                                        printResponse: Bool = false) {
        DispatchQueue.global(qos: .background).async {
            let code = statusCode ?? 400
            var responseString = """
                [Network] REQUEST (\(url.absoluteString) - \(reqStart) - \(reqStart.timeIntervalSince1970 * 1000)s)
                [Network] REQUEST cURL: \n\(cUrl)
                [Network] REQUEST DURATION: \(taskDuration)s
                [Network] \(code != 200 ? "ERROR \(code)" : "SUCCESS \(code)")
                [Network] RESPONSE:
                """
            
            if printResponse, let data = responseData {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    responseString += prettyString
                } else if let prettyString = String(data: data, encoding: .utf8) {
                    responseString += prettyString
                }
            }
            
            if let error = error {
                responseString += "\n[NETWORK_ERROR]: " + error.message
            }
        }
    }
}
