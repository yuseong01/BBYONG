//
//  WebSocketClient.swift
//  BBYONG2
//
//  Created by yuseong on 9/22/24.
//

import Foundation

class WebSocketClient {
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    var onReceive: ((String) -> Void)? // 메시지를 처리할 클로저

    init(url: URL) {
        // URL 확인, 로그 출력
        assert(url.scheme == "ws" || url.scheme == "wss", "WebSocket URL scheme must be 'ws' or 'wss'. Current scheme: \(url.scheme ?? "None")")
        session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
    }

    func connect() {
        webSocketTask?.resume()
        print("WebSocket connected.")
        receive() // 수신 대기 시작
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket disconnected.")
    }

    func send(data: Data) {
        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket send error: \(error.localizedDescription)")
            } else {
                print("WebSocket send success.")
            }
        }
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data.count) bytes.")
                    // 데이터 처리 로직 추가 가능
                case .string(let text):
                    print("Received text: \(text)")
                    self?.onReceive?(text) // 수신된 텍스트를 클로저로 전달
                @unknown default:
                    print("Received unknown message type.")
                }
                self?.receive() // 다음 메시지를 계속 받기 위해 재귀 호출
            case .failure(let error):
                print("WebSocket receive error: \(error.localizedDescription)")
            }
        }
    }
}
