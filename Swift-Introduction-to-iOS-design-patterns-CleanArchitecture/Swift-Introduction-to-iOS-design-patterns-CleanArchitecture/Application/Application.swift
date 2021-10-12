//
//  Application.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import UIKit

class Application {
    static let shared = Application()
    private init() {}
    
    // Use Caseを未公開プロパティとして保持
    private(set) var useCase: ReposLikesUseCase!
    
    func configure(with window: UIWindow) {
        buildLayer()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        
        // Use Case
        useCase = ReposLikesUseCase()
        
        // Interface Adapters
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)
        
        // Use Caseとバインド
        useCase.reposGateway = reposGateway
        useCase.likesGateway = likesGateway
        
        // Framework & Drivers
        let webClient = GitHubRepos()
        let likesDataStore  = UserDefaultsDataStore(userDefaults: UserDefaults.standard)
        
        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        reposGateway.dataStore = likesDataStore
        likesGateway.dataStore = likesDataStore
        
        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
        // ここでは、TabBarControllerのswakeFromNib()
    }
}

protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
