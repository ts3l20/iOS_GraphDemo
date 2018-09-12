//
//  GraphData.swift
//  SNGraph
//
//  Created by ts3l20 on 2018/09/07.
//  Copyright © 2018年 sonauma. All rights reserved.
//

import Foundation
import UIKit

protocol GraphData {
    var graphXPoints: [CGFloat?] { get }
    var graphYPoints: [CGFloat?] { get }
}

extension GraphData {
    var yPointsMin: CGFloat {
        return graphYPoints.compactMap{ $0 }.min()!
    }
    
    var yPointsMax: CGFloat {
        return graphYPoints.compactMap{ $0 }.max()!
    }
    
    var xPointsMin: CGFloat {
        return graphXPoints.compactMap{ $0 }.min()!
    }
    
    var xPointsMax: CGFloat {
        return graphXPoints.compactMap{ $0 }.max()!
    }
    
    var dataCount: Int {
        return graphXPoints.count
    }
}
