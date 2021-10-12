//
//  Error.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

enum FetchingError: Error {
    case failedToFetchRepos(Error)
    case failedToFetchLikes(Error)
    case otherError
}

enum SavingError: Error {
    case failedToSaveLike
}
