//
//  DictionaryExtension.swift
//  LOL
//
//  Created by Ashutosh on 1/19/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}