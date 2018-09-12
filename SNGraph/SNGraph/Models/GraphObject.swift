//
//  GraphObject.swift
//  SNGraph
//
//  Created by ts3l20 on 2018/09/07.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import Foundation
import UIKit

// object, such as line graph, bar graph,
protocol GraphObject {
    
    var view: UIView { get }
    
    var graphData: GraphData { get }
    
    var xScale: CGFloat {get set }
    
    var xTranslation: CGFloat {get set }
    
}

extension GraphObject {

    //Default values
    var view: UIView {
        return self as! UIView
    }
    
    var xScale: CGFloat {
        return 1.0
    }
    
    var xTranslation: CGFloat {
        return 0.0
    }

    
    var yValueMax: CGFloat {
        return graphData.yPointsMax
    }
    
    var xValueMax: CGFloat {
        return graphData.xPointsMax
    }
    
    var xValueMin: CGFloat {
        return graphData.xPointsMin
    }
    
    var graphRecWidth: CGFloat {
        return view.frame.width
    }
    
    var graphRecHeight: CGFloat {
        return view.frame.height
    }
    
    var graphMaxValue: CGFloat {    // for grid
        return findGraphMax(yValueMax)
    }
    
    var xPointSpace: CGFloat {
        return graphRecWidth / CGFloat(xValueMax - xValueMin) * xScale
    }
    
    
    func getXPoint(_ xValue: CGFloat) -> CGFloat {
        let x: CGFloat = xValue * xPointSpace
        return x + xTranslation
    }
    
    func getYPoint(_ yValue: CGFloat) -> CGFloat {
        let y: CGFloat = yValue * graphRecHeight / yValueMax
        return graphRecHeight - y
    }
    
    
    func findGraphMax(_ maxYValue: CGFloat) -> CGFloat {
        guard maxYValue > 0 else { return 0}
        let maxValue = Double(maxYValue)
        var returnValue = 100;
        if maxValue < 5 {
            returnValue = Int(maxValue.rounded(.up))
        } else if maxValue < 10 {
            returnValue = 10
        } else if maxValue < 100 {
            returnValue = Int( (maxValue/10).rounded(.up)*10 )
        } else if maxValue < 1000 {
            returnValue = Int( (maxValue/100).rounded(.up)*100 )
        } else if maxValue < 10000 {
            returnValue = Int( (maxValue/1000).rounded(.up)*1000 )
        } else {
            let divider: Double = pow(Double(10), findNumberOfDigit(maxValue))
            returnValue = Int( (maxValue/divider).rounded(.up)*divider )
        }
        
        return CGFloat(returnValue)
    }
    
    func findNumberOfDigit(_ number:Double) -> Double {
        var returnValue = 0.0
        var value = number
        while value > 1 {
            returnValue += 1
            value = value / 10
        }
        return returnValue
    }
    
}
