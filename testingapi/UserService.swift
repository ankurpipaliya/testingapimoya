//
//  UserService.swift
//  testingapi
//
//  Created by AnkurPipaliya on 21/07/23.
//

import Foundation
import Moya

enum UserService {
    case createUser(name:String)
    case readUser
    case updateUser(id:Int,name:String)
    case deleteUser(id:Int)
}
extension UserService : TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    //https://jsonplaceholder.typicode.com/users
    var path: String {
        switch self {
        case .readUser, .createUser(_):
            return "/users"
        case .deleteUser(let id), .updateUser(let id , _):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post
        case .readUser:
            return .get
        case .updateUser(_, _):
            return .put
        case .deleteUser(_):
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .readUser, .deleteUser(_):
            return .requestPlain
        case .createUser(let name), .updateUser(_, let name):
            return .requestParameters(parameters: ["name" : name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]?
    {
        return ["Content-Type" : "application/json"]
    }
    
    
}

