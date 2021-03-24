//
//  SelectScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import FSCalendar
class SelectScheduleViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    private weak var calendar: FSCalendar!
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    //also an array of dates to hold value dates between firstDate and lastDate
    private var datesRange: [Date]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        fsCalendar.allowsMultipleSelection = true
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.placeholderType = .none
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func goNext(_ sender: Any) {
//        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ConfirmSchedule") as! ConfirmScheduleViewController
//        //setNavigationBackTitle(title: "Schedule")
//        vc.hidesBottomBarWhenPushed = true
//         presentDetail(vc)
        
       

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectScheduleViewController: FSCalendarDelegate, FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
           // nothing selected:
         if firstDate == nil {
             firstDate = date
             datesRange = [firstDate!]

             print("datesRange contains: \(datesRange!)")

             return
         }

         // only first date is selected:
         if firstDate != nil && lastDate == nil {
             // handle the case of if the last date is less than the first date:
             if date <= firstDate! {
                 calendar.deselect(firstDate!)
                 firstDate = date
                 datesRange = [firstDate!]

                 print("datesRange contains: \(datesRange!)")

                 return
             }

             let range = datesRange(from: firstDate!, to: date)

             lastDate = range.last

             for d in range {
                 calendar.select(d)
             }

             datesRange = range

             print("datesRange contains: \(datesRange!)")

             return
         }

         // both are selected:
         if firstDate != nil && lastDate != nil {
             for d in calendar.selectedDates {
                 calendar.deselect(d)
             }

             lastDate = nil
             firstDate = nil

             datesRange = []

             print("datesRange contains: \(datesRange!)")
         }
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
         // both are selected:

           // NOTE: the is a REDUANDENT CODE:
           if firstDate != nil && lastDate != nil {
               for d in calendar.selectedDates {
                   calendar.deselect(d)
               }

               lastDate = nil
               firstDate = nil

               datesRange = []
               print("datesRange contains: \(datesRange!)")
           }
    }
    
    //disable previous dates
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            return false
        }
        else {
            return true
        }
    }
    
}
