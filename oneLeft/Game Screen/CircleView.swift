//
//  CircleView.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI

struct CircleView: View {
    @EnvironmentObject var game : GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @State private var showingAlert = false
    let index:Int
    
    var body: some View {
        Button {
            if Move.firstIndex == nil {
                Move.firstIndex = index
            } else {
                guard let first = Move.firstIndex else {return}
                guard let indice = Player.checkImage(combination: [first, index]) else {
                    Move.firstIndex =  nil
                    showingAlert = true
                    return }
                if game.gameBoard[index].image == GamePiece.x.image && game.gameBoard[indice].image == GamePiece.o.image && game.gameBoard[first].image == GamePiece.o.image {
                    game.gameBoard[first].image = GamePiece.x.image
                    game.gameBoard[indice].image = GamePiece.x.image
                    game.gameBoard[index].image = GamePiece.o.image
                    Move.moves += 1
                } else {
                    showingAlert = true
                }
                Move.firstIndex =  nil
                if game.checkIfWinner() {
                    game.gameOver = true
                }
                game.toggleCurrent()
                
                if game.gameType == .peer {
                    let gameMove = MPGameMove(action: .move, playerName: connectionManager.myPeerId.displayName, board: [first,indice,index])
                    connectionManager.send(gameMove: gameMove, nil, chat: nil)
                }
            }
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width: 30, height: 30)
        }
        .alert("Jogada inválida", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
        .disabled(game.gameBoard[index].player != nil)
        .foregroundColor(.primary)
    }
}

#Preview {
    CircleView(index: 0)
        .environmentObject(GameService())
        .environmentObject(MPConnectionManager(yourName: "Sample"))
}
