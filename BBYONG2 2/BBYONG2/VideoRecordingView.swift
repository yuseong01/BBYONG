//
//  VideoRecordingView.swift
//  BBYONG2
//
//  Created by yuseong on 8/19/24.
//
import SwiftUI
import AVFoundation

struct VideoRecordingView: View {
    @State private var isRecording = false
    @StateObject var permissionManager = PermissionManager()
    private var captureSession = AVCaptureSession()
    private var audioOutput = AVCaptureAudioDataOutput() // 오디오 캡처
    private let audioCaptureDelegate = AudioCaptureDelegate()
    @State private var webSocketClient: WebSocketClient? = nil // WebSocket 클라이언트
    @State private var captions: [String] = [] // 자막을 저장하는 배열
    @State private var currentLanguage: String = "Korean" // 기본 언어는 영어로 설정
    
    
    var body: some View {
        ZStack {
            // 비디오 레이어
            VideoPreviewLayerView(captureSession: captureSession)
                .onAppear {
                    permissionManager.requestCameraPermission()
                    permissionManager.requestAudioPermission()
                    setupCaptureSession()
                    setupWebSocket() // 서버와의 연결 설정
                }
                .onDisappear {
                    stopCaptureSession()
                    webSocketClient?.disconnect() // WebSocket 연결 해제
                }
            
            // 자막 표시
            VStack {
                Spacer()
                ForEach(captions, id: \.self) { caption in
                    Text(caption)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.bottom, 5)
                }
            }
            .padding(.bottom, 100)
            
            
            // 녹화 시작/중지 및 언어 전환 버튼
            HStack {
                // 언어 전환 버튼
                Button(action: toggleLanguage) {
                    Text(currentLanguage == "Korean" ? "KOR" : currentLanguage == "English" ? "ENG" : "BOTH")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // 녹화 시작/중지 버튼
                Button(action: toggleRecording) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .foregroundColor(.white)
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 150)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height - 100)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    // 언어 전환
    func toggleLanguage() {
        //"Korean" -> "English" -> "Both" 순서로 전환
        if currentLanguage == "Korean" {
            currentLanguage = "English"
        } else if currentLanguage == "English" {
            currentLanguage = "Both"
        } else {
            currentLanguage = "Korean"
        }
        captions.removeAll() // 언어 전환 시 기존 자막 초기화
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = .medium
        
        // 오디오 세션 설정
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setPreferredSampleRate(16000) // 16kHz설정
            try audioSession.setPreferredIOBufferDuration(0.01)
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
        
        // 카메라 설정
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("No camera or audio available")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            // 비디오 추가
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            // 오디오 입력 추가
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            
            // 오디오 출력 설정 (오디오만 처리)
            audioOutput.setSampleBufferDelegate(audioCaptureDelegate, queue: DispatchQueue(label: "audioQueue"))
            if captureSession.canAddOutput(audioOutput) {
                captureSession.addOutput(audioOutput)
            }
            
            captureSession.startRunning()
        } catch {
            print("Error setting up inputs: \(error)")
        }
    }
    
    
    func stopCaptureSession() {
        captureSession.stopRunning()
    }
    
    func toggleRecording() {
        isRecording.toggle()
        audioCaptureDelegate.isRecording = isRecording
        if isRecording {
            print("Recording started")
            webSocketClient?.connect() // 녹화 시작 시 WebSocket 연결
        } else {
            print("Recording stopped")
            webSocketClient?.disconnect() // 녹화 중단 시 WebSocket 연결 해제
        }
    }
    
    // WebSocket 연결 설정
    func setupWebSocket() {
        let serverUrl = URL(string: SERVER_URL)!
        print("Connecting to WebSocket URL: \(serverUrl)")
        webSocketClient = WebSocketClient(url: serverUrl)
        audioCaptureDelegate.webSocketClient = webSocketClient
        
        // WebSocket 메시지 수신 핸들러 설정
        webSocketClient?.onReceive = { message in
            handleMessage(message) // 서버로부터 받은 메시지 처리
        }
        audioCaptureDelegate.webSocketClient = webSocketClient
    }
    
    func handleMessage(_ message: String) {
        if let data = message.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let type = json["type"] as? String,
           let data = json["data"] as? String {
            
            // 현재 언어 설정에 맞는 자막만 표시
            if (currentLanguage == "Korean" && type == "transcription") ||
                (currentLanguage == "English" && type == "translation") ||
                (currentLanguage == "Both" && (type == "transcription" || type == "translation")) {
                captions.append(data)
                if captions.count > 2 { // 자막 표시 개수 제한
                    captions.removeFirst()
                }
            }
        }
    }

}

// 오디오 캡처
class AudioCaptureDelegate: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    var isRecording = false
    var webSocketClient: WebSocketClient?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isRecording {
            // PCM 데이터를 추출하여 전송
            if let audioBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
                var length = 0
                var dataPointer: UnsafeMutablePointer<Int8>?
                
                CMBlockBufferGetDataPointer(audioBuffer, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &length, dataPointerOut: &dataPointer)
                
                if let dataPointer = dataPointer {
                    let data = Data(bytes: dataPointer, count: length)
                    webSocketClient?.send(data: data) // 오디오 데이터를 서버로 전송
                }
            }
        }
    }
}

// 비디오 화면
struct VideoPreviewLayerView: UIViewRepresentable {
    let captureSession: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
