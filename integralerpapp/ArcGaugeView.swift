//
//  ArcGaugeView.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 18/09/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit
import Foundation
import Darwin

let π:CGFloat = CGFloat(M_PI)

@IBDesignable
class ArcGaugeView: UIView {
    
    // MARK: Class'es private properties
    
    private var arcOriginPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var arcRadius: CGFloat = 0
    private var arcWidth: CGFloat = 0

    
    // MARK: Class Story Board properties
    
    @IBInspectable var currentValue: Float = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var minimumValue: Float = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var maximumValue: Float = 100 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: Constractor
    
    required init?(coder aDecoder: NSCoder) {
        arcOriginPoint = CGPoint(x: 0, y: 0)
        super.init(coder: aDecoder)
    }
    
    // MARK: Use this method for change values
    
    func setValue(currentValue: Float, minimumValue: Float, maximumValue: Float) {
        self.currentValue = currentValue
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        redraw(currentValue: self.currentValue, minimumValue: self.minimumValue , maximumValue: self.maximumValue)
        setNeedsDisplay()
    }
    
    // MARK: Drawing methods
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        redraw(currentValue: self.currentValue, minimumValue: self.minimumValue , maximumValue: self.maximumValue)
    }
    
    func redraw(currentValue: Float, minimumValue: Float, maximumValue: Float) {
        arcOriginPoint = calculateCenterPoint(width: bounds.width, height: bounds.height)
        arcRadius = calculateArcRadius(width: bounds.width, height: bounds.height)
        arcWidth = arcRadius / 4  // Used as constant factor.
        drawBackgrond()
        drawYellowArc()
        drawGreenArc()
        drawRedArc()
        drawHand(value: self.currentValue, minValue: self.minimumValue, maxValue: self.maximumValue)
        drawHandsOrigin()
        drawValueAsText(text: String(currentValue))
    }
    
    func drawBackgrond() {
        print("ArcGaugeView -> drawBackground")
        self.backgroundColor = UIColor.white
    }
    
    // Used as a backgroung color of the arc
    func drawYellowArc() {
        print("ArcGaugeView -> drawYellowArc")
        let startAngle: CGFloat = π
        let endAngle: CGFloat = 2 * π
        let path = UIBezierPath()
        path.addArc(withCenter: arcOriginPoint,
                                radius: arcRadius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = arcWidth
        UIColor.yellow.setStroke()
        path.stroke()
    }
    
    // Used for drawing the left sector (60 degrees)
    func drawGreenArc() {
        print("ArcGaugeView -> drawGreenArc")
        let startAngle: CGFloat = π
        let endAngle = 4 * π / 3
        
        let path = UIBezierPath()
        path.addArc(withCenter: arcOriginPoint,
                                radius: arcRadius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = arcWidth
        UIColor.green.setStroke()
        path.stroke()

    }
    
    // Used for drawing the right scetor (60 degrees)
    func drawRedArc() {
        print("ArcGaugeView -> drawRedArc")
        let startAngle: CGFloat = 5 * π / 3
        let endAngle = 2 * π
        
        let path = UIBezierPath()
        path.addArc(withCenter: arcOriginPoint,
                                radius: arcRadius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = arcWidth
        UIColor.red.setStroke()
        path.stroke()
    }
    
    func drawHand(value: Float, minValue: Float, maxValue: Float) {
        print("ArcGaugeView -> drawHand")
        let floatingPoint = calcultedHandCGPoint(value: value, minValue: minValue, maxValue: maxValue)
        
        //create the path
        let handPath = UIBezierPath()
        
        // Move to the first point
        handPath.move(to: arcOriginPoint)
        // Draw the line
        handPath.addLine(to: floatingPoint)
        // Set line width
        handPath.lineWidth = 1.5; // Used as constant factor.
        
        // Draw the line on screen
        UIColor.black.setStroke()
        handPath.stroke()
    }
    
    func drawHandsOrigin() {
        print("ArcGaugeView -> drawHandsOrigin")
        let startAngle: CGFloat = π
        let endAngle: CGFloat = 2 * π
        let path = UIBezierPath()
        path.addArc(withCenter: arcOriginPoint,
                    radius: 3,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        path.lineWidth = 6
        UIColor.orange.setStroke()
        path.stroke()
    }
    
    func drawValueAsText(text: String) {
        print("ArcGaugeView -> drawValueAsText")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 12)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        let string = text
        string.draw(with: CGRect(x: ((bounds.width / 2) - 40), y: (bounds.height - (arcRadius / 2) + 10), width: 80, height: 20), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
    // MARK: Logic  part
    
    // Calucle the hand's "floating" point that reflect the value.
    func calcultedHandCGPoint(value: Float, minValue: Float, maxValue: Float) -> CGPoint {
        print("ArcGaugeView -> getCalcultedHandCGPoint")
        let fullRange = maxValue - minValue
        let realValue = value - minValue
        let angle = 90 - CGFloat((realValue / fullRange) * 180)
        let xPos = calculateXposition(length: arcRadius / 2.2, angleDeg: angle)
        let yPos = calculateYposition(length: arcRadius / 2.2, angleDeg: angle)
        var floatingPoint = CGPoint()
        floatingPoint.x = arcOriginPoint.x - CGFloat(xPos)
        floatingPoint.y = arcOriginPoint.y - CGFloat(yPos)
        return floatingPoint
    }
    
    // Calculate the point that will be used as the origin point of the arc
    func calculateCenterPoint(width: CGFloat, height: CGFloat) -> CGPoint {
        print("ArcGaugeView -> CalculateCenterPoint")
        let centerPoint = CGPoint(x: width / 2, y: height)
        return centerPoint
    }
    
    // Calculate the radius of the arc according to view's dimentions
    func calculateArcRadius(width: CGFloat, height: CGFloat) -> CGFloat {
        print("ArcGaugeView -> calculateArcRadius")
        // In order to calculte the radius we make some assumptions:
        // 1- The view is rectuangle and not a squre
        // 2- The arc origin hieght is the rectangles height
        // 3- Raduis must be smaller or equal to half of the width
        if width >= height * 2 {
            return height
        } else {
            return width / 2
        }
    }
    
    // Calculate the X posion of the hand's "floating" point
    func calculateXposition(length: CGFloat, angleDeg: CGFloat) -> Double {
        print("ArcGaugeView -> calculateXposition")
        let angValu = sin(degToRad(degrees: Double(angleDeg)))
        return angValu * Double(length)
    }
    
    // Calculate the Y posion of the hand's "floating" point
    func calculateYposition(length: CGFloat, angleDeg: CGFloat) -> Double {
        print("ArcGaugeView -> calculateYposition")
        let angValu = cos(degToRad(degrees: Double(angleDeg)))
        return angValu * Double(length)
    }
    
    func degToRad(degrees: Double) -> Double {
        print("ArcGaugeView -> degToRad")
        // M_PI is defined in Darwin.C.math
        return M_PI * 2.0 * degrees / 360.0
    }
}
