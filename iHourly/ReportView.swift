//
//  ReportView.swift
//  iHourly
//
//  Created by tang on 3/10/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class ReportView: UIView {
    var records: [[String: String]] = [[ "projectName" : "study"], ["projectName" : "work"], ["projectName" : "study"], ["projectName" : "study"], ["projectName" : "193p"]]
    var projects = [String : Double]()
    var projectCount = [String : Double]()
    
    var viewCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var viewRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * 0.9
    }
    
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        getGroupedProjects()
        drawParts()
    }
    
    func getGroupedProjects() {
        for record in records {
            let project = record["projectName"]
            if projects[project!] != nil{
               projects[project!]! += 1
            }else {
               projects[project!] = 1
            }
        }
        
        for(key, value) in projects {
            projects[key] = value / Double(records.count)
        }
        
        println("\(projects)")
    }
    
    func drawParts() {
        var lastAngle = 0.0
        for (key, value) in projects {
            let projectPath = UIBezierPath(
                arcCenter: viewCenter,
                radius: viewRadius,
                startAngle: CGFloat(lastAngle),
                endAngle: CGFloat(2*M_PI*value+lastAngle),
                clockwise: true
            )
            projectPath.lineWidth = lineWidth
            projectPath.addLineToPoint(viewCenter)
//            projectPath.addLineToPoint(CGPointMake(viewCenter.x + viewRadius, viewCenter.y))
            var color = getRandomColor()
            color.setStroke()
//            projectPath.stroke()
            color.setFill()
            projectPath.fill()
            lastAngle += 2*M_PI*value
        }
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    

}
