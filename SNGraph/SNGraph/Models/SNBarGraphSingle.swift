//
//  SNBarGraphSingle.swift
//  SNGraph
//
//  Created by ts3l20 on 2018/09/11.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import Foundation
import UIKit


protocol BarGraph: GraphObject {
    var barWidth: CGFloat {get set }
}

extension BarGraph {
    var barWidth: CGFloat {
        return 10
    }
    
    var xPointSpace: CGFloat {
        return graphRecWidth / CGFloat(graphData.dataCount) * xScale
    }
    
    func getXPoint(_ xValue: CGFloat) -> CGFloat {
        let x: CGFloat = xPointSpace * 0.5 + xValue * xPointSpace
        return x + xTranslation
    }
    
    func GetXBarLeft(_ xValue: CGFloat) -> CGFloat {
        return getXPoint(xValue) - barWidth/2
    }
    
    func GetXBarRight(_ xValue: CGFloat) -> CGFloat {
        return getXPoint(xValue) + barWidth/2
    }
    
    func GetYBarUpper(_ yValue: CGFloat) -> CGFloat {
        return getYPoint(yValue)
    }
    
    func GetYBarBottom(_ yValue: CGFloat) -> CGFloat {
        return graphRecHeight
    }
    
    
}

open class SNBarGraphSingle: UIView, BarGraph {
    var graphData: GraphData
    
    var xScale: CGFloat = 1.0
    var xTranslation: CGFloat = 0.0
    
    var color = UIColor.white
    var barWidth: CGFloat = 5.0
    
    init(frame: CGRect, graphData: GraphData) {
        self.graphData = graphData
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.view.backgroundColor = UIColor.clear
        self.clearsContextBeforeDrawing = true
    }
    
    override open func draw(_ rect: CGRect) {
        let xPoints = graphData.graphXPoints
        let yPoints = graphData.graphYPoints
        let path = drawBars(xPts: xPoints, yPts: yPoints)
        drawGraduation(path: path)
    }
    
    
    func drawBars(xPts: [CGFloat?], yPts: [CGFloat?]) -> UIBezierPath? {
        
        let barPath = UIBezierPath()
        
        for i in 0..<yPts.count {
            
            guard let xPts = xPts[i], let yPts = yPts[i] else { return nil }
            let firstPoint  = CGPoint(x:GetXBarLeft(xPts),  y:GetYBarBottom(yPts))
            let secondPoint = CGPoint(x:GetXBarLeft(xPts),  y:GetYBarUpper(yPts))
            let thirdPoint =  CGPoint(x:GetXBarRight(xPts), y:GetYBarUpper(yPts))
            let fourthPoint = CGPoint(x:GetXBarRight(xPts), y:GetYBarBottom(yPts))
//            print("coord is ", secondPoint, thirdPoint)
            
            barPath.move(to: firstPoint)
            barPath.addLine(to: secondPoint)
            barPath.addLine(to: thirdPoint)
            barPath.addLine(to: fourthPoint)
            barPath.close()
            
            let barLinecolor = SNOcean
            barLinecolor.setStroke()
            
            barPath.lineWidth = 0.2
            barPath.stroke()
            
            
        }
        
        return barPath
        
        
    }
    
    func drawGraduation(path: UIBezierPath?){
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.saveGState()
        
        path?.addClip()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: colorLocations)
        
        let yMaxCGPoint = getYPoint(yValueMax)
        let startPoint = CGPoint(x:0, y: yMaxCGPoint)
        let endPoint   = CGPoint(x:0, y:graphRecHeight-1)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
        
    }
    
    
    
}
