//
//  MPConnectionManager.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import MultipeerConnectivity

extension String {
    static var serviceName = "patricia"
}

class MPConnectionManager: NSObject, ObservableObject {
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    var game: GameService?
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    @Published var chats: Dictionary<Person,Chat> = [:]
    
    var myPerson:Person
    
    func setup(game:GameService) {
        self.game = game
    }
    
    @Published var availablePeers = [MCPeerID]()
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var paired: Bool = false
    
    var isAvailableToPlay: Bool = false {
        didSet {
            if isAvailableToPlay {
                startAdvertising()
            } else {
                stopAdvertising()
            }
        }
    }
    
    init(yourName: String) {
        myPeerId = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerId)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        myPerson = Person(self.session.myPeerID, id: UIDevice.current.identifierForVendor!)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    deinit {
        stopBrowsing()
        stopAdvertising()
    }
    
    func startAdvertising() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        nearbyServiceBrowser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }
    
    func send(gameMove: MPGameMove?,_ messageText: String?,chat: Chat?) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data = gameMove?.data() {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            } catch {
                print("error sending \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                let newMessage = ConnectMessage(messageType: .Message,message: Message(text: messageText ?? "", from: self.myPerson))
                    do {
                        if let data = try? self.encoder.encode(newMessage) {
                            DispatchQueue.main.async {
                                guard let chat = chat else {return}
                                self.chats[chat.person]?.messages.append(newMessage.message!)
                            }
                            guard let chat = chat else {return}
                            try self.session.send(data, toPeers: [chat.peer], with: .reliable)
                        }
                    } catch {
                        print("Error for sending: \(String(describing: error))")
                    }
            }
        }
    }
    
    func reciveInfo(info: ConnectMessage, from:MCPeerID){
        print("Recived Info",info.messageType)
        if(info.messageType == .Message){
            newMessage(message: info.message!,from:from)
        }
        if(info.messageType == .PeerInfo){
            newPerson(person: info.peerInfo!,from:from)
        }
    }
    
    func newConnection(peer:MCPeerID){
        print("New Connection",peer.displayName)
        
        let newMessage = ConnectMessage(messageType: .PeerInfo,peerInfo: self.myPerson)
        do {
            if let data = try? encoder.encode(newMessage) {
                try session.send(data, toPeers: [peer], with: .reliable)
            }
        } catch {
            print("Error for newConnection: \(String(describing: error))")
        }
    }
    
    func newPerson(person:Person,from:MCPeerID){
        print("New Person ",person.name)
        self.chats[person] = Chat(peer:from,person: person)

    }
    
    func newMessage(message:Message,from:MCPeerID){
        print("New Message ",message.text)
        chats[message.from]!.messages.append(message)
    }
}

extension MPConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.availablePeers.remove(at: index)
        }
    }
}

extension MPConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
}

extension MPConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        case .connected:
            DispatchQueue.main.async {
                self.paired = true
                self.isAvailableToPlay = false
                self.newConnection(peer:peerID)
            }
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameMove = try? JSONDecoder().decode(MPGameMove.self, from: data) {
            DispatchQueue.main.async {
                switch gameMove.action {
                case .start:
                    guard let playerName = gameMove.playerName else { return }
                    if self.game?.player1.name == playerName {
                        self.game?.player1.isCurrent = true
                    } else {
                        self.game?.player2.isCurrent = true
                    }
                case .move:
                    guard let boardId = gameMove.board else {return}
                    self.game?.gameBoard[boardId[0]].image = GamePiece.x.image
                    self.game?.gameBoard[boardId[1]].image = GamePiece.x.image
                    self.game?.gameBoard[boardId[2]].image = GamePiece.o.image
                case .reset:
                    self.game?.reset()
                case .end:
                    self.session.disconnect()
                    self.isAvailableToPlay = true
                }
            }
        }
        
        if let message = try? decoder.decode(ConnectMessage.self, from: data) {
            DispatchQueue.main.async {
                self.reciveInfo(info: message,from: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
