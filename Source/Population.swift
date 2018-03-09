//
//  Population.swift
//  GeneticOptimization
//
//  Created by Bo Gustafsson on 2018-03-01.
//  Copyright © 2018 Bo Gustafsson. All rights reserved.
//

import Foundation

public protocol GeneticAlgoritmDelegate {
    func costFunction(parameterValues: [Double]) -> Double
}

public struct Population {
    
    public var parameters = [Parameter]()
    public var probabilityForCrossOver = Double()
    public var probabilityForMutation = Double()
    public var delegate : GeneticAlgoritmDelegate!
    public var numberOfIndividuals = Int() {
        didSet {
            if numberOfIndividuals != Int(2.0 * Double(numberOfIndividuals / 2)) {
                print("Warning numberOfIndividuals = \(numberOfIndividuals) is uneven")
                print("Warning new value set to \(numberOfIndividuals + 1)")
                numberOfIndividuals += 1
            }
        }
    }
    public var best = Individual() {
        didSet {
            bestValues = getParameterValues(individual: best)
        }
    }
    public var bestValues = [Double]()
    private(set) var individuals = [Individual]()
    
    public init(numberOfIndividuals: Int, parameters: [Parameter], probabilityForCrossOver: Double, probabilityForMutation: Double, delegate: GeneticAlgoritmDelegate) {
        self.numberOfIndividuals = numberOfIndividuals
        self.parameters = parameters
        self.probabilityForCrossOver = probabilityForCrossOver
        self.probabilityForMutation = probabilityForMutation
        self.delegate = delegate
        var bitCount = 0
        for parameter in parameters {
            bitCount += parameter.numberOfBits
        }
        for _ in 0..<numberOfIndividuals {
            var genome = [Int]()
            for _ in 0..<bitCount {
                genome.append(Int(arc4random_uniform(2)))
            }
            var individual = Individual()
            individual.genome = genome
            individuals.append(individual)
        }
        reproductionProbability()
    }
    
    private mutating func reproductionProbability() {
        var costAverage = 0.0
        var costMax = -1.0e10
        var costArray = [Double]()
        for individual in individuals {
            let c = cost(individual: individual)
            costAverage += c
            costMax = max(c, costMax)
            costArray.append(c)
         }
        let noInd = individuals.count
        costAverage = costAverage / Double(noInd)
        if costMax / costAverage > 0.0 {
            let b = -1.0 / (costMax - costAverage) / Double(noInd)
            let a = -b * costMax
            var probSum = 0.0
            var costMin = 1.0e10
            var bestInd = 0
            for i in 0..<noInd {
                individuals[i].cost = costArray[i]
                if costMin > costArray[i] {
                    bestInd = i
                    costMin = costArray[i]
                }
                costArray[i] = a + b * costArray[i]
                probSum += costArray[i]
            }
            if probSum > 0.0 {
                for i in 0..<noInd {
                    individuals[i].reproductionProbability = costArray[i] / probSum
                }
                self.best = individuals[bestInd]
            } else {
                for i in 0..<noInd {
                    individuals[i].reproductionProbability = 1.0 / Double(noInd)
                }
                self.best = individuals.first!
            }
        } else {
            for i in 0..<noInd {
                individuals[i].reproductionProbability = 1.0 / Double(noInd)
            }
            self.best = individuals.first!
        }
    }
    
    public mutating func advanceGeneration() {
        let parents = selectParents()
        let pairs = matingSelection()
        crossOver(parents: parents, pairs: pairs)
        for i in 0..<individuals.count {
            individuals[i].mutation(pMutation: probabilityForMutation)
        }
        reproductionProbability()
    }
    
    private func selectParents() -> [Int] {
        var parents = [Int]()
        for _ in 0..<individuals.count {
            let ind = pickIndividual()
            parents.append(ind)
        }
        return parents
    }
    private func matingSelection() -> [(m: Int, f: Int)] {
        var pairs = [(m: Int, f: Int)]()
        for _ in 0..<individuals.count/2 {
            let index1 = Int(arc4random_uniform(UInt32(individuals.count)))
            var index2 = Int(arc4random_uniform(UInt32(individuals.count)))
            while index1 == index2 {
                index2 = Int(arc4random_uniform(UInt32(individuals.count)))
            }
            let pair = (m: index1, f: index2)
            pairs.append(pair)
        }
        return pairs
    }
    private mutating func crossOver(parents: [Int], pairs: [(m: Int, f: Int)]) {
        var children = [(child1: Individual, child2: Individual)]()
        for i in 0..<individuals.count/2 {
            let parent1 = parents[pairs[i].m]
            let parent2 = parents[pairs[i].f]
            let x = drand48()
            if x <= probabilityForCrossOver {
                let childs = Individual.crossing(parent1: individuals[parent1], parent2: individuals[parent2])
                children.append(childs)
            } else {
                children.append((child1: individuals[parent1], child2: individuals[parent2]))
            }
        }
        for i in 0..<individuals.count/2 {
            individuals[2 * i] = children[i].child1
            individuals[2 * i + 1] = children[i].child2
        }
    }
    
    private func cost(individual: Individual) -> Double {
        let values = getParameterValues(individual: individual)
        return delegate.costFunction(parameterValues: values)
    }
    
    public func getParameterValues(individual: Individual) -> [Double] {
        var firstBit = 0
        var result = [Double]()
        for parameter in parameters {
            let lastBit = firstBit + parameter.numberOfBits
            let slice = Array<Int>(individual.genome[firstBit..<lastBit])
            firstBit = lastBit
            let value = parameter.bits2value(bitVector: slice)
            result.append(value)
        }
        return result
    }
    
    private func pickIndividual() -> Int {
        let x = drand48()
        var probSum = 0.0
        var n = 0
        while x >= probSum {
            probSum += individuals[n].reproductionProbability
            n += 1
        }
        return n -  1
    }

}
