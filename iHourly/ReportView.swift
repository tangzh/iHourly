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

    
    var records = [NSManagedObject]()
    var projects = [String : Double]()
    var projectsPercentage = [String : Double]()
    var chartPart = 0.8
    
    var viewCenter: CGPoint {
        var centerFromView = convertPoint(center, fromView: superview)
        return CGPointMake(centerFromView.x , centerFromView.y * CGFloat(chartPart))
    }
    var viewRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * CGFloat(chartPart)
    }
    
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    var notationsPerRow = 3
    private var notationDistanceRatio = 50
    private var notationSize: CGSize {
        if let view = superview  {
            let distance = view.bounds.size.width / CGFloat(notationDistanceRatio)
            let totalWidth = view.bounds.size.width - CGFloat(notationsPerRow-1)*distance
            let width = totalWidth / CGFloat(notationsPerRow)
            let height = 10
            return CGSize(width: width, height: CGFloat(height))
        }else {
            return CGSize(width: CGFloat(0), height: CGFloat(0))
        }
    }


    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        getRecords()
        getGroupedProjects()
        drawPieParts()
        drawNotations()
    }
    
    func getRecords() {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context: NSManagedObjectContext = appDel.managedObjectContext {
            var request = NSFetchRequest(entityName: "Records")
            request.returnsObjectsAsFaults = false
            if let results = context.executeFetchRequest(request, error: nil) as? Array<NSManagedObject>{
                if results.count > 0{
                    records = results
                }
            }
        }
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
        
        println("\(projects)")
    }
    
    func drawPieParts() {
        var lastAngle = 0.0
        var startHeight: CGFloat = 0
        var count = 0
        if let view = superview {
             startHeight = view.bounds.size.height * CGFloat(chartPart)
        }
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
//            projectPath.stroke()
            color.setFill()
            projectPath.fill()
            lastAngle += 2*M_PI*value
            
            let notationOrigin = CGPointMake(CGFloat(count % notationsPerRow) * notationSize.width, startHeight + CGFloat(count / notationsPerRow) * notationSize.height)
            var frame = CGRect(origin: notationOrigin, size: notationSize)
            let notationView = UIView(frame: frame)
            notationView.backgroundColor = color
            superview?.addSubview(notationView)
            
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
    }
    
    func drawNotations() {
        
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    

}
