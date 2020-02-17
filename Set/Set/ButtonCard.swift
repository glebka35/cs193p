//
//  ButtonCard.swift
//  Set
//
//  Created by Глеб Уваркин on 13/02/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

@IBDesignable class ButtonCard: UIButton {
    
    var colors = [#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    var symbols = ["▲","●","■"]
    var alphas = [1.0, 0.4, 0.15]
    var strokeWidth = [-8.0, 8.0, -8.0]
    
    @IBInspectable var cornerRadius : CGFloat = DefaultValues.cornerRadius {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = DefaultValues.borderWidth {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = DefaultValues.BorderColors.none{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    func deactivate(){
        borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        setTitle(nil, for: .normal)
        setAttributedTitle(nil, for: .normal)
        isEnabled = false
    }
    
    func activate(){
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        isEnabled = true
    }
    
    struct DefaultValues {
        static let cornerRadius = CGFloat(15)
        static let borderWidth = CGFloat(3)
        
        struct BorderColors {
            static let matching = #colorLiteral(red: 0, green: 0.9999727607, blue: 0.0243024677, alpha: 1)
            static let chosen = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            static let none = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            static let nonMatching = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    


}
