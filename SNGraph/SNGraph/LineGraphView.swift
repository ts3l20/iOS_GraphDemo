//
//  LineGraphView.swift
//  SNGraph
//
//  Created by yoshTY on 2018/09/12.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import UIKit

class LineGraphView: UIView {
    
    var data: [GraphData]
    var pinchScale: CGFloat = 0
    var panDistance: CGFloat = 0
    
    init(frame: CGRect, data: [GraphData]) {
        self.data = data
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.backgroundColor = UIColor.clear
        self.clearsContextBeforeDrawing = true
    }
    
    override func draw(_ rect: CGRect) {
        
        let graphFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        let graphFrameView  = SNGraphFrame(frame: graphFrame)
        
        let xMin = data.reduce(0, { x, y -> CGFloat in
            if x > y.xPointsMin { return x} else {
                return y.xPointsMin
            }
        })
        
        let xMax = data.reduce(0, { x, y -> CGFloat in
            if x > y.xPointsMax { return x} else {
                return y.xPointsMax
            }
        })
        
        let yMin = data.reduce(0) { (x, y) -> CGFloat in
            if x > y.yPointsMin { return x } else {
                return y.yPointsMin
            }
        }
        
        let yMax = data.reduce(0) { (x, y) -> CGFloat in
            if x > y.yPointsMax { return x } else {
                return y.yPointsMax
            }
        }
        let xLength = xMax - xMin
        let yLength = yMax - yMin
        
        let numOfHorizontalLine: CGFloat = 4
        let numOfVarticalLine: CGFloat = 4
        
        graphFrameView.incrementValueinX = ((xLength/numOfHorizontalLine).rounded()) // 5
        graphFrameView.incrementValueinY = ((yLength/numOfVarticalLine).rounded())//5
        
        let graphRect = CGRect(x: graphFrameView.widthMarginonSide + graphFrameView.widthLabelMargin,
                               y: graphFrameView.heightUpperMargin,
                               width: graphFrameView.graphRecWidth,
                               height: graphFrameView.graphRecHeight)
        
        let lineGraphView = SNLineGraph(frame: graphRect, graphData: data)
        lineGraphView.clearsContextBeforeDrawing = true
        lineGraphView.backgroundColor = UIColor.clear
        
        
        graphFrameView.clearsContextBeforeDrawing = true
        graphFrameView.backgroundColor = UIColor.clear
        
        
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        
        
        self.addGestureRecognizer(pinchRecognizer)
        self.addGestureRecognizer(panRecognizer)
        
        self.addSubview(graphFrameView)
        self.addSubview(lineGraphView)
        
        self.layer.masksToBounds = true

    }
    
    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer){
        
        guard let graphFrameView = self.subviews[0] as? SNGraphFrame else {return}
        guard let lineGraphView = self.subviews[1] as? SNLineGraph else {return}
        
        
//        let testXPosition = recognizer.location(in: recognizer.view).x - recognizer.location(ofTouch: 1, in: recognizer.view).x
        
        pinchScale = recognizer.scale
        
        lineGraphView.xScale = pinchScale
        
        for subview in lineGraphView.subviews {
            subview.removeFromSuperview()
        }
        lineGraphView.setNeedsDisplay()
        
        graphFrameView.xScale = pinchScale
        for subview in graphFrameView.view.subviews {
            subview.removeFromSuperview()
        }
        graphFrameView.clearsContextBeforeDrawing = true
        graphFrameView.setNeedsDisplay()
    }
    
    
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){

        let translation = recognizer.translation(in: recognizer.view!.superview!)
        guard let graphFrameView = self.subviews[0] as? SNGraphFrame else {return}
        guard let lineGraphView = self.subviews[1] as? SNLineGraph else {return}
        
        lineGraphView.xTranslation = translation.x
        for subview in lineGraphView.subviews {
            subview.removeFromSuperview()
        }
        lineGraphView.setNeedsDisplay()

        graphFrameView.xTranslation = translation.x
        for subview in graphFrameView.view.subviews {
            subview.removeFromSuperview()
        }
        graphFrameView.setNeedsDisplay()


    }
}
