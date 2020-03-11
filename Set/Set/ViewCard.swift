//
//  CardView.swift
//  Set
//
//  Created by Глеб Уваркин on 11/03/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

@IBDesignable class ViewCard: UIView {
    
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
    
    @IBInspectable var count : Int = 1 {
        didSet{setNeedsDisplay(); setNeedsLayout()}
    }
    
    @IBInspectable var fillInt : Int = 0{
        didSet{
            switch(fillInt){
            case 0: fill = fills.empty
            case 1: fill = fills.solid
            case 2: fill = fills.stripes
            default: break
            }
        }
    }
    
    @IBInspectable var symbolInt : Int = 1{
        didSet{
            switch(symbolInt){
            case 0: symbol = symbols.diamond
            case 1: symbol = symbols.oval
            case 2: symbol = symbols.squiggle
            default: break
            }
        }
    }
    
    @IBInspectable var colorInt = 1 {
        didSet{
            switch(colorInt){
            case 0: color = DefaultValues.colors.blue
            case 1: color = DefaultValues.colors.green
            case 2: color = DefaultValues.colors.red
            default: break
            }
        }
    }
    
    private var fill = fills.empty{
        didSet{setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var symbol = symbols.diamond{
        didSet{setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var color : UIColor = DefaultValues.colors.green{
        didSet{setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var pipHeight: CGFloat {
        bounds.height * 0.28
    }
    
    private var pipOffset: CGFloat {
        bounds.width * 0.15
    }
    
    private var pipWidth: CGFloat {
        bounds.width - 2 * pipOffset
    }
    
    private var pipInterOffset: CGFloat {
        bounds.height * 0.04
    }

    
    func deactivate(){
        borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//        setTitle(nil, for: .normal)
//        setAttributedTitle(nil, for: .normal)
//        isEnabled = false
    }
    
    func activate(){
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        isEnabled = true
    }
    
    private enum fills : Int{
        case empty
        case stripes
        case solid
    }
    
    private enum symbols : Int{
        case diamond
        case squiggle
        case oval
    }
    
    private func drawPips(){
        color.setFill()
        color.setStroke()
        switch(count){
        case 1:
            let origin = CGPoint(x: pipOffset, y: bounds.midY - pipHeight/2)
            let size = CGSize(width: pipWidth, height: pipHeight)
            let rect = CGRect(origin: origin, size: size)
            drawShape(in: rect)
        case 2:
            let origin = CGPoint(x: pipOffset, y: bounds.midY - pipHeight - pipInterOffset/2)
            let size = CGSize(width: pipWidth, height: pipHeight)
            let rect = CGRect(origin: origin, size: size)
            drawShape(in: rect)
            
            let origin2 = CGPoint(x: pipOffset, y: bounds.midY + pipInterOffset/2)
            let size2 = CGSize(width: pipWidth, height: pipHeight)
            let rect2 = CGRect(origin: origin2, size: size2)
            drawShape(in: rect2)
        case 3:
            let origin = CGPoint(x: pipOffset, y: bounds.midY - 3*pipHeight/2 - pipInterOffset)
            let size = CGSize(width: pipWidth, height: pipHeight)
            let rect = CGRect(origin: origin, size: size)
            drawShape(in: rect)
            
            let origin2 = CGPoint(x: pipOffset, y: bounds.midY - pipHeight/2)
            let size2 = CGSize(width: pipWidth, height: pipHeight)
            let rect2 = CGRect(origin: origin2, size: size2)
            drawShape(in: rect2)
            
            let origin3 = CGPoint(x: pipOffset, y: bounds.midY + pipHeight/2 + pipInterOffset)
            let size3 = CGSize(width: pipWidth, height: pipHeight)
            let rect3 = CGRect(origin: origin3, size: size3)
            drawShape(in: rect3)
        default: break
        }
        
    }
    
    private func drawShape(in rect:CGRect){
        let path : UIBezierPath
        switch(symbol){
        case .diamond: path = pathDiamond(in: rect)
        case .oval: path = pathOval(in: rect)
        case .squiggle: path = pathSquiggle(in: rect)
        }
        
        switch(fill){
        case .solid:
            path.fill()
        case .stripes:
            stripeShape(path: path, in: rect)
        default: break
        }
        
        path.lineWidth = 3.0
        path.stroke()
    }
    
    private func stripeShape(path: UIBezierPath, in rect: CGRect){
        if let context = UIGraphicsGetCurrentContext(){
            context.saveGState()
            path.addClip()
            stripeRect(rect)
            context.restoreGState()
        }
    }
    
    private func stripeRect(_ rect: CGRect) {
        let stripe = UIBezierPath()
        stripe.lineWidth = 1.0
        stripe.move(to: CGPoint(x: rect.minX, y: bounds.minY ))
        stripe.addLine(to: CGPoint(x: rect.minX, y: bounds.maxY))
        let stripeCount = Int(pipWidth / DefaultValues.interStripeSpace)
        for _ in 1...stripeCount {
        let translation = CGAffineTransform(translationX: DefaultValues.interStripeSpace, y: 0)
        stripe.apply(translation)
        stripe.stroke()
        }
    }
    
    private func pathDiamond(in rect: CGRect) -> UIBezierPath{
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.minX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamond.close()
        return diamond
    }
    
    private func pathOval(in rect: CGRect) -> UIBezierPath{
        let oval = UIBezierPath()
        let radius = rect.height / 2
        oval.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        oval.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        oval.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                    radius: radius, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi/2, clockwise: true)
        oval.close()
        return oval
    }
    
    private func pathSquiggle(in rect: CGRect) -> UIBezierPath{
        let upperSquiggle = UIBezierPath()
        let sqdx = rect.width * 0.1
        let sqdy = rect.height * 0.2
        upperSquiggle.move(to: CGPoint(x: rect.minX,
                                              y: rect.midY))
        upperSquiggle.addCurve(to:
                                  CGPoint(x: rect.minX + rect.width * 1/2,
                                          y: rect.minY + rect.height / 8),
                               controlPoint1: CGPoint(x: rect.minX,
                                          y: rect.minY),
                   controlPoint2: CGPoint(x: rect.minX + rect.width * 1/2 - sqdx,
                                          y: rect.minY + rect.height / 8 - sqdy))
        upperSquiggle.addCurve(to:
                                  CGPoint(x: rect.minX + rect.width * 4/5,
                                          y: rect.minY + rect.height / 8),
                   controlPoint1: CGPoint(x: rect.minX + rect.width * 1/2 + sqdx,
                                          y: rect.minY + rect.height / 8 + sqdy),
                   controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - sqdx,
                                          y: rect.minY + rect.height / 8 + sqdy))
        
        upperSquiggle.addCurve(to:
                                  CGPoint(x: rect.minX + rect.width,
                                          y: rect.minY + rect.height / 2),
                   controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + sqdx,
                                          y: rect.minY + rect.height / 8 - sqdy ),
                   controlPoint2: CGPoint(x: rect.minX + rect.width,
                                          y: rect.minY))
          
        let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity
                                        .translatedBy(x: bounds.width, y: bounds.height))
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.append(lowerSquiggle)
        return upperSquiggle
    }
    
    struct DefaultValues {
        struct colors{
            static let blue = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            static let red = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            static let green = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
        struct BorderColors {
            static let matching = #colorLiteral(red: 0, green: 0.9999727607, blue: 0.0243024677, alpha: 1)
            static let chosen = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            static let none = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            static let nonMatching = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        static let cornerRadius = CGFloat(15)
        static let borderWidth = CGFloat(3)
        static let interStripeSpace: CGFloat = 8.0
        
    }
    
    override func draw(_ rect: CGRect) {
        
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: DefaultValues.cornerRadius)
//        UIColor.white.setFill()
//        path.fill()
        drawPips()
    }
    
    
    
    
    
    
    
    
}
