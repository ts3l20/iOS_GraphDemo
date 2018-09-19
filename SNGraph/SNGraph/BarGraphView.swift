//
//  BarGraphView.swift
//  SNGraph
//
//  Created by yoshTY on 2018/09/12.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var data: [GraphData]
    
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
        
        
        // frame
        let barGraphFrame = CGRect(x: 0,
                                   y: 0,
                                   width: self.frame.size.width,
                                   height: self.frame.size.height)
        
        let barGraphFrameView = SNGraphFrame(frame: barGraphFrame)
        
        // graph
        let barGraphRect = CGRect(x: barGraphFrameView.widthMarginonSide + barGraphFrameView.widthLabelMargin,
                                  y: barGraphFrameView.heightUpperMargin,
                                  width: barGraphFrameView.graphRecWidth,
                                  height: barGraphFrameView.graphRecHeight)
        
        let barGraphView = SNBarGraph(frame: barGraphRect, graphData: data)
        
        barGraphView.layer.borderColor = UIColor.lightGray.cgColor
        
        barGraphView.layer.borderWidth = 1.0
        
        self.addSubview(barGraphFrameView)
        
        self.addSubview(barGraphView)
    }
}
