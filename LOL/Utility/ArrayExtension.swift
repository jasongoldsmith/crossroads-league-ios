//
//  ArrayExtension.swift
//  Traveler
//
//  Created by Ashutosh on 8/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var result: [Element] = []
        for element in self {
            guard !result.contains(element) else { continue }
            result.append(element)
        }
        
        return result
    }
}
