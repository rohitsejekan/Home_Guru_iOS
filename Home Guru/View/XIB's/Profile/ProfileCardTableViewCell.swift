//
//  ProfileCardTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
protocol ProfileEditProtocol {
    func editProfile(index: Int)
    func addProfile()
    func switchProfile(index: Int)
}

class ProfileCardTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
 
    
   
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dobDetailsLabel: UILabel!
    var arr = [myChildren]()
    var myChildrenCount = Int()
    var profileVC: profileSwitchViewController?
    var studentList : [[String:Any]] = [["name":"abc","class":"8th","dob":"26/11/2001"]]
    var delegate : ProfileEditProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSelectedProfile(index: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
        
        //print("any....\(myChildrens.count)")
    }

   func configure(with arr: [myChildren]) {
         print("any....\(arr)")
         self.arr = arr
         self.collectionView.reloadData()
         self.collectionView.layoutIfNeeded()
     }
    @IBAction func editProfileAction(_ sender: UIButton) {
        delegate?.editProfile(index: sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
        if indexPath.item == arr.count {
            cell?.profileNameLabel.text = "Add Profile"
            cell?.profileImageView.image = UIImage(named: "add")
        }else{
            cell?.profileNameLabel.text = arr[indexPath.row].name
            cell?.profileImageView.image = UIImage(named: "Avatar 2")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == arr.count {
            delegate?.addProfile()
        } else {
            showSelectedProfile(index: indexPath.item)
        }
    }
    
    func showSelectedProfile(index: Int) {
        delegate?.switchProfile(index: index)
//        if !arr.isEmpty{
////            print("selected id..\(arr[index]._id)")
//            StructOperation.glovalVariable.studentId = arr[index]._id
//            print("stu id....\(StructOperation.glovalVariable.studentId)")
//            studentNameLabel.text = arr[index].name
//            classLabel.text = "CLASS - " + arr[index].stdClass
//            dobDetailsLabel.text = arr[index].dob
//        }
     
    }
    
}
