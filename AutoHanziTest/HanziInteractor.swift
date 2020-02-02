//
//  HanziInteractor.swift
//  AutoHanziTest
//
//  Created by Ghost on 2020/02/02.
//  Copyright © 2020 autogroup. All rights reserved.
//

import Foundation

private enum NetworkError: Error {
    case serialization
    case countFailure
    case noData
}

class HanziInteractor {
    public var updateBlock: (() -> Void)?
    private(set) var totalCount: Int = 0
    
    private var hanziList: [Hanzi] = []
    
    private var requestPage: Int {
        get {
            return self.currentCount / self.pageCount
        }
    }
    
    private var currentCount: Int {
        get {
            return self.hanziList.count
        }
    }
    
    private var totalPage: Int {
        get {
            return self.totalCount / self.pageCount
        }
    }
    
    private let pageCount: Int = 20
    
    func fetchAll() {
        self.getCount { result in
            switch result {
            case .success(let count):
                self.totalCount = count
                self.requestNextPageIfNeeded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func get(_ index: Int) -> Hanzi? {
        guard index < self.totalCount,
            index >= 0 else { return nil }
        
        return self.hanziList[index]
    }
    
    func shuffle() {
        self.hanziList.shuffle()
        self.updateBlock?()
    }
    
    private func getCount(_ completion: ((Result<Int, Error>) -> Void)?) {
        guard let url: URL = URL(string: "http://autorelease.iptime.org:8080/test06/hanziCount") else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { data, response, error in
            guard let dt = data else {
                completion?(.failure(NetworkError.noData))
                return
            }
            
            do {
                guard let jsonObject: [String: Int] = try JSONSerialization.jsonObject(with: dt, options: []) as? [String: Int] else {
                    throw NetworkError.serialization
                }
                
                guard let totalCount: Int = jsonObject["count"] else {
                    throw NetworkError.countFailure
                }
                
                completion?(.success(totalCount))
            } catch let error {
                completion?(.failure(error))
            }
        }.resume()
    }
    
    private func load() {
        guard let url: URL = URL(string: "http://autorelease.iptime.org:8080/test06/hanziApi?page=\(self.requestPage)") else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { [unowned self] data, response, error in
            if let err = error {
                print("\(err)")
                return
            }
            
            guard let dt = data else {
                print("No data")
                return
            }
            
            do {
                let list: [Hanzi] = try JSONDecoder().decode([Hanzi].self, from: dt)
                
                self.hanziList.append(contentsOf: list)
                
                self.requestNextPageIfNeeded()
            } catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    private func requestNextPageIfNeeded() {
        guard self.requestPage < self.totalPage else {
            self.shuffle()
            return
        }
        self.load()
    }
}
