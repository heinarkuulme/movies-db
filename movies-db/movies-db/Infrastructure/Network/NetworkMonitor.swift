//
//  NetworkMonitor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    //Verifica se existe conexão com internet, com timeout de 2 segs
    func isConnectedToInternet() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnetionMonitor")
        var isConnect = false
        let semaphore = DispatchSemaphore(value: 0)
        
        monitor.pathUpdateHandler = { path in
            isConnect = (path.status == .satisfied)
            semaphore.signal()
            monitor.cancel()
        }
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 2)
        
        return isConnect
    }
}
