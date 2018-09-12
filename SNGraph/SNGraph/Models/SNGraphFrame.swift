//
//  SNGraphFrame.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/09.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit

//MARK: -
open class SNGraphFrame: UIView, GraphFrame {
    
    
    var xScale: CGFloat = 1.0
    var xTranslation: CGFloat = 0.0
    
    var incrementValueinX: CGFloat = 1.0
    var incrementValueinY: CGFloat = 1.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.view.backgroundColor = UIColor.clear
    }
    
    override open func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(rect: rect)
        path.addClip()
        
        drawGraduation()
        drawHorizontalLines()
        drawVerticalLines()
        drawRectangle(rect: rect)
        drawXscaleLabels(view, incrementValue: incrementValueinX)
        drawYscaleLabels(view, incrementValue: incrementValueinY)
    }
    
    // MARK: - draw graduation
    func drawGraduation(){
        
        let rect = CGRect(x: widthMarginonSide + widthLabelMargin, y: heightUpperMargin, width: graphRecWidth, height: graphRecHeight)
        let path = UIBezierPath(rect: rect)
        path.addClip()
        
        let startColor = SNWhite
        let endColor = UIColor.clear
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.saveGState()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: colorLocations)
        
        let startPoint = CGPoint.zero
        let endPoint   = CGPoint(x: 0, y: graphRecHeight)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
        
    }
    
    // MARK: - horizontal lines
    func drawHorizontalLines(){
        
        let hLinePath = UIBezierPath()
        
        //top line
        hLinePath.move(to: CGPoint(x:widthMarginonSide + widthLabelMargin, y: heightUpperMargin))
        hLinePath.addLine(to: CGPoint(x: graphRecWidth + widthMarginonSide + widthLabelMargin, y: heightUpperMargin))
        
        //bottom line
        hLinePath.move(to: CGPoint(x:widthMarginonSide + widthLabelMargin, y:heightUpperMargin + graphRecHeight))
        hLinePath.addLine(to: CGPoint(x:graphRecWidth + widthMarginonSide + widthLabelMargin, y:heightUpperMargin + graphRecHeight))
        
        let hLinecolor = UIColor.lightGray
        
        hLinecolor.setStroke()
        
        hLinePath.lineWidth = 1.0
        
        hLinePath.stroke()
        
        // lines between
        for i in 1..<numberOfHorizontalLine {
            hLinePath.move(to: CGPoint(x:widthMarginonSide + widthLabelMargin, y: heightUpperMargin + verticalLineSpace * CGFloat(i)))
            hLinePath.addLine(to: CGPoint(x: graphRecWidth + widthMarginonSide + widthLabelMargin,
                                          y: heightUpperMargin + verticalLineSpace * CGFloat(i)))
        }
        
        hLinePath.lineWidth = 0.3
        
        hLinePath.stroke()
        
    }
    
    func drawVerticalLines(){
        
        let vLinePath = UIBezierPath()
        
        //left line
        vLinePath.move(to: CGPoint(x: widthMarginonSide + widthLabelMargin, y: heightUpperMargin))
        vLinePath.addLine(to: CGPoint(x: widthMarginonSide + widthLabelMargin, y: heightUpperMargin + graphRecHeight))
        
        //right line
        vLinePath.move(to: CGPoint(x: widthMarginonSide + widthLabelMargin + graphRecWidth, y: heightUpperMargin))
        vLinePath.addLine(to: CGPoint(x: widthMarginonSide + widthLabelMargin + graphRecWidth, y: heightUpperMargin + graphRecHeight))
        
        let vLinecolor = UIColor.lightGray
        
        vLinecolor.setStroke()
        
        vLinePath.lineWidth = 1.0
        
        vLinePath.stroke()
        
        // lines between
        for i in 1..<numberOfVerticalLine {
            let xPosition: CGFloat = widthMarginonSide + widthLabelMargin + horizontalLineSpace * CGFloat(i) + xTranslation
            vLinePath.move(to: CGPoint(x: xPosition, y: heightUpperMargin + graphRecHeight))
            vLinePath.addLine(to: CGPoint(x:xPosition, y: heightUpperMargin + graphRecHeight - 5))
        }
        
        vLinePath.lineWidth = 0.3
        
        vLinePath.stroke()
        
    }
    
    // MARK: - draw rectangle
    func drawRectangle(rect: CGRect){
        
        let rectangle = UIBezierPath(rect: rect)
        
        let rectColor = UIColor.black
        let fillColor = UIColor.clear
        
        rectColor.setStroke()
        fillColor.setFill()
        rectangle.lineWidth = 1.0 
        
        rectangle.stroke()
        rectangle.fill()
        
    }
    
    // MARK: - draw labels
    func drawYscaleLabels(_ view: UIView, incrementValue: CGFloat){
        
        for i in 0...numberOfHorizontalLine {
            let yAxisLabel = UILabel()
            let labelValue = incrementValue * CGFloat(i)
            let string = String(format: "%.f", labelValue  )
            yAxisLabel.text = string
            yAxisLabel.font = UIFont.systemFont(ofSize: 9)
            yAxisLabel.textColor = UIColor.darkGray
            
            let xPosition = widthLabelMargin - 10
            let yPosition = heightUpperMargin + graphRecHeight - verticalLineSpace * CGFloat(i) - 5
            let newFrame = CGRect(x: xPosition, y: yPosition, width: 15, height: 10)
            yAxisLabel.frame = newFrame
            yAxisLabel.textAlignment = .right
            yAxisLabel.sizeToFit()
            view.addSubview(yAxisLabel)
            
        }
    }
    
    func drawXscaleLabels(_ view: UIView, incrementValue: CGFloat){
        let incValue = incrementValue / xScale
        for i in 0...numberOfVerticalLine {
            let xAxisLabel = UILabel()
            let labelValue = incValue * CGFloat(i);
            let string = String(format: "%.1f", labelValue  )
            xAxisLabel.text = string
            xAxisLabel.font = UIFont.systemFont(ofSize: 9)
            xAxisLabel.textColor = UIColor.darkGray
            
            let xPosition = widthMarginonSide + widthLabelMargin + horizontalLineSpace * CGFloat(i) - 8 + xTranslation
            let yPosition = graphRecHeight + 10
            let newFrame = CGRect(x: xPosition, y: yPosition, width: 16, height: 10)
            xAxisLabel.frame = newFrame
            xAxisLabel.textAlignment = .center
            xAxisLabel.sizeToFit()
            view.addSubview(xAxisLabel)
            
        }
        
    }
    
}
