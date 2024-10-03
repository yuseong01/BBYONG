//
//  PermissionManager.swift
//  BBYONG2
//
//  Created by yuseong on 9/22/24.
//

import AVFoundation

class PermissionManager : ObservableObject {
    @Published var permissionGranted = false
    
    //카메라 권한 요청
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
        })
    }

    //오디오 권한 요청
    func requestAudioPermission(){
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            if granted {
                print("Audio: 권한 허용")
            } else {
                print("Audio: 권한 거부")
            }
        })
    }
    
}
