//
//  StartView.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @State private var yourName = UIDevice.current.name
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Picker("Selecione o jogo", selection: $gameType) {
                    Text("Selecione um tipo de jogo").tag(GameType.undetermined)
                    Text("Compartilhe o celular").tag(GameType.single)
                    Text("Desafie seu celular").tag(GameType.bot)
                    Text("Desafie um amigo").tag(GameType.peer)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
                Text(gameType.description)
                    .padding()
                VStack{
                    switch gameType {
                    case .single:
                        TextField("Seu nome", text: $yourName)
                        TextField("Nome do oponente", text: $opponentName)
                    case .bot:
                        TextField("Seu nome", text: $yourName)
                    case .peer:
                        MPPeersView(startGame: $startGame)
                            .environmentObject(connectionManager)
                    case .undetermined:
                        EmptyView()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .frame(width: 350)
                if gameType != .peer {
                    Button("Iniciar") {
                        game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                        focus = false
                        startGame.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        gameType == .undetermined ||
                        gameType == .single && (opponentName.isEmpty || yourName.isEmpty) ||
                        gameType == .bot && yourName.isEmpty
                    )
                    Image("LaunchScreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Resta um")
            .fullScreenCover(isPresented: $startGame){
                GameView()
                    .environmentObject(connectionManager)
            }
            .inNavigationStack()
            .onAppear {
                game.reset()
            }
        }
    }
}

#Preview {
    StartView(yourName: "")
        .environmentObject(GameService())
}
