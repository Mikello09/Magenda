//
//  CalendarPopUpView.swift
//  MedicalAgenda
//
//  Created by Mikel Lopez Salazar on 2/4/19.
//  Copyright © 2019 Mikel Lopez. All rights reserved.
//

import UIKit
import VACalendar

class CalendarPopUpView: UIView {
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL yyyy"
            dateFormatter.locale = Locale(identifier: "es")
            
            let appereance = VAMonthHeaderViewAppearance(
                monthFont: UIFont.systemFont(ofSize: 16),
                monthTextWidth: 200,
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                dateFormatter: dateFormatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
            monthHeaderView.layer.cornerRadius = 4
            monthHeaderView.layer.masksToBounds = true
            //monthHeaderView.roundCorners([.topLeft, .topRight], radius: 4)
            let path = UIBezierPath(rect: monthHeaderView.bounds)
            let border = CAShapeLayer()
            border.path = path.cgPath
            border.lineWidth = 0.5
            border.fillColor = UIColor.clear.cgColor
            border.strokeColor = UIColor.lightGray.cgColor
            //monthHeaderView.layer.addSublayer(border)
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func closeAction(_ sender: UIButton) {
        didSelectDay?(getDefaultDate(delete: false))
    }
    @IBAction func todayClicked(_ sender: UIButton) {
        didSelectDay?(Date())
    }
    @IBAction func deleteClicked(_ sender: UIButton) {
        didSelectDay?(getDefaultDate(delete: true))
    }
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(
                symbolsType: .short,
                weekDayTextFont: UIFont.systemFont(ofSize: 13),
                leftInset: 0,
                rightInset: 0,
                calendar: defaultCalendar
            )
            weekDaysView.appearance = appereance
            weekDaysView.layer.borderWidth = 0.5
            weekDaysView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "es")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    var didSelectDay: ((Date) -> Void)?
    
    private var calendarView: VACalendarView!
    private var view: UIView!
    
    // MARK: Life cycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    // MARK: - Private methods.
    
    private func commonSetup() {
        setupXib()
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: CGRect(
            x: 0, y: weekDaysView.frame.maxY,
            width: view.frame.width,
            height: view.frame.height - weekDaysView.frame.maxY
        ), calendar: calendar)
        calendarView.backgroundColor = .clear
        view.backgroundColor = .clear
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.setup()
        view.addSubview(calendarView)
    }
    
    private func setupXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        view = (nib.instantiate(withOwner: self, options: nil)[0] as! UIView)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func getDefaultDate(delete: Bool) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "es")
        if(delete){return dateFormatter.date(from:"1990-09-09")!}else{return dateFormatter.date(from:"1890-09-09")!}
    }
    
}

extension CalendarPopUpView: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension CalendarPopUpView: VADayViewAppearanceDelegate {
    
    func font(for state: VADayState) -> UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return UIColor(red: 55 / 255, green: 167 / 255, blue: 248 / 255, alpha: 1.0)
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func backgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 249 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1.0)
        default:
            return .white
        }
    }
    
    func shape() -> VADayShape {
        return .square
    }
    
    func borderWidth(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return 1 / UIScreen.main.scale
        }
    }
    
    func borderColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return UIColor(red: 55 / 255, green: 167 / 255, blue: 248 / 255, alpha: 1.0)
        default:
            return UIColor(red: 221 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1.0)
        }
    }
    
}

extension CalendarPopUpView: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        didSelectDay?(date)
    }
    
}
