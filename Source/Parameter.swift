//
//  Parameter.swift
//  GeneticOptimization
//
//  Created by Bo Gustafsson on 2018-03-01.
//  Copyright © 2018 Bo Gustafsson. All rights reserved.
//

import Foundation


public struct Parameter {
    var valueMin = Double()
    var valueMax = Double()
    var numberOfBits = Int()
    func value2Bits(value: Double) -> [Int] {
        let n = Parameter.iPow(base: 2, power: numberOfBits)
        let valueInt = Int((value - valueMin) * Double(n - 1)/(valueMax - valueMin))
        return int2bin(value: valueInt)
    }
    
    func bits2value(bitVector: [Int]) -> Double {
        let n = Parameter.iPow(base: 2, power: numberOfBits)
        let iValue = bin2int(bitVector: bitVector)
        let value = (valueMax - valueMin) * Double(iValue) / Double(n - 1) + valueMin
        return value
    }
    
    private func int2bin(value: Int) -> [Int] {
        var iCopy = value
        var bitVector = [Int]()
        for m in 0..<numberOfBits {
            let n = numberOfBits - 1 - m
            let baseValue = Parameter.iPow(base: 2, power: n)
            let bit = iCopy / baseValue
            iCopy = iCopy - bit * baseValue
            bitVector.append(bit)
        }
        return bitVector
    }

    private func bin2int(bitVector: [Int]) -> Int {
        var iValue = 0
        for m in 0..<numberOfBits {
            let n = numberOfBits -  1 - m
            let baseValue = Parameter.iPow(base: 2, power: n)
            iValue += bitVector[n] * baseValue
        }
        return iValue
    }
    private static func iPow(base: Int, power: Int) -> Int{
        var prod = 1
        for _ in 1...power {
            prod *= base
        }
        return prod
    }

}



