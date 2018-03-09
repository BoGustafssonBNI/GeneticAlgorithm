//
//  Individual.swift
//  GeneticOptimization
//
//  Created by Bo Gustafsson on 2018-03-01.
//  Copyright © 2018 Bo Gustafsson. All rights reserved.
//

import Foundation


public struct Individual {
    var genome = [Int]()
    public var reproductionProbability = Double()
    public var cost = Double()
    
    static func crossing(parent1: Individual, parent2: Individual) -> (child1: Individual, child2: Individual) {
        let cutPoint = Int(arc4random_uniform(UInt32(parent1.genome.count)))
        var child1 = Individual()
        var child2 = Individual()
        child1.genome = Array<Int>(parent1.genome[0..<cutPoint]) + Array<Int>(parent2.genome[cutPoint..<parent2.genome.count])
        child2.genome = Array<Int>(parent2.genome[0..<cutPoint]) + Array<Int>(parent1.genome[cutPoint..<parent1.genome.count])
        return (child1, child2)
    }
    
    mutating func mutation(pMutation: Double) {
        let x = drand48()
        if x < pMutation {
            let n = Int(arc4random_uniform(UInt32(genome.count)))
            genome[n] = genome[n] == 1 ? 0 : 1
        }
    }
}
