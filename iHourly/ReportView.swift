//
//  ReportView.swift
//  iHourly
//
//  Created by tang on 3/10/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import CoreData

class ReportView: UIView {
    
    var records: Array<NSManagedObject> = [NSManagedObject]() {
        didSet {
            setNeedsDisplay()
        }
    }
    var projects = [String : Double]()
    var projectsPercentage = [String : Double]()
    var chartPart = 0.8
    
//    var selfWidth = self.bounds.size.width
//    var selfHeight = self.bounds.size.height
    
    var viewCenter: CGPoint {
        var centerFromView = convertPoint(center, fromView: superview)
        return CGPointMake(self.bounds.midX, self.bounds.midY * CGFloat(chartPart))
    }
    var viewRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * CGFloat(chartPart)
    }
    
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    var notationsPerRow = 3
    private var notationDistanceRatio = 50
    private var notationSize: CGSize {
        let view = self
        let distance = view.bounds.size.width / CGFloat(notationDistanceRatio)
        let totalWidth = view.bounds.size.width - CGFloat(notationsPerRow-1)*distance
        let width = totalWidth / CGFloat(notationsPerRow)
        let height = 20
        return CGSize(width: width, height: CGFloat(height))
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        projects.removeAll()
        projectsPercentage.removeAll()
        for view in self.subviews  {
//            if view is UILabel {
//               view.removeFromSuperview()
//            }
            view.removeFromSuperview()
        }
        
        getGroupedProjects()
        drawPieParts()
    }
    
    func getGroupedProjects() {
        var totalTime = 0
        for record in records {
            if let project = record.valueForKey("project") as? String {
                if let timeLength = record.valueForKey("timeLength") as? Int {
                    totalTime += timeLength
                    if projects[project] != nil{
                        projects[project]! += Double(timeLength)
                    }else {
                        projects[project] = Double(timeLength)
                    }
                }
            }
        }
        
        for(key, value) in projects {
            projectsPercentage[key] = value / Double(totalTime)
        }
        
//        println("\(projects)")
//        println("\(projectsPercentage)")
    }
    
    
    func drawPieParts() {
        var lastAngle = 0.0
        var startHeight: CGFloat = 0
        var count = 0
//        if let view = superview {
//             startHeight = view.bounds.size.height * CGFloat(chartPart)
//        }
        
        var scrollView = UIScrollView(frame: CGRect(origin: CGPointMake(0,CGFloat(chartPart) * self.bounds.size.height), size: CGSize(width: self.bounds.size.width, height: CGFloat(1-chartPart) * self.bounds.size.height)))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true

        for (key, value) in projectsPercentage {
            let layer = CAShapeLayer()
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
            color.setFill()
            projectPath.fill()
            lastAngle += 2*M_PI*value
            
            let distance = self.bounds.size.width / CGFloat(notationDistanceRatio)
            let originX = CGFloat(count % notationsPerRow) * (notationSize.width + distance)
            let originY = CGFloat(Int(count / notationsPerRow) * 2) * notationSize.height + startHeight
            let notationOrigin = CGPointMake(originX, originY)
            var frame = CGRect(origin: notationOrigin, size: notationSize)
            let notationView = UIView(frame: frame)
            notationView.backgroundColor = color
            scrollView.addSubview(notationView)
            
            let textX = originX
            let textY = originY + notationSize.height
            var notationLabel = UILabel(frame: CGRect(x: textX, y: textY, width: notationSize.width, height: notationSize.height))
            notationLabel.textAlignment = NSTextAlignment.Center
            notationLabel.text = key
            notationLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(notationLabel)
            
            count += 1
            
//            layer.path = projectPath.CGPath
//            layer.fillColor = color.CGColor
//            self.layer.addSublayer(layer)
//            let animation = CABasicAnimation(keyPath: "path")
//            animation.fillMode = kCAFillModeForwards
//            animation.duration = 2
//            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//            animation.fromValue = NSNumber(double: lastAngle)
//            animation.toValue = NSNumber(float: 1.0)
//            layer.addAnimation(animation, forKey: nil)
        }
        scrollView.contentSize = CGSize(width: self.bounds.size.width, height: CGFloat(Int(count / notationsPerRow) * 2 + 2) * notationSize.height )
//        scrollView.contentOffset = CGPointMake(0, CGFloat(0.7) * superview!.bounds.size.height)
        self.addSubview(scrollView)
//        println("scroll view subviews are \(scrollView.subviews)")
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    

}
