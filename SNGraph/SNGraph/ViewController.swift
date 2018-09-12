//
//  ViewController.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/01.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawLineGraph()
        
        drawBarGraph()
    }
    
    // MARK: - Draw graphs
    func drawLineGraph() {
        
        let lineData = loadLineGraphData()
        
        let baseFrame = CGRect(x: 10, y: 20, width: view.frame.width-20, height: 200)
        
        let lineGraphView = LineGraphView(frame: baseFrame, data: lineData)
        
        self.view.addSubview(lineGraphView)
        
    }
    
    func drawBarGraph() {
    
        let barGraphData = loadBarGraphData()
        
        let barGraphBaseFrame = CGRect(x: 10, y: 220, width: view.frame.width - 20, height: 200)
        
        let barGraphView = BarGraphView(frame: barGraphBaseFrame, data: barGraphData)
        
        self.view.addSubview(barGraphView)
        
    }

    // MARK: - Load data
    func loadLineGraphData()->[MockData]{
        
        let xPoints:[CGFloat?] = [0.0, 1.0, 2.1, 3.1, 5.0, 7, 9, 11.5, 14, 16, 18, 20]
        
        let yPoints = randYValue(x: xPoints)
        
        let lineData1 = MockData(graphXPoints: xPoints, graphYPoints: yPoints)
        
        return [lineData1]
    }
    
    func loadBarGraphData()->[MockData]{

        let xPointsInt = Array(0...20)
        
        let xPoints = xPointsInt.map{ CGFloat($0)}
        
        let yPoints = randYValue(x: xPoints)
        
        let lineData1 = MockData(graphXPoints: xPoints, graphYPoints: yPoints)
        
        return [lineData1]
    }
    
    func randYValue(x: [CGFloat?]) -> [CGFloat] {
        
        var yPtsArr = [CGFloat]()
        
        guard let xPointMax = x.last else {return [0]}
        
        for element in x {
            
            if element == nil {
                
                yPtsArr.append(0)
                
            } else {
                
                let yPt = CGFloat( drand48() * Double(xPointMax!)  )
                
                yPtsArr.append( yPt )
            }
        }
        
        return yPtsArr
    }
    
    
}
