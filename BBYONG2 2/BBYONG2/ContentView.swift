//
//  ContentView.swift
//  BBYONG
//
//  Created by yuseong on 8/5/24.
//

import SwiftUI

struct ContentView: View {
    
//    @StateObject private var socketService = SocketService()
    
    var body: some View {
        TabView {
            NoteView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Note")
                }
                .toolbarBackground(.black, for: .tabBar)
            
            Text("2탭화면")
                .tabItem {
                    Image(systemName: "person.crop.square.badge.video")
                    Text("Video")
                }
            
            VideoRecordingView()
                .tabItem {
                    Image(systemName: "video.badge.plus")
                    Text("Record")
                }
                .toolbarBackground(.black, for: .tabBar)

            
            ShareView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
}


