//
//  Result.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
