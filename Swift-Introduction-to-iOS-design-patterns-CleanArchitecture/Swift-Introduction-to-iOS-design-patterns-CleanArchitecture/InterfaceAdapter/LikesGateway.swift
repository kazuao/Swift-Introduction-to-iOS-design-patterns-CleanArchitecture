//
//  LikesGateway.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

protocol DataStoreProtocol: AnyObject {
    func fetch(ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> ())
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> ())
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> ())
    
    func save(repos: [GitHubRepo], completion: @escaping (Result<[GitHubRepo]>) -> ())
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> ())
}

class LikesGateway: LikesGatewayProtocol {
    private weak var useCase: ReposLikesUseCaseProtocol!
    var dataStore: DataStoreProtocol!
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetch(ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> ()) {
        dataStore.fetch(ids: ids, completion: completion)
    }
    
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> ()) {
        dataStore.save(liked: liked, for: id, completion: completion)
    }
    
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> ()) {
        dataStore.allLikes(completion: completion)
    }
}
