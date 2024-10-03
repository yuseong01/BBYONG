//
//  NoteView.swift
//  BBYONG
//
//  Created by yuseong on 8/9/24.
//

import SwiftUI

struct NoteView: View {
    
    func loadImage(imageName : String, textTitle : String) -> some View{
        VStack(alignment:.center){
            Image(imageName)
                .resizable()
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(textTitle)
                .font(.title3)
        }
    }
    
    var body: some View {
        
        var noteList: [Note] = [
            Note(title: "운영체제 강의"),
            Note(title: "자료구조란?"),
            Note(title: "기초부터 배우는 Swift")
        ]
        
        NavigationStack{
            VStack(alignment:.leading){
                Text("BBYONG NOTE✨")
                    .font(.title2)
                Divider()
                ScrollView(.horizontal){
                    HStack{
                        loadImage(imageName: "summary", textTitle: "강의내용요약")
                        loadImage(imageName: "translation", textTitle: "강의번역지원")
                        loadImage(imageName: "share", textTitle: "SNS공유")
                        loadImage(imageName: "textExtraction", textTitle: "텍스트자동추출")
                    }
                }.scrollIndicators(/*@START_MENU_TOKEN@*/.hidden/*@END_MENU_TOKEN@*/)
                
                
                List{
                    
                    ForEach(noteList) { note in
                        HStack{
                            Image(systemName: "note.text")
                                .resizable()
                                .frame(width: 23,height: 19)
                                .foregroundColor(.red)
                                .padding(.vertical)
                                .padding(.trailing)
                            NavigationLink(destination: LectureNoteView()) {
                                Text(note.title)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.top)
                Spacer()
                
            }.padding()
        }
    }
}



#Preview {
    NoteView()
}
