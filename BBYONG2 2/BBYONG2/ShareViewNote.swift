import SwiftUI

struct ShareViewNote: View {
    var title: String
    var author: String
    var duration: String
    var likes: String
    
    @State private var selectedTab: Tab = .voiceRecord
    @State private var dateString = ""
    
    enum Tab {
        case voiceRecord
        case memoSummary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(dateString)
                .padding(.leading, 30)
                .padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("고미숙 작가의 강의 참석 \n: 연암 박지원의 열하일기")
                    .font(.title)
                    .padding(.leading, 30)
                    .padding(.top, 5)
                
                HStack {
                    Button(action: {
                        selectedTab = .voiceRecord
                    }) {
                        Text("음성기록")
                            .font(.headline)
                            .padding()
                            .padding(.leading, 60)
                    }
                    
                    Spacer()
                    
                    Divider()
                        .frame(height: 40)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .memoSummary
                    }) {
                        Text("강의요약")
                            .font(.headline)
                            .padding()
                    }
                }
                .padding(.horizontal, 30)
                
                // NoteContentsView() 추가
                NoteContentsView()
            }
            
            Spacer()
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

struct NoteContent: View {
    var body: some View {
        Text("노트 내용")
            .padding()
    }
}

#Preview {
    ShareViewNote(title: "샘플 제목", author: "작가 이름", duration: "5:00", likes: "20")
}
