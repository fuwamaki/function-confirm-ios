//
//  GitHubRepositoryModel.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/25.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit

struct Repository {
    var id: Int
    var fullName: String
    var stargazersCount: Int
    var avatarUrl: URL
    var htmlUrl: URL
    var image: UIImage?
    
    init(id: Int, fullName: String, stargazersCount: Int, avatarUrl: URL, htmlUrl: URL, image: UIImage? = nil) {
        self.id = id
        self.fullName = fullName
        self.stargazersCount = stargazersCount
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}

protocol gitHubRepositoryListEventHandler {
    func getGitHubRepositoryList(_ programmingLanguage: String)
    func getRepositoryImageList(id: Int, imageUrl: URL)
}

protocol gitHubRepositoryListUserInterface {
    func loadGitHubRepositoryList(_ items: [Repository]?)
    func registItemImage(id: Int, image: UIImage)
    func showErrorAlert(_ errorMessage: String)
}

class GitHubRepositoryModel: NSObject, gitHubRepositoryListEventHandler {
    
    var userInterface: gitHubRepositoryListUserInterface?
    
    private struct Constant {
        static let httpsScheme = "https"
        static let githubHost = "api.github.com"
        static let githubPath = "/search/repositories"
        static let queryQName = "q"
        static let queryQValue = "language:"
        static let querySortName = "sort"
        static let querySortValueStars = "stars"
        static let queryOrderName = "order"
        static let queryOrderValueDesc = "desc"
    }
    
    func createUrl(_ programmingLanguage: String) -> URL? {
        var components = URLComponents()
        components.scheme = Constant.httpsScheme
        components.host = Constant.githubHost
        components.path = Constant.githubPath
        let queryItemLanguage = URLQueryItem(name: Constant.queryQName, value: Constant.queryQValue + programmingLanguage)
        let queryItemSort = URLQueryItem(name: Constant.querySortName, value: Constant.querySortValueStars)
        let queryItemOrder = URLQueryItem(name: Constant.queryOrderName, value: Constant.queryOrderValueDesc)
        components.queryItems = [queryItemLanguage, queryItemSort, queryItemOrder]
        return components.url
    }
    
    func getGitHubRepositoryList(_ programmingLanguage: String) {
        guard let url = createUrl(programmingLanguage) else {
            return
        }
        getApiRequest(url, success: { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let list = json?["items"] as? [[String: Any]] else {
                    return
                }
                let repositoryList = list.compactMap({ (val) -> Repository? in
                    if let id = val["id"] as? Int,
                        let fullName = val["full_name"] as? String,
                        let stargazersCount = val["stargazers_count"] as? Int,
                        let owner = val["owner"] as? [String: Any],
                        let avatarUrl = owner["avatar_url"] as? String,
                        let avatarURL = URL(string: avatarUrl),
                        let htmlUrl = val["html_url"] as? String,
                        let htmlURL = URL(string: htmlUrl) {
                        return Repository(id: id, fullName: fullName, stargazersCount: stargazersCount, avatarUrl: avatarURL, htmlUrl: htmlURL)
                    } else {
                        return nil
                    }
                })
                self.userInterface?.loadGitHubRepositoryList(repositoryList)
            } catch (_) {
                print("Serializeエラーが発生しました。")
            }
        }) { errorMessage in
            self.userInterface?.showErrorAlert(errorMessage)
        }
    }
    
    func getRepositoryImageList(id: Int, imageUrl: URL) {
        getApiRequest(imageUrl, success: { data in
            if let image = UIImage(data: data) {
                self.userInterface?.registItemImage(id: id, image: image)
            }
        }) { errorMessage in
            print(errorMessage)
//            self.userInterface?.showErrorAlert(errorMessage)
        }
    }
    
    func getApiRequest(_ url: URL, success:@escaping(Data) -> Void, error:@escaping(String) -> Void) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        let task: URLSessionDataTask = session.dataTask(with: url) { (data, response, err) -> Void in
            if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 {
                success(data)
            } else {
                error("API Request Error")
            }
        }
        task.resume()
    }
}
