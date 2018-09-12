//
//  GraphFrame.swift
//  SNGraph
//
//  Created by ts3l20 on 2018/09/11.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import Foundation
import UIKit

protocol GraphFrame {
    var view: UIView { get }
    
    var widthMarginonSide: CGFloat { get }
    var widthLabelMargin: CGFloat { get }
    var heightUpperMargin: CGFloat { get }
    var heightBottomMargin: CGFloat { get }
    
    var xScale: CGFloat {get set }
    var xTranslation: CGFloat {get set }
    
}

extension GraphFrame {
    
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
    
    var widthMarginonSide: CGFloat {
        return 10
    }
    
    var widthLabelMargin: CGFloat {
        return 20
    }
    
    var heightUpperMargin: CGFloat {
        return 10
    }
    
    var heightBottomMargin: CGFloat {
        return 20
    }
    
    var numberOfVerticalLine: Int {
        return 4
    }
    
    var numberOfHorizontalLine: Int {
        return 4
    }
    
    
    
    var graphRecWidth: CGFloat {
        return view.frame.width - widthMarginonSide * 2 - widthLabelMargin
    }
    
    var graphRecHeight: CGFloat {
        return view.frame.height - heightUpperMargin - heightBottomMargin
    }


    
    var verticalLineSpace: CGFloat {
        return (graphRecHeight) / CGFloat(numberOfVerticalLine)
    }
    
    var horizontalLineSpace: CGFloat {
        return (graphRecWidth) / CGFloat(numberOfHorizontalLine)
    }
    
    
}
