//
//  confirmSheduleFirstTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 15/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class confirmSheduleFirstTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var GuruSkills: UILabel!
    @IBOutlet weak var guruName: UILabel!
    @IBOutlet weak var GuruFare: UILabel!
    @IBOutlet weak var datesCV: UICollectionView!
    var arr = [String]()
    var tags : [String] = ["1","2","3","4","5","6","1","2","3","4","5","6"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.GuruFare.layer.cornerRadius = 15
        self.GuruFare.layer.borderWidth = 1
        self.GuruFare.layer.borderColor = UIColor.white.cgColor
        datesCV.delegate = self
        datesCV.dataSource = self
        datesCV.layoutIfNeeded()
    }
    func configure(with arr: [String]) {
          self.arr = arr
          self.datesCV.reloadData()
          self.datesCV.layoutIfNeeded()
      }
//    func getLoad(){
//        datesCV.delegate = self
//               datesCV.dataSource = self
//               datesCV.layoutIfNeeded()
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmScheduleFirst", for: indexPath) as! ConfirmScheduleFirstCollectionViewCell
        cell.datesLabel.text = arr[indexPath.row]
        return cell
    }
    

}
extension confirmSheduleFirstTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.arr[indexPath.row]
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 20.0
        return CGSize(width: cellWidth, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
