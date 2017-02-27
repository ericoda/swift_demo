//
//  ViewController.swift
//  ticker
//
//  Created by Eric on 2017/2/15.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

	@IBOutlet var eventSwitch: EventSwitch!
	@IBOutlet weak var autoContinueSwitch: UISwitch!
	@IBOutlet weak var timeUnit: UISegmentedControl!
	@IBOutlet weak var timeInterval: UISegmentedControl!
	@IBOutlet weak var timeOfEach: UILabel!
	@IBOutlet weak var decreaseButton: UIButton!
	@IBOutlet weak var increaseButton: UIButton!
	private var steppercontext = 0;

	var timeContainer:Dictionary = ["hour":0,"minute":0,"second":0];
	var currentUnit:String = "hour";
	var currentInterval:Int = 1;



	var sum:Int = 0;
	var tickingTime:Int{
		set {
			sum = newValue;
		}
		get {
			if sum == 0 {
				sum = timeContainer["hour"]! * 3600 +
					timeContainer["minute"]! * 60 +
					timeContainer["second"]!;
			}
			return sum;
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	var customTimer:Timer = Timer();


	@IBAction func startTicking(_ sender: EventSwitch) {
		guard sum > 0 else {
			return
		}
		if customTimer.isValid {
			customTimer.invalidate()
			sum = 0
			return
		}else {
			customTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countDownTime), userInfo: nil, repeats: true)
		}
	}
	func countDownTime() {
		guard tickingTime > 0 else {
			return
		}
		eventSwitch.setTitle(formatSecondsIntoHours(), for: UIControlState.normal)
		tickingTime = tickingTime - 1

	}

	func formatSecondsIntoHours() -> String {
		func getSecond() -> String {
			return "\(self.tickingTime%3600%60)";
		}
		func getMinute() -> String {
			return "\((self.tickingTime/60)%60)";
		}
		func getHour() -> String {
			return "\(self.tickingTime/3600)";
		}
		return "\(getHour()):\(getMinute()):\(getSecond())";
	}


	@IBAction func decreaseEvent(_ sender: UIButton) {
		if timeContainer[currentUnit]! == 0 {
			return;
		};

		if (timeContainer[currentUnit]! - currentInterval) < 0 {
			timeContainer[currentUnit] = 0;
		}else {
			timeContainer[currentUnit] = timeContainer[currentUnit]! - currentInterval;
		}
		setTimeLabel();
	}

	@IBAction func increaseEvent(_ sender: UIButton) {
		if currentUnit == "hour" {
			if(timeContainer[currentUnit]! + currentInterval) > 24 {
				timeContainer[currentUnit] = 24;
			}
		}else{
			if(timeContainer[currentUnit]! + currentInterval) > 60 {
				timeContainer[currentUnit] = 0;
			}
		}
		timeContainer[currentUnit] = timeContainer[currentUnit]! + currentInterval;
		setTimeLabel();
	}

	func setTimeLabel(){

		func formattedTime(){
			let hour = timeContainer["hour"]!;
			let minute = timeContainer["minute"]!;
			let second = timeContainer["second"]!;
			timeOfEach.text = "\(hour):\(minute):\(second)";
		}
		formattedTime();
	}

	@IBAction func timeUnitEvent(_ sender: UISegmentedControl) {
		switch timeUnit.selectedSegmentIndex {
		case 0:
			currentUnit = "hour";
		case 1:
			currentUnit = "minute";
		case 2:
			currentUnit = "second";
		default:
			currentUnit = "hour";
		}
	}

	@IBAction func timeStepperEvent(_ sender: UISegmentedControl) {
		switch  timeInterval.selectedSegmentIndex {
		case 0:
			currentInterval = 1;
		case 1:
			currentInterval = 5;
		case 2:
			currentInterval = 10;
		default:
			currentInterval = 1;
		}
	}

}


@IBDesignable
class EventSwitch: UIButton {
	@IBInspectable var radius:CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = radius;
			layer.masksToBounds = true;
		}
	}

	@IBInspectable var borderColor:UIColor = UIColor() {
		didSet {
			layer.borderColor = borderColor.cgColor;
		}
	}
}

