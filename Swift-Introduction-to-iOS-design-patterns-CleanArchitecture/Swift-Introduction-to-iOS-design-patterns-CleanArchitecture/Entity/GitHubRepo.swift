//
//  GitHubRepo.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

struct GitHubRepo: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: String
    }
    let id: ID
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int
    
    public static func ==(lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
        return lhs.id == rhs.id
    }
}
