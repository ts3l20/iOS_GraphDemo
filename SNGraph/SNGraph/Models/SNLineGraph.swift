//
//  SNGraphs.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/09.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit



open class SNLineGraph: UIView {
    var graphData: [GraphData]
    
    var xScale: CGFloat = 1.0
    var xTranslation: CGFloat = 0.0
    
    var color = UIColor.white
    
    init(frame: CGRect, graphData: [GraphData]) {
        self.graphData = graphData
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.backgroundColor = UIColor.clear
        
    }
    
    override open func draw(_ rect: CGRect) {
                
        for graph in graphData {
            let lineGraph = SNLineGraphSingle(frame: rect, graphData: graph)
            lineGraph.xScale = xScale
            lineGraph.xTranslation = xTranslation
            lineGraph.setNeedsLayout()
            self.addSubview(lineGraph)
        }

    }
}

