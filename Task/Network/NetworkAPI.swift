//
//  NetworkAPI.swift
//  Task
//
//  Created by Artashes Nok Nok on 3/20/21.
//

import Foundation
import RxSwift

struct Err: Codable {
    var code: String?
    var message: String?
    
}

struct User: Codable {
    var gender: String?
    var name: Name?
    var location: Location?
    var email:String?
    var dob:UserAge?
    var phone:String?
    var picture: UserAvatar?
    
}

struct Name: Codable {
    var title : String?
    var first : String?
    var last : String?
}

struct  Location :Codable {
    var city:String?
    var state:String?
    var country:String?
}

struct UserAge:Codable {
    var age: Int?
}

struct UserAvatar: Codable {
    var large:String?
    var medium:String?
    var thumbnail:String?
    
}


struct NetworkAPI {
    var baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    struct GetUsersResult: Codable {
        var error: Err?
        var results: [User]?
    }
    func getUsersQuery() -> Observable<[User]> {
        return Observable<[User]>.create { obs in
           
            
            let queryItems = [URLQueryItem(name: "results", value: "50")]
            let newUrl = baseUrl.appending(queryItems)!
            
            var request = URLRequest(url: newUrl)
            request.httpMethod = "GET"
           
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let tsk = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard error == nil else {
                    obs.onError(error!)
                    return
                }
                
                guard data != nil else {
                    print("Protocol error: no data received")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response"])
                    obs.onError(error)
                    return
                }
                
                do {
                    let res = try JSONDecoder().decode(GetUsersResult.self, from: data!)
                    if res.error != nil {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])
                        obs.onError(error)
                    } else {
                        obs.onNext(res.results!)
                        obs.onCompleted()
                    }
                } catch let err {
                    print("Format error: \(err)")
                    obs.onError(err)
                }
            })
            tsk.resume()
            return Disposables.create{ tsk.cancel() }
        }
    }

}

