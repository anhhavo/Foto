//
//  Line.swift
//  Drawing app
//
//  Created by Isabelle Xu on 9/30/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

// Handles drawing and rendering of Line custom UIViews
class Line: UIView {
    
    var isLine = false
    
    // refresh what is displayed in the view
    var lineData: LineData? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // make sure background starts as clear
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // where the custom drawing will take place (called automatically)
    override func draw(_ rect: CGRect) {
        // make sure lineData is accessible
        if lineData != nil && lineData!.CGpoints.count != 0 {
            
            let thickness = CGFloat(lineData!.thickness)
            let color: UIColor = lineData!.color
            let points = lineData!.CGpoints
            
            if isLine {
                let line = UIBezierPath()
                line.move(to: points[0])
                line.addLine(to: points[points.count-1])
                line.lineWidth = thickness
                color.setStroke()
                color.setFill()
                line.lineCapStyle = .round
                line.stroke()
                
            } else {
                let line = createQuadPath(points: points)
                
                line.lineWidth = thickness
                color.setStroke()
                color.setFill()
                
                let edge_1 = UIBezierPath()
                let edge_2 = UIBezierPath()
                
                // deal with jagged line corners with rounded arcs
                edge_1.addArc(
                    withCenter: points[0], // beginning of line
                    radius: thickness/2.0,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true
                )
                
                edge_2.addArc(
                    withCenter: points[points.count - 1], // end of line
                    radius: thickness/2.0,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true
                )
                
                edge_1.fill(with: .normal, alpha: 1)
                edge_2.fill(with: .normal, alpha: 1)
                line.lineCapStyle = .round
                // Draws a line along the receiver’s path using the current drawing properties.
                line.stroke()
            }
        }
    }
    
    
    // takes in an array of CGPoints, and returns a smooth UIBezierPath
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        let x_point = (first.x + second.x)/2
        let y_point = (first.y + second.y)/2
        return CGPoint(x: x_point, y: y_point)
    }
    
    func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidpoint = midpoint(first: firstPoint, second: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidpoint)
        for index in 1 ..< points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
    
    
}
