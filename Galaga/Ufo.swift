//
//  uof.swift
//  Galaga
//
//  Created by Harsh Parikh on 2019-06-20.
//  Copyright © 2019 Pranav Patel. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Ufo{
    var ufos = Array<SKSpriteNode>()
    
    init() {
        
        //single sprite of enemy1
        let ufo = SKSpriteNode(imageNamed: "ufo")
        
        // array of enemy1
        for _ in 0...4 {
            ufos.append(ufo)
        }
    }
    
    func getUfo() -> [SKSpriteNode] {
        return ufos
    }
}
