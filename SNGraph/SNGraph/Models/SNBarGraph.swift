//
//  SNBarGraph.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/12.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit


open class SNBarGraph: UIView {
    
    var graphs: [GraphData] = []
    var xScale: CGFloat = 1.0
    var xTranslation: CGFloat = 0.0
    
    var color = UIColor.white
    var barWidth: CGFloat = 5.0
    
    init(frame: CGRect, graphData: [GraphData]) {
        self.graphs = graphData
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

        for (_, line) in graphs.enumerated() {
            let xPos:CGFloat = 0, yPos: CGFloat = 0
            let rect = CGRect(x: xPos, y: yPos, width: self.frame.width, height: self.frame.height)
            let singleBar = SNBarGraphSingle(frame: rect, graphData: line)
            
            self.addSubview(singleBar)
        }
    }
    
    
}
