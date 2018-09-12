//
//  SNLineGraphSingle.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/11.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit

protocol LineGraphSingle: GraphObject {
    var lineWidth : CGFloat { get }
}

extension LineGraphSingle {
    var lineWidth: CGFloat {
        return 1.0
    }
}

open class SNLineGraphSingle: UIView, LineGraphSingle {
    var graphData: GraphData
    var xScale: CGFloat = 1.0
    var xTranslation: CGFloat = 0.0
    
    var color = UIColor.white
    
    init(frame: CGRect, graphData: GraphData) {
        self.graphData = graphData
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.backgroundColor = UIColor.clear
        self.clearsContextBeforeDrawing = true
    }
    
    override open func draw(_ rect: CGRect) {
        
        var xPoints = graphData.graphXPoints
        var yPoints = graphData.graphYPoints
        
        let linePath = drawLine(xPts: xPoints, yPts: yPoints)
        drawGraduation(xPts: xPoints, yPts: yPoints, path: linePath!)
        drawSymbols(xPts: xPoints, yPts: yPoints)
        
        xPoints = []
        yPoints = []
        
        linePath?.removeAllPoints()
        
    }
    
    func drawLine(xPts: [CGFloat?], yPts: [CGFloat?]) -> UIBezierPath?{
        
        let graphPath = UIBezierPath()
        
        let xPoint0 = getXPoint(xPts[0]!)
        let yPoint0 = getYPoint(yPts[0]!)
        graphPath.move(to: CGPoint(x:xPoint0, y:yPoint0))
        
        for i in 1..<yPts.count {
            let xPointi = getXPoint(xPts[i]!)
            let yPointi = getYPoint(yPts[i]!)
            let nextPoint = CGPoint(x:xPointi, y:yPointi)
            graphPath.addLine(to: nextPoint)
        }
        
        let lineColor = UIColor.blue
        lineColor.setFill()
        lineColor.setStroke()
        graphPath.lineWidth = 0.8
        graphPath.stroke()
        
        return graphPath
        
    }
    
    func drawGraduation(xPts: [CGFloat?], yPts: [CGFloat?], path: UIBezierPath) {
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.saveGState()
        
        let clippingPath = path.copy() as! UIBezierPath
        
        let xPtsLast = getXPoint(xPts.last!!)
        let yPtsLast = getYPoint(yPts.last!!)
        let xPtsFirst = getXPoint(xPts.first!!)
        let yPtsFirst = getYPoint(yPts.first!!)
        clippingPath.move(to: CGPoint(x: xPtsLast,  y: yPtsLast))
        clippingPath.addLine(to: CGPoint(x: xPtsLast,  y: graphRecHeight))
        clippingPath.addLine(to: CGPoint(x: xPtsFirst, y: graphRecHeight))
        clippingPath.addLine(to: CGPoint(x: xPtsFirst, y: yPtsFirst))
        
        clippingPath.close()
        
        clippingPath.addClip()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: colorLocations)
        
        let yMaxCGPoint = getYPoint(yValueMax)
        let startPoint = CGPoint(x: 0 , y: yMaxCGPoint)
        let endPoint   = CGPoint(x: 0, y: graphRecHeight-1)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
        
    }
    
    // MARK: - draw symbols
    func drawSymbols(xPts: [CGFloat?], yPts: [CGFloat?]){
        
        for i in 0..<yPts.count {
            let xPointi = getXPoint(xPts[i]!)
            let yPointi = getYPoint(yPts[i]!)
            var point = CGPoint(x:xPointi, y: yPointi)
            
            let width:CGFloat = 4.0
            let height:CGFloat = 4.0
            point.x -= width/2
            point.y -= height/2
            
            let circlePath = UIBezierPath(ovalIn:
                CGRect(origin: point, size: CGSize(width: width, height: height)))
            
            let circleColor = SNOcean
            circleColor.setFill()
            circlePath.fill()
            
            circleColor.setStroke()
            circlePath.lineWidth = 1
            circlePath.stroke()
        }
        
    }
}
