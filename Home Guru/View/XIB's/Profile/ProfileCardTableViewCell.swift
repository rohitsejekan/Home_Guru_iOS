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
}

class ProfileCardTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dobDetailsLabel: UILabel!
    var studentList : [[String:Any]] = [["name":"abc","class":"8th","dob":"26/11/2001"]]
    var delegate : ProfileEditProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSelectedProfile(index: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
    }


    @IBAction func editProfileAction(_ sender: UIButton) {
        delegate?.editProfile(index: sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studentList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
        if indexPath.item == studentList.count {
            cell?.profileNameLabel.text = "Add Profile"
            cell?.profileImageView.image = UIImage(named: "add")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == studentList.count {
            delegate?.addProfile()
        } else {
            showSelectedProfile(index: indexPath.item)
        }
    }
    
    func showSelectedProfile(index: Int) {
        studentNameLabel.text = studentList[index]["name"] as! String
        classLabel.text = studentList[index]["class"] as! String
        dobDetailsLabel.text = studentList[index]["dob"] as! String
    }
    
}
