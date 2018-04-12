//
//  MultiValuesCircleView.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 10/10/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit
import Darwin

class MultiValuesCircleView: UIView {

    // MARK: Class'es private properties
    
    private var circleOriginPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var circleRadius: CGFloat = 0
    private var circleWidth: CGFloat = 0
    
    private var sumValue: Float = 0
    
    private var values: [Float] = []
    private var colors: [UIColor] = []
    
    private var ctx: CGContext?
    
    // MARK: Class Story Board properties
    
    @IBInspectable var circleBgColor: UIColor = UIColor.gray
    
    // MARK: Errors
    
    enum DataVlidationErrors: Error {
        case InavlidDataLengthError(text: String)
        case InvalidColorLengthError(text: String)
        case DataMismatchError(text: String)
        case NullPointerException(text: String)
        case GeneralError
    }
    
    // MARK: Constractor
    
    required init?(coder aDecoder: NSCoder) {
        circleOriginPoint = CGPoint(x: 0, y: 0)
        ctx = UIGraphicsGetCurrentContext()
        super.init(coder: aDecoder)
    }
    
    // MARK: Drawing methods
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("MultiValuesCircleView -> draw")
        redraw()
    }
    
    // This method responsible to draw the view. The most important rule of this method is 
    // re - calculation of the view's components
    private func redraw() {
        print("MultiValuesCircleView -> redraw")
        circleOriginPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        circleRadius = calculateArcRadius(width: bounds.width, height: bounds.height)
        circleWidth = circleRadius / 4  // Used as constant factor.
        drawBackgrond()
        drawDataArcs(ctx: ctx!)
    }
    
    func drawDataArcs(ctx: CGContext) {
        print("MultiValuesCircleView -> drawDataArcs")
        var startDegree: Int = 0
        for i in 0 ..< values.count {
            let degree: Int  = valueToDegrees(value: values[i], total: sumValue)
            drawArcAndValue(ctx: ctx, circleRadius: circleRadius, circleOriginPoint: circleOriginPoint, circleWidth: circleWidth, startDegree: startDegree, degree: degree, value: values[i], color: colors[i])
            startDegree += degree;
        }
    }
    
    func drawArcAndValue(ctx: CGContext, circleRadius: CGFloat, circleOriginPoint: CGPoint, circleWidth: CGFloat, startDegree: Int, degree: Int, value: Float, color: UIColor) {
        print("MultiValuesCircleView -> drawArcAndValue")
        drawArc(circleRadius: circleRadius, circleOriginPoint: circleOriginPoint, startDegree: startDegree, degree: degree, color: color)
        drawValue(ctx: ctx, circleRadius: circleRadius, circleOriginPoint: circleOriginPoint, startDegree: startDegree, degree: degree, value: value, color: color)
    }
    
    private func drawValue(ctx: CGContext, circleRadius: CGFloat, circleOriginPoint: CGPoint, startDegree: Int, degree: Int, value: Float, color: UIColor) {
        print("MultiValuesCircleView -> drawValue")
        let textColor: UIColor = reverseColor(color: color)
        let angelDeg: Int = 90 + startDegree + (degree / 2)
        let pivotPoing: CGPoint = calcultedFloatingCGPoint(angelDeg: angelDeg, circleOriginPoint: circleOriginPoint, circleRadius: circleRadius)
        drawRotatedText(ctx: ctx, x: Int(pivotPoing.x), y: Int(pivotPoing.y), rotationAngleDeg: angelDeg, text: String(value), attributes: [NSForegroundColorAttributeName : textColor.cgColor, NSFontAttributeName : UIFont.systemFont(ofSize: 12),])
    }
    
    private func drawRotatedText(ctx: CGContext, x: Int, y: Int, rotationAngleDeg: Int, text: String, attributes: [String: AnyObject]) {
        print("MultiValuesCircleView -> drawRotatedText")
        ctx.translateBy(x: 0, y: 0)
        ctx.scaleBy(x: 1, y: -1)
        let font = attributes[NSFontAttributeName] as! UIFont
        let attributedString = NSAttributedString(string: text as String, attributes: attributes)
        let textSize = text.size(attributes: attributes)
        let textPath = CGPath(rect: CGRect(x: CGFloat(-x), y: CGFloat(y) + font.descender, width: ceil(textSize.width), height: ceil(textSize.height)), transform: nil)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), textPath, nil)
        ctx.textMatrix = CGAffineTransform(rotationAngle: CGFloat(degToRad(degrees: Double(rotationAngleDeg))))
        CTFrameDraw(frame, ctx)
        // Maybe need to rotate back to the previous position
        ctx.textMatrix = CGAffineTransform(rotationAngle: CGFloat(degToRad(degrees: Double(rotationAngleDeg))))
    }
    
    func drawArc(circleRadius: CGFloat, circleOriginPoint: CGPoint, startDegree: Int, degree: Int, color: UIColor) {
        print("MultiValuesCircleView -> drawArc")
        let startAngle: CGFloat = CGFloat(degToRad(degrees: Double(startDegree)))
        let endAngle: CGFloat = CGFloat(degToRad(degrees: Double(startDegree + degree)))
        let path = UIBezierPath()
        path.addArc(withCenter: circleOriginPoint,
                    radius: circleRadius/2 - circleWidth/2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        path.lineWidth = circleWidth
        color.setStroke()
        path.stroke()
    }
    
    func drawBackgrond() {
        print("MultiValuesCircleView -> drawBackground")
        drawArc(circleRadius: circleRadius, circleOriginPoint: circleOriginPoint, startDegree: 0, degree: 362, color: circleBgColor)
    }
    
    // MARK: Use this method for change values
    
    func setData(values: [Float], colors: [UIColor]) throws {
        print("MultiValuesCircleView -> setData")
        let isValid = try? isDalidData(values: values, colors: colors)
        if false == isValid {
            return
        }
        self.values = values
        self.colors = colors
        sumValue = getSumValue(valuesArr: self.values)
        redraw()
        setNeedsDisplay()
    }
    
    // MARK: Logic  part
    
    func calcultedFloatingCGPoint(angelDeg: Int, circleOriginPoint: CGPoint, circleRadius: CGFloat) -> CGPoint {
        print("MultiValuesCircleView -> calcultedFloatingCGPoint")
        let xPos = calculateXposition(length: circleRadius / 2.2, angleDeg: CGFloat(angelDeg))
        let yPos = calculateYposition(length: circleRadius / 2.2, angleDeg: CGFloat(angelDeg))
        var floatingPoint = CGPoint()
        floatingPoint.x = circleOriginPoint.x - CGFloat(xPos)
        floatingPoint.y = circleOriginPoint.y - CGFloat(yPos)
        return floatingPoint
    }
    
    // Calculate the X posion of the hand's "floating" point
    func calculateXposition(length: CGFloat, angleDeg: CGFloat) -> Double {
        print("MultiValuesCircleView -> calculateXposition")
        let angValu = sin(degToRad(degrees: Double(angleDeg)))
        return angValu * Double(length)
    }
    
    // Calculate the Y posion of the hand's "floating" point
    func calculateYposition(length: CGFloat, angleDeg: CGFloat) -> Double {
        print("MultiValuesCircleView -> calculateYposition")
        let angValu = cos(degToRad(degrees: Double(angleDeg)))
        return angValu * Double(length)
    }
    
    func valueToDegrees(value: Float, total: Float) -> Int {
        print("MultiValuesCircleView -> valueToDegrees")
        return Int(value * Float(360) / sumValue)
    }
    
    func isDalidData(values: [Float]!, colors: [UIColor]!) throws -> Bool {
        print("MultiValuesCircleView -> isDalidData")
        if (values?.isEmpty)! {
            throw DataVlidationErrors.NullPointerException(text: "Incoming values is nil")
        }
        if (colors?.isEmpty)! {
            throw DataVlidationErrors.NullPointerException(text: "Incoming colors is nil")
        }
        if colors?.count != values?.count {
            throw DataVlidationErrors.DataMismatchError(text: "colors are not matching the values")
        }
        return true
    }
    
    func getSumValue(valuesArr: [Float]) -> Float {
        print("MultiValuesCircleView -> getSumValue")
        var sum: Float = 0;
        for i in 0 ..< valuesArr.count {
            sum = sum + valuesArr[i]
        }
        return sum
    }
    
    // Calculate the radius of the arc according to view's dimentions
    func calculateArcRadius(width: CGFloat, height: CGFloat) -> CGFloat {
        print("MultiValuesCircleView -> calculateArcRadius")
        // In order to calculte the radius we make some assumptions:
        // 1- The view is rectuangle and not a squre
        // 3- Raduis must be smaller or equal to half of the width or of height
        if width >= height {
            return height
        } else {
            return width
        }
    }
    
    // ref: http://stackoverflow.com/questions/31639907/with-swift-is-it-possible-to-access-the-invert-colors-function-that-s-in-access
    func reverseColor(color: UIColor) -> UIColor {
        print("MultiValuesCircleView -> reverseColor")
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: a) // Assuming you want the same alpha value.
    }
    
    func degToRad(degrees: Double) -> Double {
        print("MultiValuesCircleView -> degToRad")
        // M_PI is defined in Darwin.C.math
        return M_PI * 2.0 * degrees / 360.0
    }
}
