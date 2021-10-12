//
//  RepositoryCellWithLike.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import UIKit

class RepositoryCellWithLike: UITableViewCell {
    
    // MARK: class variable
    public class var identifier: String {
        return String(describing: self)
    }
    
    public class var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: self))
    }
    
    
    // MARK: UI
    @IBOutlet private(set) weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet private(set) weak var repositoryNameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var languageContainerView: UIView!
    @IBOutlet private(set) weak var languageLabel: UILabel!
    @IBOutlet private(set) weak var starLabel: UILabel!
    @IBOutlet private(set) weak var likedLabel: UILabel!
    
 
    // MARK: Public
    func configure(with viewData: GitHubRepoViewData) {
        repositoryNameLabel.text = viewData.fullName

        descriptionLabel.isHidden = false
        descriptionLabel.text = viewData.description

        languageContainerView.isHidden = false
        languageLabel.text = viewData.language

        starLabel.text = "★ \(viewData.stargazersCount)"

        likedLabel.text = viewData.isLiked ? "❤️" : "♡"
    }
}
