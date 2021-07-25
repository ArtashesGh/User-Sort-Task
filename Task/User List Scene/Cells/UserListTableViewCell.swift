//
//  UserListTableViewCell.swift
//  Task
//
//  Created by Artashes Nok Nok on 3/20/21.
//

import UIKit
import SDWebImage

protocol UserListTableViewCellDelegate: class {
    func userSelected(user: UserDispleyedModel)
}

extension UserListTableViewCellDelegate {
    
    func userSelected(user:UserDispleyedModel) {
    }
}
   

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: UserListTableViewCellDelegate?
    var userDispleyedElelemnts: [UserDispleyedModel]  = []
    
    func updateCell(with usersData:[UserDispleyedModel]) {
        userDispleyedElelemnts = usersData
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}
extension UserListTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDispleyedElelemnts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        cell.backView.backgroundColor = Constants.ColorsArray.myCollorsArray.randomElement()
        cell.imageView.layer.borderWidth = 1.5
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        cell.userNameLabel.text = userDispleyedElelemnts[indexPath.row].fullName
        cell.imageView.sd_setImage(with: URL(string: userDispleyedElelemnts[indexPath.row].avatar ?? ""), placeholderImage: UIImage(named: ""))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 184, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.userSelected(user: userDispleyedElelemnts[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
