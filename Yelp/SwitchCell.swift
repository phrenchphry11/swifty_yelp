//
//  SwitchCell.swift
//  Yelp
//
//  Created by Holly French on 4/25/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


protocol SwitchCellDelegate : class {
    func didUpdateValue(switchCell: SwitchCell, value: Bool)
}


class SwitchCell: UITableViewCell {

    @IBOutlet weak var toggleSwitch: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        delegate!.didUpdateValue(self, value: toggleSwitch.on)
    }
    
    func setSwitchValueAnimated(value: Bool, animated: Bool) {
        toggleSwitch.setOn(value, animated: animated)
    }
    
    func setSwitchValue(value: Bool) {
        setSwitchValueAnimated(value, animated: false)
    }
}
