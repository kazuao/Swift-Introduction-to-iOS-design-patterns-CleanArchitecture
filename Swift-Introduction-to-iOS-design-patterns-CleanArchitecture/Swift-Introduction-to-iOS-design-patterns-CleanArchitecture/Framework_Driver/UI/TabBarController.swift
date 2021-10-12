//
//  TabBarController.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import UIKit

class TabBarController: UITabBarController {

    override func awakeFromNib() {
        let useCase: ReposLikesUseCase! = Application.shared.useCase
        
        // Interface adapter
        let reposPresenter = ReposPresenter(useCase: useCase)
        useCase.output = reposPresenter
        
        // PresenterをViewControllerにチュウチュウ
        inject(presenter: reposPresenter)
    }
    
    private func inject(presenter: ReposPresenterProtocol) {
        viewControllers?.forEach { vc in
            inject(presenter: presenter, into: vc)
        }
    }
    
    private func inject(presenter: ReposPresenterProtocol, into vc: UIViewController) {
        switch vc {
        case let injectable as ReposPresenterInjectable:
            injectable.inject(reposPresenter: presenter)
            
        case let navVC as UINavigationController:
            if let topVC = navVC.topViewController {
                inject(presenter: presenter, into: topVC)
            }
        default: break
        }
    }
}
