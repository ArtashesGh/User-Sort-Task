//
//  UsersSortedListInteractor.swift
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
import CoreData


protocol UsersSortedListBusinessLogic
{
    func getUserList(request: UsersSortedList.FetchData.Request)
}

protocol UsersSortedListDataStore
{
    var userElement: UserDispleyedModel { get set }
}

class UsersSortedListInteractor: UsersSortedListBusinessLogic, UsersSortedListDataStore
{
    var presenter: UsersSortedListPresentationLogic?
    var worker: UsersSortedListWorker?
    var userElement: UserDispleyedModel = UserDispleyedModel()
    let bag = DisposeBag()
    let dispossible = CompositeDisposable()
    var userList: [NSManagedObject] = []
    
    
    
    // MARK: Do something
    
    func getUserList(request: UsersSortedList.FetchData.Request)
    {
        
        if Reachability.isConnectedToNetwork(){
            worker = UsersSortedListWorker()
            _ = worker?.getUsers()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (userScripts) in
                    guard let strongSelf = self else { return }
                    
                    let elements = strongSelf.removeElementsUnder20(with: userScripts)
                    strongSelf.save(users: elements)
                    
                    let sortedElement = strongSelf.sortUsersByAgeGroup(with: elements)
                    let response = UsersSortedList.FetchData.Response(displeydUserList: sortedElement)
                    strongSelf.presenter?.presentData(response: response)
                }, onError: { [weak self] (error) in
                    guard self != nil else { return }
                    
                    
                })
            dispossible.disposed(by:bag)
        }else{
            let newdata = self.converttManagedObgectToDispleyObject(with: self.fetchDatafromeCoreData())
            let sortedElement = self.sortUsersByAgeGroup(with: newdata)
            let response = UsersSortedList.FetchData.Response(displeydUserList: sortedElement)
            self.presenter?.presentData(response: response)
        }
        
    }
    
    func removeElementsUnder20(with users:[User]) -> [UserDispleyedModel]  {
        var userDispleyedModelsList:[UserDispleyedModel] = []
        for element in users {
            if let userAge = element.dob?.age {
                if userAge > 20 {
                    let fullName:String = (element.name?.first ?? "") + " " + (element.name?.last ?? "")
                    let address:String = (element.location?.city ?? "") + " " + (element.location?.country ?? "")
                    
                    let userDispElement:UserDispleyedModel! = UserDispleyedModel(fullName: "\(fullName)",
                                                                                 addres: "\(address)",
                                                                                 phoneNumber: "\(element.phone ?? "")",
                                                                                 email: "\(element.email ?? "")",
                                                                                 gender: "\(element.gender ?? "")",
                                                                                 avatar: "\(element.picture?.medium ?? "")",
                                                                                 age: element.dob?.age)
                    userDispleyedModelsList.append(userDispElement)
                }
            }
        }
        return  userDispleyedModelsList
    }
    
    func sortUsersByAgeGroup(with userDispleyElement:[UserDispleyedModel]) -> [UsersListDispleyedModel] {
        var ageRange: String = ""
        var displedElement:[UsersListDispleyedModel] = []
        var usersList: UsersListDispleyedModel = UsersListDispleyedModel()
        var usersList1: UsersListDispleyedModel = UsersListDispleyedModel()
        var usersList2: UsersListDispleyedModel = UsersListDispleyedModel()
        var userDispleyModeArray: [UserDispleyedModel] = []
        var userDispleyModeArray1: [UserDispleyedModel] = []
        var userDispleyModeArray2: [UserDispleyedModel] = []
        for element in userDispleyElement {
            
            if (element.age >= 20 && element.age < 25) {
                ageRange = "20-25"
                userDispleyModeArray.append(element)
                usersList = UsersListDispleyedModel(ageRange: ageRange, users: self.sortWommensfirst(with: self.sortArrayByAge(with: userDispleyModeArray)))
            }else if element.age >= 25 && element.age < 35 {
                ageRange = "25-35"
                userDispleyModeArray1.append(element)
                usersList1 = UsersListDispleyedModel(ageRange: ageRange, users: self.sortWommensfirst(with: self.sortArrayByAge(with: userDispleyModeArray1)))
            }else if element.age >= 35 {
                ageRange = "35+"
                userDispleyModeArray2.append(element)
                usersList2 = UsersListDispleyedModel(ageRange: ageRange, users:self.sortWommensfirst(with: self.sortArrayByAge(with: userDispleyModeArray2)))
            }
            
        }
        if (usersList.users?.count ?? 0) > 0 {
            displedElement.append(usersList)
        }
        if (usersList1.users?.count ?? 0) > 0 {
            displedElement.append(usersList1)
        }
        if (usersList2.users?.count ?? 0) > 0 {
            displedElement.append(usersList2)
        }
        return displedElement
    }
    
    func sortArrayByAge(with array:[UserDispleyedModel]) -> [UserDispleyedModel] {
        return array.sorted(by: { $0.age < $1.age })
    }
    
    func sortWommensfirst(with array:[UserDispleyedModel]) -> [UserDispleyedModel] {
        var newElementsArray:[UserDispleyedModel] = []
        if array.count > 1 {
            for index in 1...array.count-1 {
                
                if (array[index].age == array[index-1].age){
                    if array[index].gender == "female"  {
                        newElementsArray.append(array[index])
                    }else {
                        newElementsArray.append(array[index-1])
                    }
                }else {
                    newElementsArray.append(array[index-1])
                }
                
            }
            return newElementsArray
        }else {
            return array
        }
        
    }
    
    
    func save(users: [UserDispleyedModel]) {
        deleteAllEntities()
        for user in users {
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            
            let entity =
                NSEntityDescription.entity(forEntityName: "UserListEntities",
                                           in: managedContext)!
            
            let userEntiti = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
            
            userEntiti.setValue(user.fullName, forKeyPath: "name")
            userEntiti.setValue(user.addres, forKeyPath: "addres")
            userEntiti.setValue(user.email, forKeyPath: "email")
            userEntiti.setValue(user.avatar, forKeyPath: "avatar")
            userEntiti.setValue(user.phoneNumber, forKeyPath: "phonenumber")
            userEntiti.setValue(user.age, forKeyPath: "age")
            
            do {
                try managedContext.save()
                userList.append(userEntiti)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchDatafromeCoreData() -> [NSManagedObject] {
        var userListData:[NSManagedObject] = []
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserListEntities")
        
        do {
            userListData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userListData
    }
    
   
    func converttManagedObgectToDispleyObject(with userManaged:[NSManagedObject]) -> [UserDispleyedModel] {
        var getedElements:[UserDispleyedModel] = []
        for element in userManaged {
            let userElement:UserDispleyedModel = UserDispleyedModel(fullName: element.value(forKey: "name") as? String,
                                                                    addres: element.value(forKey: "addres") as? String,
                                                                    phoneNumber: element.value(forKey: "phonenumber") as? String,
                                                                    email: element.value(forKey: "email") as? String,
                                                                    gender: element.value(forKey: "gender") as? String,
                                                                    avatar: element.value(forKey: "avatar") as? String,
                                                                    age: element.value(forKey: "age") as? Int)

            getedElements.append(userElement)
        }
        
        return getedElements
    }
    
    func deleteAllEntities() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let entities = appDelegate.persistentContainer.managedObjectModel.entities
        for entity in entities {
            delete(entityName: entity.name!)
        }
    }

    func delete(entityName: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try appDelegate.persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
}
