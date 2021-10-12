//
//  ReposGateway.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

protocol WebClientProtocol {
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> ())
}

class ReposGateway: ReposGatewayProtocol {
    private weak var useCase: ReposLikesUseCaseProtocol!
    var webClient: WebClientProtocol!
    var dataStore: DataStoreProtocol!
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        webClient.fetch(using: keywords) { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .failure(let e):
                completion(.failure(e))
                
            case .success(let repos):
                _self.dataStore.save(repos: repos, completion: completion)
            }
        }
    }
    
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        dataStore.fetch(using: ids, completion: completion)
    }
}
