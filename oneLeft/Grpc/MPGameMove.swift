//
//  MPGameMove.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import Foundation
import SwiftUI

struct MPGameMove: Codable {
    enum Action: Int, Codable {
        case start, move, reset, end
    }
    let action: Action
    let playerName: String?
    let board:[Int]?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
