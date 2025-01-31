//
//  ChateView.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI
import MultipeerConnectivity


struct ChatView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    let person: Person
    
    @State private var newMessage: String = ""


    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                VStack {
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(connectionManager.chats[person]!.messages,id:\.id){ message in
                                ChatMessageRow(message: message,geo:geometry)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .onChange(of: connectionManager.chats[person]!.messages) { new in
                        DispatchQueue.main.async {
                            if let last = connectionManager.chats[person]!.messages.last{
                                withAnimation(.spring()){
                                    scrollView.scrollTo(last.id)
                                }
                            }else{
                                print("perdeu conexão")
                            }
                        }
                    }
                    HStack {
                        TextField("Enter a message", text: $newMessage,axis: .vertical)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .animation(.spring())
                            .padding(.horizontal)

                        if !newMessage.isEmpty {
                            Button {
                                if(!newMessage.isEmpty){
                                    DispatchQueue.main.async {
                                        connectionManager.send(gameMove: nil, newMessage, chat: connectionManager.chats[person]!)
                                        newMessage = ""
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                       if let last = connectionManager.chats[person]!.messages.last{
                                           withAnimation(.spring()){
                                               scrollView.scrollTo(last.id)
                                           }
                                       }
                                    }
                                    
                               }
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            .animation(.spring())
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
}
