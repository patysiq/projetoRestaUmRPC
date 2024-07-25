//
//  GameCircle.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI
import Foundation

struct GameCircle {
    var id: Int
    var image: Image
    var player: Player?
  
    static var reset: [GameCircle] {
        var circles = [GameCircle]()
        for index in 0...48 {
            var image: Image {
                if (index == 0 || index == 1 || index == 5 || index == 6 || index == 7 || index == 8 || index == 12 || index == 13 || index == 35 || index == 36 || index == 40 || index == 41 || index == 42 || index == 43 || index == 47 || index == 48) {
                    return GamePiece.none.image
                } else if index != 24 {
                    return GamePiece.o.image
                } else {
                    return GamePiece.x.image
                }
            }
            circles.append(GameCircle(id: index, image: image))
        }
        return circles
    }
}
