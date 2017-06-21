//
//  MusicButton.swift
//  pokedex
//
//  Created by Brian McAulay on 10/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import AVFoundation


class MusicButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.opacity = 1.0
        
        switch layer.frame.size.width {
        case let x where x > 100:
            layer.cornerRadius = 7.0
            self.backgroundColor = UIColor.darkGray
            self.setTitleColor(.white, for: .normal)
        case 80...90:
            layer.cornerRadius = 5.0
            self.backgroundColor = UIColor.green
            self.setTitleColor(.black, for: .normal)
        default:
            layer.cornerRadius = 3.0
            self.backgroundColor = UIColor.white
            self.setTitleColor(.red, for: .normal)
        }
    }
    
    
}
