//
//  UsersSortedListWorker.swift
//  Task
//
//  Created by Artashes Nok Nok on 3/20/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift

class UsersSortedListWorker
{
    var networkAPI = NetworkAPI(baseUrl: Constants.Network.BaseURL!)
    func getUsers() -> Observable<[User]>
    {
        return networkAPI.getUsersQuery()
    }
}
