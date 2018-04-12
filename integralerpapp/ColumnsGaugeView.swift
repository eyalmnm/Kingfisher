//
//  ColumnsGaugeView.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 26/09/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit

@IBDesignable
class ColumnsGaugeView: UIView {

    // MARK: Class'es private properties
    
    private var data: [Float] = []
    private var titles: [String] = []
    private var titlesWidth: Int = 0
    private var valuesWidth: Int = 0
    private var graphStartX: Int = 1
    private var columnWidth: Int = 20
    private var graphHeight: Int = 0
    private var maxValueY: Int = 0
    private var minValueY: Int = 0
    private var titleHeight: Int = 20
    private var layoutLinesWidth: Int = 3
    
    private var maxValue: Float = FLT_MIN
    private var minValue: Float = FLT_MAX
    
    private var columnsColors: [UIColor] = [UIColor.red, UIColor.green]
    private var numberOfColumnsInGroup: Int = 2
    

    // MARK: Class Story Board properties
    
    @IBInspectable var isTripleColomns: Bool = true
    
    
    // MARK: Errors
    
    enum DataVlidationErrors: Error {
        case InavlidDataLengthError(text: String)
        case InvalidTitlesLengthError(text: String)
        case GeneralError
    }

    
    // MARK: Drawing methods
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("ColumnsGaugeView -> draw")
        
        /*
        // Check if we're going to draw empty data
         if data.count == 0 && titles.count == 0 {
            print("Empty data in ColumnsGaugeView -> draw")
            return
        }
        */
        
        // Get The context of this screen
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        drawColumns(ctx: ctx!)
        drawGraphLayout()
        drawValues();
    }
    
    func drawGraphLayout() {
        print("ColumnsGaugeView -> drawGraphLayout")
        
        // Create the Path Holder
        let myBezier = UIBezierPath()
        
        // Horizontal
        myBezier.move(to: CGPoint(x: CGFloat(graphStartX), y: CGFloat(graphHeight)))
        myBezier.addLine(to: CGPoint(x: bounds.width, y: CGFloat(graphHeight)))
        
        // Vertical
        myBezier.move(to: CGPoint(x: CGFloat(graphHeight), y: 0))
        myBezier.addLine(to: CGPoint(x: CGFloat(graphStartX), y: CGFloat(graphHeight)))
        
        // Set line width
        myBezier.lineWidth = CGFloat(layoutLinesWidth)

        // Set the stroke color
        UIColor.black.setStroke()

        // Draw the stroke
        myBezier.stroke()
    }
    
    func drawValues() {
        print("ColumnsGaugeView -> drawValues")
        print("ColumnsGaugeView -> drawValues does nothing")
    }
    
    func drawColumns(ctx: CGContext?) {
        print("ColumnsGaugeView -> drawColumns")
        var groupCounter = 0
        var x = graphStartX + 2
        for i in 0 ..< data.count {
            let modulo: Int = i % numberOfColumnsInGroup;
            if ((0 < i) && (modulo == 0)) {
                groupCounter = groupCounter + 1
                x += columnWidth / 2;
                drawTitle(xPos: x + 2, yPos: graphHeight + 2 as Int, title: String(titles[groupCounter]))
            } else if (0 == i) {
                drawTitle(xPos: x + 2, yPos: graphHeight + 2 as Int, title: String(titles[groupCounter]))
            }
            drawGraphColumn(value: data[i], x: x, currentColumnPaint: columnsColors[modulo], ctx: ctx!)
            x += columnWidth
        }
    }
    
    func drawGraphColumn(value: Float, x: Int, currentColumnPaint: UIColor, ctx: CGContext?) {
        print("ColumnsGaugeView -> drawGraphColumn")
        let y: Int = calculateYValue(value: value);
        drawRect(xPos: x, yPos: graphHeight - y - minValueY, width: /*x +*/ columnWidth, height: graphHeight, strokeColor: currentColumnPaint);
        let xPivot: Int = x + 5;
        let yPivot: Int = (graphHeight * 3 / 4) as Int
        drawRotatedText(ctx: ctx!, x: xPivot, y: yPivot, text: String(value), attributes: [NSForegroundColorAttributeName : UIColor.black.cgColor, NSFontAttributeName : UIFont.systemFont(ofSize: 12),])
    }
    
    private func drawRotatedText(ctx: CGContext, x: Int, y: Int, text: String, attributes: [String: AnyObject]) {
        print("ColumnsGaugeView -> rotateText")
        ctx.translateBy(x: 0, y: 0)
        ctx.scaleBy(x: 1, y: -1)
        let font = attributes[NSFontAttributeName] as! UIFont
        let attributedString = NSAttributedString(string: text as String, attributes: attributes)
        let textSize = text.size(attributes: attributes)
        let textPath = CGPath(rect: CGRect(x: CGFloat(-x), y: CGFloat(y) + font.descender, width: ceil(textSize.width), height: ceil(textSize.height)), transform: nil)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), textPath, nil)
        ctx.textMatrix = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        CTFrameDraw(frame, ctx)
        // Maybe need to rotate back to the previous position
        ctx.textMatrix = CGAffineTransform(rotationAngle: CGFloat(M_PI))
    }
    
    func drawRect(xPos: Int, yPos: Int, width: Int, height: Int, strokeColor: UIColor) {
        print("ColumnsGaugeView -> drawRect")
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: xPos,y :yPos), size: CGSize(width: width, height: height)))
//        let myBezier = UIBezierPath()
//        myBezier.move(to: CGPoint(x: xPos, y: yPos))
//        myBezier.addLine(to: CGPoint(x: xPos, y: height))
//        myBezier.addLine(to: CGPoint(x: width, y: height))
//        myBezier.addLine(to: CGPoint(x: width, y: yPos))
//        myBezier.close()
        strokeColor.setStroke()
//        myBezier.fill()   // stroke()
        rectPath.fill()
    }
    
    func drawTitle(xPos: Int, yPos: Int, title: String) {
        print("ColumnsGaugeView -> drawTitle")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Set Font's properties
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 14)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        // Draw the title
        title.draw(with: CGRect(x: xPos, y: yPos, width: columnWidth * numberOfColumnsInGroup, height: titleHeight), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
    // MARK: Logic part
    
    func setData(data: [Float], titles: [String]) throws {
        print("ColumnsGaugeView -> setData")
        let isValid = try? checkDataValidity(data: data, titles: titles)
        if (true == isValid) {
            self.data = data
            self.titles = titles
            graphHeight = Int(calculateGraphHeight(height: Float(bounds.height), titles: titles)) - 1
            maxValueY = Int(calculateMaxValueY(graphHeight: graphHeight))
            minValueY = Int(calculateMinValueY(graphHeight: graphHeight))
            maxValue = calculateMaxValue(data: data)
            minValue = calculateMinValue(data: data)
            initColumnsPaints()
            setNeedsDisplay()
        }
    }
    
    func calculateMaxValue(data: [Float]) -> Float {
        var theMax: Float = FLT_MIN;
        for i in 0 ..< data.count {
            if theMax < data[i] {
                theMax = data[i]
            }
        }
        return theMax;
    }
    
    func calculateMinValue(data: [Float]) -> Float {
        var theMin: Float = FLT_MAX
        for i in 0 ..< data.count {
            if theMin > data[i] {
                theMin = data[i]            }
        }
        return theMin;
    }
    
    func calculateYValue(value: Float) -> Int {
        let yDiff: Float = Float(maxValueY - minValueY)
        let valDiff: Float = maxValue - minValue
        return Int(((value - Float(minValue)) / valDiff) * yDiff)
    }
    
    func calculateMaxValueY(graphHeight: Int) -> Float {
        print("ColumnsGaugeView -> calculateMaxValueY")
        return Float(graphHeight * 100) / 120 * 1.1;   // Leave top space which is 10% of the value
    }

    func calculateMinValueY(graphHeight: Int) -> Float {
        print("ColumnsGaugeView -> calculateMinValueY")
        return Float(graphHeight * 100) / 12;   // Leave bottom space which is 10% of the value
    }

    func calculateGraphHeight(height: Float, titles: [String]!) -> Float {
        print("ColumnsGaugeView -> calculateGraphHeight")
        if titles?.count == 0 {
            return (height - 1)
        }
        titleHeight = 20 // Constant
        return height - (1.2 * Float(titleHeight))
    }
    
    func initColumnsPaints() {
        print("ColumnsGaugeView -> initColumnsPaints")
        if isTripleColomns {
            columnsColors = [UIColor.red, UIColor.yellow, UIColor.green]
            numberOfColumnsInGroup = 3
        } else {
            columnsColors = [UIColor.red, UIColor.green]
            numberOfColumnsInGroup = 2
        }
    }
    
    func checkDataValidity(data: [Float], titles: [String]) throws -> Bool {
        print("ColumnsGaugeView -> checkDataValidity")
        let factor = isTripleColomns ? 3 : 2
        if data.count % factor != 0 {
            throw DataVlidationErrors.InavlidDataLengthError(text: "data length must divided by \(factor)")
        }
        if titles.count % factor != 0 {
            throw DataVlidationErrors.InvalidTitlesLengthError(text: "titles length must divided by \(factor)")
        }
        if (data.count / titles.count) != factor {
            throw DataVlidationErrors.GeneralError
        }
        return true
    }

}
