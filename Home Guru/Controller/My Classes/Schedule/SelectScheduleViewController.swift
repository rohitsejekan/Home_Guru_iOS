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
    var typeOfWeek: String?
    @IBOutlet weak var fsCalendar: FSCalendar!
    private weak var calendar: FSCalendar!
    var slotDetails: [String: Any] = [:]
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    var guruProfileDetails = [GetGuruProfile]()
    //also an array of dates to hold value dates between firstDate and lastDate
    private var datesRange: [Date]?
    var classesDates: [String: String] = [:]
    var datesString: [String] = []
    var datesStringBody: [String] = []
    var dateBodyCarry: [[String: String]] = [[:]]
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var arrDates = NSMutableArray()
    var arrDates_1 = NSMutableArray()
    var arrDates_2 = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        fsCalendar.allowsMultipleSelection = true
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.placeholderType = .none
        arrDates = self.getUserSelectedDates([2, 3, 4, 5, 6], calender: self.fsCalendar)
        if let typeWeek = UserDefaults.standard.string(forKey: "typeOfweeks"){
            typeOfWeek = typeWeek
        }
    }
    // function to get dates based on days [1,2,3,4,5,6,7] ex. 1 means monday and so on
      func getUserSelectedDates(_ arrWeekDay: [Int], calender calenderVW: FSCalendar?) -> NSMutableArray {
          let arrUnAvailibilityDates = NSMutableArray()
          let currentDate: Date? = calenderVW?.currentPage
          //get calender
          let gregorianCalendar = Calendar.init(identifier: .gregorian)
          // Start out by getting just the year, month and day components of the current date.
          var components: DateComponents? = nil
          if let aDate = currentDate {
              components = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aDate)
          }
          // Change the Day component to 1 (for the first day of the month), and zero out the time components.
          components?.day = 1
          components?.hour = 0
          components?.minute = 0
          components?.second = 0
          //get first day of current month
          var firstDateOfCurMonth: Date? = nil
          if let aComponents = components {
              firstDateOfCurMonth = gregorianCalendar.date(from: aComponents)
          }
          //create new component to get weekday of first date
          var newcomponents: DateComponents? = nil
          if let aMonth = firstDateOfCurMonth {
              newcomponents = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aMonth)
          }
          let firstDateWeekDay: Int? = newcomponents?.weekday
          //get last month date
          let curMonth: Int? = newcomponents?.month
          newcomponents?.month = (curMonth ?? 0) + 1
          var templastDateOfCurMonth: Date? = nil
          if let aNewcomponents = newcomponents {
              templastDateOfCurMonth = gregorianCalendar.date(from: aNewcomponents)?.addingTimeInterval(-1)
          }
          // One second before the start of next month
          var lastcomponents: DateComponents? = nil
          if let aMonth = templastDateOfCurMonth {
              lastcomponents = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aMonth)
          }
          lastcomponents?.hour = 0
          lastcomponents?.minute = 0
          lastcomponents?.second = 0
          var lastDateOfCurMonth: Date? = nil
          if let aLastcomponents = lastcomponents {
              lastDateOfCurMonth = gregorianCalendar.date(from: aLastcomponents)
          }
          var dayDifference = DateComponents()
          dayDifference.calendar = gregorianCalendar
          
          if arrWeekDay.count == 0 {
              
          } else if arrWeekDay.count == 1 {
              let wantedWeekDay = Int(arrWeekDay[0])
              var firstWeekDateOfCurMonth: Date? = nil
              if wantedWeekDay == firstDateWeekDay {
                  firstWeekDateOfCurMonth = firstDateOfCurMonth
              } else {
                  var day: Int = wantedWeekDay - firstDateWeekDay!
                  if day < 0 {
                      day += 7
                  }
                  day += 1
                  components?.day = day
                  firstWeekDateOfCurMonth = gregorianCalendar.date(from: components!)
              }
              var weekOffset: Int = 0
              var nextDate: Date? = firstWeekDateOfCurMonth
              repeat {
                  let strDT: String = getSmallFormatedDate(convertCalendarDate(toNormalDate: nextDate))!
                  arrUnAvailibilityDates.add(strDT)
                  weekOffset += 1
                  dayDifference.weekOfYear = weekOffset
                  var date: Date? = nil
                  if let aMonth = firstWeekDateOfCurMonth {
                      date = gregorianCalendar.date(byAdding: dayDifference, to: aMonth)
                  }
                  nextDate = date
              } while nextDate?.compare(lastDateOfCurMonth!) == .orderedAscending || nextDate?.compare(lastDateOfCurMonth!) == .orderedSame
          }
          else {
              for i in 0..<arrWeekDay.count {
                  let wantedWeekDay = Int(arrWeekDay[i])
                  var firstWeekDateOfCurMonth: Date? = nil
                  if wantedWeekDay == firstDateWeekDay {
                      firstWeekDateOfCurMonth = firstDateOfCurMonth
                  } else {
                      var day: Int = wantedWeekDay - firstDateWeekDay!
                      if day < 0 {
                          day += 7
                      }
                      day += 1
                      components?.day = day
                      firstWeekDateOfCurMonth = gregorianCalendar.date(from: components!)
                  }
                  
                  
                  var weekOffset: Int = 0
                  var nextDate: Date? = firstWeekDateOfCurMonth
                  repeat {
                      let strDT = getSmallFormatedDate(convertCalendarDate(toNormalDate: nextDate))
                      arrUnAvailibilityDates.add(strDT!)
                      weekOffset += 1
                      dayDifference.weekOfYear = weekOffset
                      var date: Date? = nil
                      if let aMonth = firstWeekDateOfCurMonth {
                          date = gregorianCalendar.date(byAdding: dayDifference, to: aMonth)
                      }
                      nextDate = date
                  } while nextDate?.compare(lastDateOfCurMonth!) == .orderedAscending || nextDate?.compare(lastDateOfCurMonth!) == .orderedSame
              }
          }
          return arrUnAvailibilityDates
      }

          func convertCalendarDate(toNormalDate selectedDate: Date?) -> Date? {
              let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
              let destinationTimeZone = NSTimeZone.system as NSTimeZone
              var sourceGMTOffset: Int? = nil
              if let aDate = selectedDate {
                  sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
              }
              var destinationGMTOffset: Int? = nil
              if let aDate = selectedDate {
                  destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
              }
              let interval1 = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
              var localDate: Date? = nil
              if let aDate = selectedDate {
                  localDate = Date(timeInterval: interval1, since: aDate)
              }
              return localDate
      }
      func getSmallFormatedDate(_ localDate: Date?) -> String? {
          let dateFormatter = DateFormatter()
          let timeZone = NSTimeZone(name: "UTC")
          if let aZone = timeZone {
              dateFormatter.timeZone = aZone as TimeZone
          }
          dateFormatter.dateFormat = "yyyy-MM-dd"
          var dateString: String? = nil
          if let aDate = localDate {
              dateString = dateFormatter.string(from: aDate)
          }
          return dateString
      }
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func goNext(_ sender: Any) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ConfirmSchedule") as! ConfirmScheduleViewController
        //setNavigationBackTitle(title: "Schedule")
        vc.hidesBottomBarWhenPushed = true
        vc.slotDetails = slotDetails
        
        for typeDates in datesStringBody{
            let dict = ["dates": "\(typeDates)", "classType": "1"]
            dateBodyCarry.append(dict)
        }
        StructOperation.glovalVariable.subjectDatesSlot = dateBodyCarry
        vc.subjectDatesSlot = dateBodyCarry
        print("dateBodyCarry........\(dateBodyCarry)")
        vc.guruProfileDetails = guruProfileDetails
        vc.selectedDate = datesString
         presentDetail(vc)
        
       

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

extension SelectScheduleViewController: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance{
       func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
          fsCalendar.reloadData()

       }
    
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
                print("single date...\(dateFormatter2.string(from: d))")
                 calendar.select(d)
                let last4 = String(dateFormatter2.string(from: d).suffix(2))
                datesString.append(last4)
                datesStringBody.append(String(dateFormatter2.string(from: d)))
                
             }

             datesRange = range

             print("datesRange contains: \(datesRange!)")
            print("dates in string..\(datesString)")
            print("dates in stringbody..\(datesStringBody)")
             arrDates.contains(dateFormatter2.string(from: date))

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
        if typeOfWeek == "weekdays"{
                    while tempDate < to {
                        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
                         arrDates_2 = self.getUserSelectedDates([1,7], calender: self.fsCalendar)
                        if arrDates_2.contains(dateFormatter2.string(from: tempDate)) {
                                          print("not added due to its saturday or sunday")
                                      }
                        else{
                            // check each selected date falls in weekend of next month
                                           if tempDate.dayNumberOfWeek()! == 7 || tempDate.dayNumberOfWeek()! == 1 {
                                               print("skiped due to weekends")
                                           }else{
                                               array.append(tempDate)
                                           }
                        }
            //            array.append(tempDate)
                    }
        }
        else if typeOfWeek == "weekends"{
             while tempDate < to {
                        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
                arrDates_2 = self.getUserSelectedDates([2,3,4,5,6], calender: self.fsCalendar)
                        if arrDates_2.contains(dateFormatter2.string(from: tempDate)) {
                                          print("not added due to its saturday or sunday")
                                      }
                        else{
                            // check each selected date falls in weekend of next month
                                           if tempDate.dayNumberOfWeek()! == 2 || tempDate.dayNumberOfWeek()! == 3 ||
                                            tempDate.dayNumberOfWeek()! == 4 || tempDate.dayNumberOfWeek()! == 5 ||
                                            tempDate.dayNumberOfWeek()! == 6
                                            {
                                               print("skiped due to weekdays")
                                           }else{
                                               array.append(tempDate)
                                           }
                        }
            //            array.append(tempDate)
                    }
        }
        else{
            while tempDate < to {
                    tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
                    //arrDates_2 = self.getUserSelectedDates([7], calender: self.fs_calendar)
                   
                        array.append(tempDate)
                   
                    
                }
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
    
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
           print("new days........\(arrDates)")
            arrDates = self.getUserSelectedDates([2, 3, 4, 5, 6], calender: self.fsCalendar)
           arrDates_1 = self.getUserSelectedDates([1], calender: self.fsCalendar)
           arrDates_2 = self.getUserSelectedDates([7], calender: self.fsCalendar)
           
           if arrDates.contains(dateFormatter2.string(from: date)) {
               return UIColor.white
           }
           if arrDates_1.contains(dateFormatter2.string(from: date)){
               return UIColor.red
           }
           if arrDates_2.contains(dateFormatter2.string(from: date)){
               return UIColor.red
           }else{
               return nil
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

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
extension Date {
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
