//
//  ProfileView.swift
//  BBYONG2
//
//  Created by yuseong on 8/19/24.
//


import SwiftUI

struct ProfileView: View {
    @State private var isEditing = false
    @State private var selectedNote: Note? = nil
    
    var profileNote: [ProfileNote] = [
        ProfileNote(title: "강의: 연암 박지원의 열하일기", author: "앵지", duration: "7:30", likes: "13"),
        ProfileNote(title: "부동산 투자 - 원리반 수업", author: "도치", duration: "5:45", likes: "30"),
        ProfileNote(title: "고려대 경영학과 수업", author: "뚜뚜", duration: "11:45", likes: "100"),
        ProfileNote(title: "사진 강의 - 오승환 감독님", author: "jugom", duration: "9:02", likes: "30")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                ZStack(alignment: .bottomTrailing) {
                    Image("profile_picture")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 120, height: 120)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.top,40)
                    
//                    Button(action: {
//                        isEditing.toggle()
//                    }) {
//                        Image(systemName: "plus.fill")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.gray)
//                            .padding(.leading,40)
//                    }
                }
                
                Text("장유성")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("SJU 학생")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                
                HStack {
                    VStack {
                        Text("120")
                            .font(.headline)
                        Text("포스트")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("300")
                            .font(.headline)
                        Text("팔로워")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("50")
                            .font(.headline)
                        Text("팔로잉")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("공유한 노트")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    ForEach(profileNote) { note in
                        NavigationLink(destination: NoteDetailView(profileNote: note)) {
                            NoteListItemView(profileNote: note)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("MY PROFILE")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isEditing) {
                EditProfileView()
            }
        }
    } 
}

struct ProfileNote: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var duration: String
    var likes: String
}

struct NoteListItemView: View {
    var profileNote: ProfileNote
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .resizable()
                .frame(width: 35, height: 40)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(profileNote.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(profileNote.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(profileNote.duration)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "heart")
                Text(profileNote.likes)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }
}

struct NoteDetailView: View {
    var profileNote: ProfileNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(profileNote.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("작가: \(profileNote.author)")
                .font(.subheadline)
            
            Text("시간: \(profileNote.duration)")
                .font(.subheadline)
            
            Text("좋아요: \(profileNote.likes)")
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
        .navigationTitle("노트 상세")
    }
}

struct EditProfileView: View {
    var body: some View {
        VStack {
            Text("프로필 편집")
                .font(.largeTitle)
                .fontWeight(.bold)
                        
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
