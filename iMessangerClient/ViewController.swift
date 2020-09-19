//
//  ViewController.swift
//  iMessangerClient
//
//  Created by Ali Sajadi on 9/18/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var webSocketTask: URLSessionWebSocketTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebSocket()
        sendMessage()
        receiveMessage()
    }
    
    func setupWebSocket() {
        let session = URLSession(configuration: .default)
//        let url = URL(string: "ws://127.0.01:8080/iMessangerServer/chat")!
        webSocketTask = session.webSocketTask(with: URL(string: "ws://127.0.01:8080/iMessangerServer/chat")!)
        webSocketTask.resume()
    }

    func sendMessage() {
        let message = URLSessionWebSocketTask.Message.string(
            """
                {"message":"Hey...There!"}
            """
        )
        webSocketTask.send(message) { (error) in
            if let error = error {
                print("WebSocket couldn't send message: \(error)")
            }
        }
    }
    
    func receiveMessage() {
        
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("Failed to receive message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
                self.receiveMessage()
            }
        }
    }
}

