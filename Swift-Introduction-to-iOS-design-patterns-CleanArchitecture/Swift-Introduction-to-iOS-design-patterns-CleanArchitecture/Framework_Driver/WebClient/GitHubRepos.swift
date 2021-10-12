//
//  GitHubRepos.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation
import GitHub

class GitHubRepos: WebClientProtocol {
    
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        let query = keywords.joined(separator: " ")
        let session = GitHub.Session()
        let request = SearchRepositoriesRequest(query: query, sort: nil, order: nil, page: nil, perPage: nil)
        
        session.send(request) { result in
            switch result {
            case .success(let response):
                let repos = response.0.items.map { GitHubRepo(repository: $0) }
                completion(.success(repos))
                
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
}

extension GitHubRepo {
    init(repository: Repository) {
        self.init(id: GitHubRepo.ID(rawValue: String(repository.id)),
                  fullName: repository.fullName,
                  description: repository.description ?? "",
                  language: repository.language ?? "",
                  stargazersCount: repository.stargazersCount)
    }
}
