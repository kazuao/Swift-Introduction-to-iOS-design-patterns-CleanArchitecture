//
//  ReposPresenter.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

struct GitHubRepoViewData {
    let id: String
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int
    let isLiked: Bool
}

// 外側（Viewなど）にPresenterが公開するインターフェース
protocol ReposPresenterProtocol: AnyObject {
    func startFetch(using keywords: [String])
    func collectLikedRepos()
    
    func set(liked: Bool, for id: String)
    
    var reposOutput: ReposPresenterOutput? { get set }
    var likesOutput: LikesPresenterOutput? { get set }
}

// GitHubリポジトリの検索View向け出力インターフェース
protocol ReposPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData])
}

// GitHubリポジトリのお気に入り一覧View向け出力インターフェース
protocol LikesPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData])
}

// MARK: Presenter
class ReposPresenter: ReposPresenterProtocol, ReposLikesUseCaseOutput {
    
    private weak var useCase: ReposLikesUseCaseProtocol!
    var reposOutput: ReposPresenterOutput?
    var likesOutput: LikesPresenterOutput?
    
    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.output = self
    }
    
    func startFetch(using keywords: [String]) {
        useCase.startFetch(using: keywords)
    }
    
    func collectLikedRepos() {
        useCase.collectLikedRepos()
    }
    
    func set(liked: Bool, for id: String) {
        useCase.set(liked: liked, for: GitHubRepo.ID(rawValue: id))
    }
    
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus]) {
        let viewDataArray = Array(repoStatus: repoStatuses)
        
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.reposOutput?.update(by: viewDataArray)
        }
    }
    
    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus]) {
        let viewDataArray = Array(repoStatus: likesList)
        
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.likesOutput?.update(by: viewDataArray)
        }
    }
    
    func useCaseDidReceiveError(_ error: Error) {
        // TODO: error
    }
}

extension Array where Element == GitHubRepoViewData {
    init(repoStatus: [GitHubRepoStatus]) {
        self = repoStatus.map {
            return GitHubRepoViewData(id: $0.repo.id.rawValue,
                                      fullName: $0.repo.fullName,
                                      description: $0.repo.description,
                                      language: $0.repo.language,
                                      stargazersCount: $0.repo.stargazersCount,
                                      isLiked: $0.isLiked)
        }
    }
}
