import SwiftUI

struct ShareView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("SHARE YOUR KNOWLEDGE")
                    .font(.title3)
                    .padding(.vertical,10)
                Spacer()
                
                HStack {
                    Button(action: {
                    }) {
                        Text("전체")
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                    }) {
                        Text("쪽 필터")
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.leading,190)
                
                List {
                    NavigationLink(destination: ShareViewNote(title: "고미숙 작가의 강의 참석 : 연암 박지원의 열하일기", author: "앵지", duration: "7:30", likes: "13")) {
                        ListItemView(iconName: "doc.text.fill", iconColor: .blue, title: "고미숙 작가의 강의 참석 : 연암 박지원의 열하일기", author: "앵지", duration: "7:30", likes: "13")
                    }
                    
                    NavigationLink(destination: ShareViewNote(title: "울산 부동산 투자 - 소유 부동산 강의: 원리반수업", author: "도치", duration: "5:45", likes: "30")) {
                        ListItemView(iconName: "doc.text.fill", iconColor: .orange, title: "울산 부동산 투자 - 소유 부동산 강의: 원리반수업", author: "도치", duration: "5:45", likes: "30")
                    }
                    
                    NavigationLink(destination: ShareViewNote(title: "7월 19일 고려대 경영학과 수업", author: "뚜뚜", duration: "11:45", likes: "100")) {
                        ListItemView(iconName: "doc.text.fill", iconColor: .pink, title: "7월 19일 고려대 경영학과 수업", author: "뚜뚜", duration: "11:45", likes: "100")
                    }
                    
                    NavigationLink(destination: ShareViewNote(title: "사진 강의 - 오승환 감독님", author: "jugom", duration: "9:02", likes: "30")) {
                        ListItemView(iconName: "doc.text.fill", iconColor: .green, title: "사진 강의 - 오승환 감독님", author: "jugom", duration: "9:02", likes: "30")
                    }
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
            .navigationBarHidden(true)
        }
    }
}

struct ListItemView: View {
    var iconName: String
    var iconColor: Color
    var title: String
    var author: String
    var duration: String
    var likes: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: iconName)
                .resizable()
                .foregroundColor(iconColor)
                .frame(width: 40, height: 50)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16))
                    .lineLimit(2)
                
                HStack {
                    Text(author)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(duration)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "heart")
                Text(likes)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    ShareView()
}
