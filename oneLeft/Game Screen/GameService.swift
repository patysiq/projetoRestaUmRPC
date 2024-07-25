//
//  GameService.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI
import UIKit

@MainActor
class GameService: ObservableObject {
    @Published var player1 = Player(gamePiece: .x, name: "Jogador 1")
    @Published var player2 = Player(gamePiece: .x, name: "Jogador 2")
    @Published var firstIndex = Int()
    @Published var secondIndex = Int()
    @Published var gameOver = false
    @Published var gameBoard = GameCircle.reset
    
    var gameType = GameType.single
    
    var currentPlayer: Player {
        if player1.isCurrent {
            return player1
        } else {
            return player2
        }
    }
    
    var gameStarted: Bool {
        player1.isCurrent || player2.isCurrent
    }
    
    var boardDisabled: Bool {
        gameOver || !gameStarted
    }
    
    func setupGame(gameType: GameType, player1Name: String, player2Name: String) {
        switch gameType {
        case .single:
            self.gameType = .single
            player2.name = player2Name
        case .bot:
            self.gameType = .bot
        case .peer:
            self.gameType = .peer
        case .undetermined:
            break
        }
        player1.name = player1Name
    }
    
    func reset() {
        player1.isCurrent = false
        player2.isCurrent = false
        player1.moves.removeAll()
        player2.moves.removeAll()
        gameOver = false
        gameBoard = GameCircle.reset
    }
    
    func checkIfWinner() -> Bool{
        var count = 0
        for index in 0...48 {
            if gameBoard[index].image == GamePiece.o.image {
                count += 1
            }
        }
        return count == 1
    }
    
    func toggleCurrent() {
        player1.isCurrent.toggle()
        player2.isCurrent.toggle()
    }
    
}
