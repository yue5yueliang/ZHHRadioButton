//
//  DemoViewController.swift
//  ZHHRadioButton_Example
//
//  Created by 桃色三岁 on 2025/4/21.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

import UIKit
import ZHHRadioButton

class DemoViewController: UIViewController {

    var waterButton : ZHHRadioButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // enable multiple selection for water, beer and wine buttons.
        self.waterButton.isMultipleSelectionEnabled = true;
        // set selection states programmatically
        for radioButton in self.waterButton.otherButtons {
            radioButton.isSelected = true;
        }
        
        // programmatically add buttons
        // first button
        let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 350, width: 262, height: 17);
        let firstRadioButton = createRadioButton(frame: frame, title: "Red Button", color: UIColor.red);
        
        //other buttons
        let colorNames = ["Brown", "Orange", "Green", "Blue", "Purple"];
        let colors = [UIColor.brown, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple];
        var i = 0;
        var otherButtons : [ZHHRadioButton] = [];
        for color in colors {
            let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 380 + 30 * CGFloat(i), width: 262, height: 17);
            let radioButton = createRadioButton(frame: frame, title: colorNames[i] + " Button", color: color);
            if (i % 2 == 0) {
                radioButton.isIconSquare = true;
            }
            if (i > 1) {
                // put icon on the right side
                radioButton.isIconOnRight = true;
                radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
            }
            otherButtons.append(radioButton);
            i += 1;
        }
        
        firstRadioButton.otherButtons = otherButtons;
        // set selection state programmatically
        firstRadioButton.otherButtons[1].isSelected = true;
    }
    
    // MARK: Helper
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> ZHHRadioButton {
        let radioButton = ZHHRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: []);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(DemoViewController.logSelectedButton), for: UIControl.Event.touchUpInside);
        self.view.addSubview(radioButton);
        
        return radioButton;
    }
    
    @objc private func logSelectedButton(radioButton : ZHHRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
        }
    }

}
