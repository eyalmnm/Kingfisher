//
//  MultiValuesColumnGaugeView.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 09/10/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit

@IBDesignable
class MultiValuesColumnGaugeView: UIView {
    
    // MARK: Class'es private properties
    
    private var data: [Float]! = []
    private var titles: [String]! = []
    
    private var graphHeight: Int = 0
    private var graphStartX: Int = 1
    private var maxValueY: Int = 0
    private var minValueY: Int = 0
    
    private var titleHeight: Int = 20
    private var layoutLinesWidth: Int = 3
    private var columnWidth: Int = 20
    
    private var maxValue: Float = FLT_MIN
    private var minValue: Float = FLT_MAX

    
    private var columnsColors: [UIColor] = [UIColor.red, UIColor.green]
    private var numberOfColumnsInGroup: Int = 2

    // MARK: Class Story Board properties
    
    @IBInspectable var isTripleColomns: Bool = true {
        didSet {
            initColumnsPaints()
            do {
                let isValid = try self.checkDataValidity(data: self.data, titles: self.titles)
                if isValid {
                    setNeedsDisplay()
                }
            } catch {
                print("MultiValuesColumnGaugeView -> error while setting isTripleColomns")
            }
        }
    }
    
    
    // MARK: Errors
    
    enum DataVlidationErrors: Error {
        case InavlidDataLengthError(text: String)
        case InvalidTitlesLengthError(text: String)
        case DataMismatchError(text: String)
        case NullPointerException(text: String)
        case GeneralError
    }
    
    
    // MARK: Drawing methods
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("MultiValuesColumnGaugeView -> draw")
        
        /*
         // Check if we're going to draw empty data
         if data.count == 0 && titles.count == 0 {
         print("Empty data in ColumnsGaugeView -> draw")
         return
         }
         */
        
        // Get The context of this screen
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        
        let factor = isTripleColomns ? 3 : 2
        drawColumns(ctx: ctx!, numberOfDataInGroup: factor)
        drawGraphLayout()
        drawValues();
    }
    
    func drawGraphLayout() {
        print("MultiValuesColumnGaugeView -> drawGraphLayout")
        
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
        print("MultiValuesColumnGaugeView -> drawValues")
        print("MultiValuesColumnGaugeView -> drawValues does nothing")
    }
    
    func drawColumns(ctx: CGContext?, numberOfDataInGroup: Int) {
        print("MultiValuesColumnGaugeView -> drawColumns")
        var groupCounter: Int = 0
        var x: Int = graphStartX + layoutLinesWidth + 9
        var y: Int = graphHeight - layoutLinesWidth - 8
        var dataHeight: Float = 0
        for i in 0 ..< data.count {
            let modulo = i % numberOfDataInGroup
            if (0 < i) && (modulo == 0) {
                groupCounter = groupCounter + 1
                x += Int(Float(columnWidth) * 2.5)
                y = graphHeight - layoutLinesWidth - 8
                drawTitle(xPos: x + 2, yPos: graphHeight + 11 as Int, title: String(titles[groupCounter]))
            } else if 0 == i {
                drawTitle(xPos: x + 2, yPos: graphHeight + 11 as Int, title: String(titles[groupCounter]))
            }
            dataHeight = calculateDataHeight(value: data[i])
            drawGraphColumn(value: data[i], x: x, y: y, dataHeight: Int(dataHeight), currentColumnPaint: columnsColors[modulo], ctx: ctx)
            y = Int(Float(y) - dataHeight)
        }
    }
    
    func drawGraphColumn(value: Float, x: Int, y: Int, dataHeight: Int, currentColumnPaint: UIColor, ctx: CGContext?) {
        print("MultiValuesColumnGaugeView -> drawGraphColumn")
        drawRect(xPos: x, yPos: y, width: x + columnWidth, height: dataHeight, strokeColor: currentColumnPaint);
        let xPivot: Int = x + 5;
        let yPivot: Int = (graphHeight * 3 / 4) as Int
        drawRotatedText(ctx: ctx!, x: xPivot, y: yPivot, text: String(value), attributes: [NSForegroundColorAttributeName : UIColor.black.cgColor, NSFontAttributeName : UIFont.systemFont(ofSize: 12),])
    }
    
    private func drawRotatedText(ctx: CGContext, x: Int, y: Int, text: String, attributes: [String: AnyObject]) {
        print("MultiValuesColumnGaugeView -> rotateText")
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
        print("MultiValuesColumnGaugeView -> drawRect")
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
        print("MultiValuesColumnGaugeView -> drawTitle")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Set Font's properties
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 14)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        // Draw the title
        title.draw(with: CGRect(x: xPos, y: yPos, width: columnWidth * numberOfColumnsInGroup, height: titleHeight), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
    // MARK: Logic part
    
    func setData(data: [Float]!, titles: [String]!) throws {
        print("MultiValuesColumnGaugeView -> setData")
        let isValid = try? checkDataValidity(data: data, titles: titles)
        if (true == isValid) {
            self.data = data
            self.titles = titles
            graphHeight = Int(calculateGraphHeight(height: Float(bounds.height), titles: titles)) - 1
            maxValueY = Int(calculateMaxValueY(graphHeight: graphHeight))
            minValueY = Int(calculateMinValueY(graphHeight: graphHeight))
            let factor = isTripleColomns ? 3 : 2
            maxValue = calculateMaxValue(data: data, numberOfDataInGroup: factor)
            minValue = calculateMinValue(data: data, numberOfDataInGroup: factor)
//            columnWidth = calculateColumnWidth(data, Float(bounds.width))
            initColumnsPaints()
            setNeedsDisplay()
        }
    }
    
    func calculateDataHeight(value: Float) -> Float {
        print("MultiValuesColumnGaugeView -> calculateDataHeight")
        let yDiff: Float = Float(maxValueY - minValueY)
        let valDiff: Float = maxValue - minValue
        return ((((value - minValue) / valDiff) * yDiff))
    }
    
    func calculateMinValue(data: [Float], numberOfDataInGroup: Int) -> Float {
        print("MultiValuesColumnGaugeView -> calculateMinValue")
        return 0
    }
    
    func calculateMaxValue(data: [Float], numberOfDataInGroup: Int) -> Float {
        print("MultiValuesColumnGaugeView -> calculateMaxValue")
        var retValue: Float = FLT_MIN
        var sum: Float = 0
        for i in 0 ..< data.count {
            sum = sum + data[i]
            if (i % numberOfDataInGroup == (numberOfDataInGroup - 1)) {
                if sum >= retValue {
                    retValue = sum
                }
                sum = 0
            }
        }
        return retValue
    }
    
    func calculateMaxValueY(graphHeight: Int) -> Float {
        print("MultiValuesColumnGaugeView -> calculateMaxValueY")
        return Float(graphHeight * 100) / 120 * 1.1;   // Leave top space which is 10% of the value
    }
    
    func calculateMinValueY(graphHeight: Int) -> Float {
        print("MultiValuesColumnGaugeView -> calculateMinValueY")
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
        print("MultiValuesColumnGaugeView -> initColumnsPaints")
        if isTripleColomns {
            columnsColors = [UIColor.red, UIColor.yellow, UIColor.green]
            numberOfColumnsInGroup = 3
        } else {
            columnsColors = [UIColor.red, UIColor.green]
            numberOfColumnsInGroup = 2
        }
    }

    private func checkDataValidity(data: [Float]!, titles: [String]!) throws -> Bool {
        print("MultiValuesColumnGaugeView -> checkDataValidity")
        let factor = isTripleColomns ? 3 : 2
        if true == data?.isEmpty {
            throw DataVlidationErrors.NullPointerException(text: "Data is Nil")
        }
        if true == titles?.isEmpty {
            throw DataVlidationErrors.NullPointerException(text: "Titles is nil")
        }
        if data.count % factor != 0 {
            throw DataVlidationErrors.InavlidDataLengthError(text: "data length must divided by \(factor)")
        }
        if titles.count % factor != 0 {
            throw DataVlidationErrors.InvalidTitlesLengthError(text: "titles length must divided by \(factor)")
        }
        if (data.count / titles.count) != factor {
            throw DataVlidationErrors.DataMismatchError(text: "Data and Titles length mismatch")
        }
        return true
    }
}
