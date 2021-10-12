//
//  UserDefaultsDataStore.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import Foundation

protocol UserDefaultsProtocol {
    func dictionary(forKey defaultName: String) -> [String: Any]?
    func string(forKey defaultName: String) -> String?
    
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

final class UserDefaultsDataStore: DataStoreProtocol {
    
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    func fetch(ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> ()) {
        let all = allLikes()
        let result = all.filter { k, v -> Bool in
            ids.contains { $0 == k }
        }
        completion(.success(result))
    }
    
    func save(liked: Bool, for id: GitHubRepo.ID, completion: @escaping (Result<Bool>) -> ()) {
        var all = allLikes()
        all[id] = liked
        
        let pairs = all.map { k, v in (k.rawValue, v) }
        let newAll = Dictionary(uniqueKeysWithValues: pairs)
        userDefaults.set(newAll, forKey: "likes")
        
        completion(.success(liked))
    }
    
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID : Bool]>) -> ()) {
        completion(.success(allLikes()))
    }
    
    private func allLikes() -> [GitHubRepo.ID: Bool] {
        if let dictionary = userDefaults.dictionary(forKey: "likes") as? [String: Bool] {
            let pair = dictionary.map { k, v in (GitHubRepo.ID(rawValue: k), v) }
            let likes = Dictionary(uniqueKeysWithValues: pair)
            return likes
        } else {
            return [:]
        }
    }
    
    func save(repos: [GitHubRepo], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        
        do {
            try repos.forEach { repo in
                let encoder = JSONEncoder()
                let data = try encoder.encode(repo)
                let jsonString = String(data: data, encoding: .utf8)
                userDefaults.set(jsonString, forKey: repo.id.rawValue)
            }
            completion(.success(repos))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> ()) {
        
        let decoder = JSONDecoder()
        do {
            var result = [GitHubRepo]()
            for id in ids {
                if let jsonString = userDefaults.string(forKey: id.rawValue),
                   let data = jsonString.data(using: .utf8)
                {
                    let repo: GitHubRepo = try decoder.decode(GitHubRepo.self, from: data)
                    result.append(repo)
                }
            }
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
