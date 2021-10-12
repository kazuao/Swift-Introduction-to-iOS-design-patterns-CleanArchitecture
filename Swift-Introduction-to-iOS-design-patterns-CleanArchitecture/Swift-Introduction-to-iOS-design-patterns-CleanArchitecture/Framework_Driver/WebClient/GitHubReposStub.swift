//
//  GitHubReposStub.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

class GitHubReposStub: WebClientProtocol {
    
    func fetch(using keyword: [String], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        let repos = (0..<5).map{ GitHubRepo(id: GitHubRepo.ID(rawValue: "repos/\($0)"),
                                            fullName: "repos/\($0)",
                                            description: "my awesome project",
                                            language: "swift",
                                            stargazersCount: $0)
        }
        completion(.success(repos))
    }
}
