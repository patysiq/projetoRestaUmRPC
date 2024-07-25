//
//  MessageModel.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import Foundation
import MultipeerConnectivity

struct Message: Codable,Hashable {
    let text: String
    let from: Person
    let id: UUID
    
    init(text: String, from: Person) {
        self.text = text
        self.from = from
        self.id = UUID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct Person: Codable,Equatable,Hashable {
    let name: String
    let id: UUID
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    init(_ peer: MCPeerID, id:UUID){
        self.name = peer.displayName
        
        self.id = id
    }
}

struct Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }

    var messages: [Message] = []
    var peer: MCPeerID
    var person:Person
    var id = UUID()

}

struct PeerInfo: Codable{
    enum PeerInfoType: Codable {
        case Person
    }
    var peerInfoType: PeerInfoType = .Person
}

struct ConnectMessage: Codable {
    enum MessageType: Codable {
        case Message
        case PeerInfo
    }
    
    var messageType: MessageType = .Message
    var peerInfo: Person? = nil
    var message: Message? = nil
    
}
