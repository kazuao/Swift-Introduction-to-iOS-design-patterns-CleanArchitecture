//
//  Swift_Introduction_to_iOS_design_patterns_CleanArchitectureTests.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitectureTests
//
//  Created by kazunori.aoki on 2021/10/12.
//

import XCTest
@testable import Swift_Introduction_to_iOS_design_patterns_CleanArchitecture

class Swift_Introduction_to_iOS_design_patterns_CleanArchitectureTests: XCTestCase {

    var dataStore: UserDefaultsDataStore!
    
    override func setUp() {
        dataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)
    }
    
    func test_save_like() {
        let repo = GitHubRepo(id: GitHubRepo.ID(rawValue: "foobar"),
                              fullName: "barbaz",
                              description: "desc",
                              language: "Swift",
                              stargazersCount: 0)
        dataStore.save(liked: true, for: repo.id) { result in
            if case .success(let isLiked) = result {
                XCTAssertTrue(isLiked)
            } else {
                XCTFail("result must be a success.")
            }
        }
    }
    
    func test_save_github_repo() {
        let repo = GitHubRepo(id: GitHubRepo.ID(rawValue: "foobar"),
                              fullName: "barbaz",
                              description: "desc",
                              language: "Swift",
                              stargazersCount: 0)
        dataStore.save(repos: [repo]) { result in
            if case .success(let repo) = result {
                XCTAssertEqual(repo.map(\.fullName), ["barbaz"])
            } else {
                XCTFail("result must be a success.")
            }
        }
    }
}
