//
//  LectureNoteView.swift
//  BBYONG
//
//  Created by yuseong on 8/7/24.
//

import SwiftUI

struct LectureNoteView: View {
    @State private var selectedTab: Tab = .voiceRecord
    @State var dateString = ""
    
    enum Tab {
        case voiceRecord
        case memoSummary
    }
    
    
    var body: some View {
        VStack(alignment:.leading){
            Text("\(dateString)")
                .padding(.leading, 30)
                .padding(.top, 20)
//            Text("8.7 수 오후 10:30 ")
//                .padding(.leading, 30)
//                .padding(.top,20)
            Text("새로운 노트")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.leading,30)
                .padding(.top, 5)
            
            HStack{
                Button(action: {
                    
                }, label: {
                    Text("음성기록")
                        .font(.headline)
                        .padding()
                        .padding(.leading, 60)
                })
                
                Spacer()
                Divider()
                    .frame(height: 40)
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("강의요약")
                        .font(.headline)
                        .padding()
                })
                Spacer()
            }
            NoteContentsView()
        }
        .onAppear {
            dateString = Date.now.formatted()
        }
        // 하단 재생 바
        VStack {
            HStack {
                Text("1X")
                    .font(.system(size: 16))
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                }
                
                Button(action: {}) {
                    Image(systemName: "play.fill")
                }
                
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "globe")
                }
                
                Text("한국어")
                    .font(.system(size: 16))
            }
            .padding(.horizontal)
            
            Slider(value: .constant(0.5))
                .padding(.horizontal)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        
    }
}

#Preview {
    LectureNoteView()
}
