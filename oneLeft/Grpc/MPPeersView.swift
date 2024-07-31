//
//  MPPeersView.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//
import SwiftUI

struct MPPeersView: View {
    
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    var body: some View {
        VStack {
            Text("Jogadores próximos")
            List(connectionManager.availablePeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName)
                    Spacer()
                    Button("Selecione") {
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManager.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Convite enviado de \(connectionManager.receivedInviteFrom?.displayName ?? "Não identificado")",
                       isPresented: $connectionManager.receivedInvite) {
                    Button("Aceito") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(true, connectionManager.session)
                            game.player1.name = connectionManager.receivedInviteFrom?.displayName ?? "Não identificado"
                            game.player2.name = connectionManager.myPeerId.displayName
                            game.gameType = .peer
                        }
                    }
                    Button("Rejeitado") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                }
            }
        }
        .onAppear {
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) {newValue in
            startGame = newValue
        }
    }
}

struct MPPeersView_Previews: PreviewProvider {
    static var previews: some View {
        MPPeersView(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
}
