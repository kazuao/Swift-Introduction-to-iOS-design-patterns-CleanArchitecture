//
//  GitHubReposStubTest.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitectureTests
//
//  Created by kazunori.aoki on 2021/10/12.
//

import XCTest
@testable import Swift_Introduction_to_iOS_design_patterns_CleanArchitecture

class GitHubReposStubTest: XCTestCase {

    var repos: WebClientProtocol!
    
    override func setUp() {
        repos = GitHubReposStub()
    }
    
    override func tearDown() {
        repos = nil
    }
    
    func test_github_repos_stub() {
        repos!.fetch(using: [""]) { result in
            switch result {
            case .success(let repos):
                XCTAssert(!repos.isEmpty)
            default:
                XCTFail()
            }
        }
    }
}
