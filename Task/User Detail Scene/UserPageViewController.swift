//
//  UserPageViewController.swift
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
import SDWebImage

protocol UserPageDisplayLogic: class
{
    func displayFetchData(viewModel: UserPage.FetchData.ViewModel)
}

class UserPageViewController: UIViewController, UserPageDisplayLogic
{
    var interactor: UserPageBusinessLogic?
    var router: (NSObjectProtocol & UserPageRoutingLogic & UserPageDataPassing)?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoenNumberLabel: UILabel!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = UserPageInteractor()
        let presenter = UserPagePresenter()
        let router = UserPageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doFetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.borderWidth = 2.5
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        backView.roundCorners(corners: [.topLeft, .topRight], radius: 23.0)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doFetchData()
    {
        interactor?.doFetchData()
    }
    
    func displayFetchData(viewModel: UserPage.FetchData.ViewModel)
    {
        nameLabel.text = viewModel.userData.fullName
        mailLabel.text = viewModel.userData.email
        phoenNumberLabel.text = viewModel.userData.phoneNumber
        locationLabel.text = viewModel.userData.addres
        avatarImageView.sd_setImage(with: URL(string:  viewModel.userData.avatar ?? ""), placeholderImage: UIImage(named: ""))
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
