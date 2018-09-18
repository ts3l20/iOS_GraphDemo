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
    var resetButton = UIButton()
    
    var graphFrameView: SNGraphFrame!
    var lineGraphView: SNLineGraph!
    
    
    init(frame: CGRect, data: [GraphData]) {
        self.data = data
        self.resetButton.isHidden = true
        
        
        super.init(frame: frame)
        
        let graphFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.graphFrameView = SNGraphFrame(frame: graphFrame)
        let graphRect = CGRect(x: graphFrameView.widthMarginonSide + graphFrameView.widthLabelMargin,
                               y: graphFrameView.heightUpperMargin,
                               width: graphFrameView.graphRecWidth,
                               height: graphFrameView.graphRecHeight)
        self.lineGraphView = SNLineGraph(frame: graphRect, graphData: data)
        self.addSubview(graphFrameView)
        self.addSubview(lineGraphView)
        graphFrameView.tag = 1001
        lineGraphView.tag = 1002

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
        
        // Set Graph Frane View: grid length, figure
        guard let graphFrameView  = self.viewWithTag(1001) as? SNGraphFrame else {
            return
        }
        
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
        
        graphFrameView.incrementValueinX = ((xLength/numOfHorizontalLine).rounded())
        graphFrameView.incrementValueinY = ((yLength/numOfVarticalLine).rounded())
        
        // Set Line Graph View: adding Gestures
        guard let lineGraphView  = self.viewWithTag(1002) as? SNLineGraph else {
            return
        }
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        
        self.addGestureRecognizer(pinchRecognizer)
        self.addGestureRecognizer(panRecognizer)
        
        self.addSubview(graphFrameView)
        self.addSubview(lineGraphView)

    }
    
    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer){
        
        guard let graphFrameView = self.subviews[0] as? SNGraphFrame else {return}
        guard let lineGraphView = self.subviews[1] as? SNLineGraph else {return}
        
        pinchScale = recognizer.scale
        
        if pinchScale == 1.0 {
            hideResetDispBtn()
        } else {
            if self.resetButton.isHidden == true {
                let baseFrame = lineGraphView.frame
                let btnFrame = CGRect(x: baseFrame.width - 30, y: 10, width: 20, height: 20)
                showResetDispBtn(frame: btnFrame)
            }
        }
        
        lineGraphView.xScale = pinchScale
        
        for subview in lineGraphView.subviews {
            subview.removeFromSuperview()
        }
        
        lineGraphView.setNeedsDisplay()
        
        
        graphFrameView.xScale = pinchScale
        
        for subview in graphFrameView.view.subviews {
            subview.removeFromSuperview()
        }
        
        graphFrameView.setNeedsDisplay()
    }
    
    
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){

        guard let graphFrameView = self.subviews[0] as? SNGraphFrame else {return}
        guard let lineGraphView = self.subviews[1] as? SNLineGraph else {return}

        let translation = recognizer.translation(in: recognizer.view!.superview!)
        lineGraphView.xTranslation = translation.x
        
        if lineGraphView.xTranslation == 0.0 {
            hideResetDispBtn()
        } else {
            if self.resetButton.isHidden == true {
                let baseFrame = lineGraphView.frame
                let btnFrame = CGRect(x: baseFrame.width - 30, y: 10, width: 20, height: 20)
                showResetDispBtn(frame: btnFrame)
            }
        }
        
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

    
    func showResetDispBtn(frame: CGRect){
        self.resetButton = UIButton(frame: frame)
        let btnImageName = "IcnSetWhtNormal"
        let btnImage = UIImage(named: btnImageName)
        resetButton.setImage(btnImage, for: .normal)
        self.resetButton.addTarget(self, action: #selector(setDisplaySettingNormal), for: .touchUpInside)
        self.addSubview(self.resetButton)
        
    }
    
    func hideResetDispBtn(){
        self.resetButton.isHidden = true
        self.resetButton.removeFromSuperview()
    }
    
    @objc func setDisplaySettingNormal(){
        guard let graphFrameView = self.subviews[0] as? SNGraphFrame else {return}
        guard let lineGraphView = self.subviews[1] as? SNLineGraph else {return}
        
        for subview in lineGraphView.subviews {
            subview.removeFromSuperview()
        }
        lineGraphView.xScale = 1
        lineGraphView.xTranslation = 0
        lineGraphView.setNeedsDisplay()
        
        
        for subview in graphFrameView.view.subviews {
            subview.removeFromSuperview()
        }
        graphFrameView.xScale = 1
        graphFrameView.xTranslation = 0
        graphFrameView.setNeedsDisplay()
        
        hideResetDispBtn()
    }
}
