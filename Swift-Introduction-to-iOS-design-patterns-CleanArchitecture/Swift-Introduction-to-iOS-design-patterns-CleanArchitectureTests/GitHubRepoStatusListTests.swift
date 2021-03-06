//
//  GitHubRepoStatusListTests.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitectureTests
//
//  Created by kazunori.aoki on 2021/10/12.
//

import XCTest
@testable import Swift_Introduction_to_iOS_design_patterns_CleanArchitecture

class GitHubRepoStatusListTests: XCTestCase {

    func test_register_repos() {
        do {
            let list = GitHubRepoStatusList(repos: [], likes: [:])
            XCTAssert(list.statuses.count == 0)
        }
        
        do {
            var list = GitHubRepoStatusList(repos: [], likes: [:])
            let repo1 = _makeGitHubRepo(id: "1")
            let repo2 = _makeGitHubRepo(id: "2")
            list.append(repos: [repo1, repo2], likes: [:])
            list.append(repos: [], likes: [repo1.id: false, repo2.id: false])
            XCTAssertEqual(list.statuses.count, 2)
        }
        
        do {
            var list = GitHubRepoStatusList(repos: [], likes: [:])
            let repo1 = _makeGitHubRepo(id: "1")
            list.append(repos: [repo1], likes: [repo1.id: false, _makeID("2"): false])
            XCTAssertEqual(list.statuses.count, 1)
            XCTAssertThrowsError(try list.set(isLiked: true, for: _makeID("2")))

            let repo2 = _makeGitHubRepo(id: "2")
            list.append(repos: [repo1, repo2], likes: [:])
            XCTAssertEqual(list.statuses.count, 2)
            XCTAssertNoThrow(try list.set(isLiked: true, for: _makeID("2")))
        }
    }
    
    func test_like_repo() {
        var list = GitHubRepoStatusList(repos: [], likes: [:])

        let repo1 = _makeGitHubRepo(id: "1")
        list.append(repos: [repo1], likes: [:])
        // Update like status from false to true
        XCTAssertNoThrow(try list.set(isLiked: true, for: _makeID("1")))
        XCTAssertEqual(list[_makeID("1")]?.repo.id, _makeID("1"))
        XCTAssertNotNil(list[_makeID("1")]?.isLiked)
        XCTAssertEqual(list[_makeID("1")]?.isLiked, true)
        XCTAssertThrowsError(try list.set(isLiked: true, for: _makeID("2")))

        // Update like status from true to false
        XCTAssertNoThrow(try list.set(isLiked: false, for: _makeID("1")))
        XCTAssertEqual(list[_makeID("1")]?.isLiked, false)
    }
}


private extension GitHubRepoStatusListTests {
    
    private func _makeGitHubRepo(id: String="", fullName: String="", description: String="",
                                 language: String="", stargazersCount: Int=0) -> GitHubRepo {
         return GitHubRepo(id: _makeID(id), fullName: fullName, description: description,
                           language: language, stargazersCount: stargazersCount)
    }
    
    private func _makeID(_ id: String) -> GitHubRepo.ID {
        return GitHubRepo.ID(rawValue: id)
    }
}
