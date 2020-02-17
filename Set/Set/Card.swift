//
//  Card.swift
//  Set
//
//  Created by Глеб Уваркин on 13/02/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct Card : Equatable {
    enum Variant : Int {
        case v1 = 0
        case v2
        case v3
        
        static func getAll() -> [Variant] {
            return [.v1, .v2, .v3]
        }
        
        func getType() -> Int {
            return self.rawValue
        }
    }
    
    let number: Variant
    let color: Variant
    let shape: Variant
    let fill: Variant
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.number == rhs.number && lhs.color == rhs.color && lhs.shape == rhs.shape && lhs.fill == rhs.fill ? true : false
    }
}
