//
//  GameModels.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI

enum GameType {
    case single, bot, peer, undetermined
    
    var description: String {
        switch self {
        case .single:
            return "Compartilhe seu celular e jogue com amigo."
        case .bot:
            return "Jogue com seu celular."
        case .peer:
            return "Convide amigos próximos a você."
        case .undetermined:
            return ""
        }
    }
}

enum GamePiece: String {
    case x, o, none
    var image:Image {
        Image(self.rawValue)
    }
}

struct Player {
    var gamePiece: GamePiece
    var name: String
    var moves: [Int] = []
    var isCurrent = false
    var isWinner: Bool {
        Move.moves == 32 ? true : false
    }
    
    static func checkImage(combination: [Int]) -> Int? {
        switch combination {
        case [2,16]:
            return 9
        case [16,2]:
            return 9
        case [2,4]:
            return 3
        case [4,2]:
            return 3
        case [3,17]:
            return 10
        case [17,3]:
            return 10
        case [4,18]:
            return 11
        case [18,4]:
            return 11
        case [9,11]:
            return 10
        case [11,9]:
            return 10
        case [4,16]:
            return 9
        case [11,25]:
            return 18
        case [25,11]:
            return 18
        case [14,16]:
            return 15
        case [16,14]:
            return 15
        case [14,28]:
            return 21
        case [28,14]:
            return 21
        case [15,17]:
            return 16
        case [17,15]:
            return 16
        case [15,29]:
            return 22
        case [29,15]:
            return 22
        case [16,30]:
            return 23
        case [30,16]:
            return 23
        case [16,18]:
            return 17
        case [18,16]:
            return 17
        case [17,31]:
            return 24
        case [31,17]:
            return 24
        case [17,19]:
            return 18
        case [19,17]:
            return 18
        case [20,18]:
            return 19
        case [18,20]:
            return 19
        case [18,32]:
            return 25
        case [32,18]:
            return 25
        case [33,19]:
            return 26
        case [19,33]:
            return 26
        case [20,34]:
            return 27
        case [34,20]:
            return 27
        case [21,23]:
            return 22
        case [23,21]:
            return 22
        case [22,24]:
            return 23
        case [24,22]:
            return 23
        case [37,23]:
            return 30
        case [23,37]:
            return 30
        case [25,23]:
            return 24
        case [23,25]:
            return 24
        case [10,24]:
            return 17
        case [24,10]:
            return 17
        case [24,26]:
            return 25
        case [26,24]:
            return 25
        case [24,38]:
            return 31
        case [38,24]:
            return 31
        case [25,27]:
            return 26
        case [27,25]:
            return 26
        case [25,39]:
            return 32
        case [39,25]:
            return 32
        case [28,30]:
            return 29
        case [30,28]:
            return 29
        case [29,31]:
            return 30
        case [31,29]:
            return 30
        case [30,44]:
            return 37
        case [44,30]:
            return 37
        case [30,32]:
            return 31
        case [32,30]:
            return 31
        case [31,33]:
            return 32
        case [33,31]:
            return 32
        case [31,45]:
            return 38
        case [45,31]:
            return 38
        case [46,32]:
            return 39
        case [32,46]:
            return 39
        case [32,34]:
            return 33
        case [34,32]:
            return 33
        case [37,39]:
            return 38
        case [39,37]:
            return 38
        case [44,46]:
            return 45
        case [46,44]:
            return 45
        default:
            return nil
        }
    }
}

struct Move {
    static var moves: Int = 0
    
    static var firstIndex: Int?
}
