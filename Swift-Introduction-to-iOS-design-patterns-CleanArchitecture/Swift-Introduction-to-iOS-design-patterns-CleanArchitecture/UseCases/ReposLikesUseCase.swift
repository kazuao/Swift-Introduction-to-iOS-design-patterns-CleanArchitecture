//
//  ReposLikesUseCase.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

// Use Caseが外側(Interface Adapters)に公開するインターフェース
protocol ReposLikesUseCaseProtocol: AnyObject {
    func startFetch(using keywords: [String])
    func collectLikedRepos()
    func set(liked: Bool, for repo: GitHubRepo.ID)
    
    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReposLikesUseCaseOutput! { get set }
    var reposGateway: ReposGatewayProtocol! { get set }
    var likesGateway: LikesGatewayProtocol! { get set }
}

protocol ReposLikesUseCaseOutput {
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus])
    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus])
    func useCaseDidReceiveError(_ error: Error)
}

protocol ReposGatewayProtocol {
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> ())
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> ())
}

protocol LikesGatewayProtocol {
    func fetch(ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> ())
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> ())
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> ())
}

// MARK: Use Case
final class ReposLikesUseCase: ReposLikesUseCaseProtocol {
    
    var output: ReposLikesUseCaseOutput!
    var reposGateway: ReposGatewayProtocol!
    var likesGateway: LikesGatewayProtocol!
    
    private var statusList = GitHubRepoStatusList(repos: [], likes: [:])
    private var likesList = GitHubRepoStatusList(repos: [], likes: [:])
    
    func startFetch(using keywords: [String]) {
        reposGateway.fetch(using: keywords) { [weak self] reposResult in
            guard let _self = self else { return }
            
            switch reposResult {
            case .failure(let e):
                _self.output.useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
                
            case .success(let repos):
                let ids = repos.map { $0.id }
                _self.likesGateway.fetch(ids: ids) { [weak self] likesResult in
                    guard let _self = self else { return }
                    
                    switch likesResult {
                    case .failure(let e):
                        self?.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
                        
                    case .success(let likes):
                        let statusList = GitHubRepoStatusList(repos: repos, likes: likes)
                        _self.statusList = statusList
                        _self.output.useCaseDidUpdateStatuses(statusList.statuses)
                    }
                }
            }
        }
    }
    
    func collectLikedRepos() {
        likesGateway.allLikes { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .failure(let e):
                _self.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
                
            case .success(let allLikes):
                let ids = Array(allLikes.keys)
                
                _self.reposGateway.fetch(using: ids) { [weak self] reposResult in
                    guard let _self = self else { return }
                    
                    switch reposResult {
                    case .failure(let e):
                        _self.output.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
                        
                    case .success(let repos):
                        let likesList = GitHubRepoStatusList(repos: repos, likes: allLikes, trimmed: true)
                        _self.likesList = likesList
                        _self.output.useCaseDidUpdateLikesList(likesList.statuses)
                    }
                }
            }
        }
    }
    
    func set(liked: Bool, for id: GitHubRepo.ID) {
        likesGateway.save(liked: liked, for: id) { [weak self] likesResult in
            guard let _self = self else { return }
            
            switch likesResult {
            case .failure:
                _self.output.useCaseDidReceiveError(SavingError.failedToSaveLike)
                
            case .success(let isLiked):
                do {
                    try _self.statusList.set(isLiked: isLiked, for: id)
                    try _self.likesList.set(isLiked: isLiked, for: id)
                    _self.output.useCaseDidUpdateStatuses(_self.statusList.statuses)
                    _self.output.useCaseDidUpdateLikesList(_self.likesList.statuses)
                } catch {
                    _self.output.useCaseDidReceiveError(SavingError.failedToSaveLike)
                }
            }
        }
    }
}
