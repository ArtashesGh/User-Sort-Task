//
//  UserPageInteractor.swift
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

protocol UserPageBusinessLogic
{
    func doFetchData()
}

protocol UserPageDataStore
{
    var userElement: UserDispleyedModel { get set }
}

class UserPageInteractor: UserPageBusinessLogic, UserPageDataStore
{
    var presenter: UserPagePresentationLogic?
    var worker: UserPageWorker?
    var userElement: UserDispleyedModel = UserDispleyedModel()
    
    // MARK: Do something
    
    func doFetchData()
    {
        worker = UserPageWorker()
        worker?.doSomeWork()
        
        let response = UserPage.FetchData.Response(userElement: userElement)
        presenter?.presentFetchData(response: response)
    }
}
