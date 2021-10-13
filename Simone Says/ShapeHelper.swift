//
//  ShapeHelper.swift
//  CuddyMadge
//
//  Created by Matt Larsen on 3/10/21
//

import UIKit

class ShapeHelper: UIView {

    //MARK: - Shapes
   
    static func wedge() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 195, y: 197.5))
        path.addCurve(to: CGPoint(x: 195, y: 193.6), controlPoint1: CGPoint(x: 195, y: 196.2), controlPoint2: CGPoint(x: 195, y: 194.9))
        path.addCurve(to: CGPoint(x: 5, y: 2.5), controlPoint1: CGPoint(x: 195, y: 88.4), controlPoint2: CGPoint(x: 110, y: 3))
        path.addLine(to: CGPoint(x: 5, y: 197.5))
        path.addLine(to: CGPoint(x: 195, y: 197.5))
        path.close()
        return path
    }
    
    static func wedge2() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 149.9, y: 150))
        path.addCurve(to: CGPoint(x: 150, y: 146.9), controlPoint1: CGPoint(x: 149.9, y: 149), controlPoint2: CGPoint(x: 150, y: 148))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 150, y: 66.1), controlPoint2: CGPoint(x: 82.9, y: 0.5))
        path.addLine(to: CGPoint(x: 0, y: 150))
        path.addLine(to: CGPoint(x: 149.9, y: 150))
        path.close()
        return path
    }
    
    static func orangeWedge() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 75.3, y: 168.4))
        path.addLine(to: CGPoint(x: 182.1, y: 115))
        path.addCurve(to: CGPoint(x: 147.4, y: 63.8), controlPoint1: CGPoint(x: 173.3, y: 96.1), controlPoint2: CGPoint(x: 161.5, y: 78.9))
        path.addLine(to: CGPoint(x: 57.8, y: 142.2))
        path.addLine(to: CGPoint(x: 136.2, y: 52.7))
        path.addCurve(to: CGPoint(x: 85.5, y: 19), controlPoint1: CGPoint(x: 121.3, y: 39.1), controlPoint2: CGPoint(x: 104.2, y: 27.7))
        path.addLine(to: CGPoint(x: 31.9, y: 124.8))
        path.addLine(to: CGPoint(x: 70.9, y: 13))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 48.9, y: 4.7), controlPoint2: CGPoint(x: 25, y: 0.1))
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 199.9, y: 200))
        path.addCurve(to: CGPoint(x: 200, y: 195.9), controlPoint1: CGPoint(x: 199.9, y: 198.6), controlPoint2: CGPoint(x: 200, y: 197.3))
        path.addCurve(to: CGPoint(x: 188.2, y: 129.7), controlPoint1: CGPoint(x: 200, y: 172.7), controlPoint2: CGPoint(x: 195.8, y: 150.4))
        path.addLine(to: CGPoint(x: 75.3, y: 168.4))
        path.close()
        return path
    }
    
    static func boink() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 117.8, y: 56.2))
        path.addLine(to: CGPoint(x: 140.4, y: 33.6))
        path.addLine(to: CGPoint(x: 116.4, y: 9.6))
        path.addLine(to: CGPoint(x: 93.6, y: 32.4))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 68, y: 12.3), controlPoint2: CGPoint(x: 35.4, y: 0.2))
        path.addLine(to: CGPoint(x: 0, y: 126))
        path.addLine(to: CGPoint(x: 0, y: 150))
        path.addLine(to: CGPoint(x: 24, y: 150))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addLine(to: CGPoint(x: 150, y: 142.5))
        path.addCurve(to: CGPoint(x: 117.8, y: 56.2), controlPoint1: CGPoint(x: 148.9, y: 110), controlPoint2: CGPoint(x: 137.1, y: 80.1))
        path.close()
        return path
    }
    
    static func flattenedCurve() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 150))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 150, y: 24.2), controlPoint2: CGPoint(x: 125.8, y: 0))
        path.close()
        return path
    }
    
    static func inwardCurve() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 150))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 150, y: 84.1), controlPoint2: CGPoint(x: 65.9, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 150))
        path.close()
        return path
    }
    
    static func smallWedge() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 150))
        path.addLine(to: CGPoint(x: 143.5, y: 150))
        path.addCurve(to: CGPoint(x: 0, y: 6.5), controlPoint1: CGPoint(x: 143.5, y: 70.8), controlPoint2: CGPoint(x: 79.2, y: 6.5))
        path.addLine(to: CGPoint(x: 0, y: 150))
        path.close()
        return path
    }
    
    static func circle() -> CAShapeLayer {
        let circle = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        path.close()
        circle.path = path.cgPath
        circle.fillColor = UIColor.black.cgColor
        return circle
    }

    static func elephant() -> CAShapeLayer {
        let elephant = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 77.7, y: 221.4))
        path.addCurve(to: CGPoint(x: 118.9, y: 157.2), controlPoint1: CGPoint(x: 122.3, y: 223.8), controlPoint2: CGPoint(x: 115.7, y: 203.5))
        path.addCurve(to: CGPoint(x: 172.8, y: 37.4), controlPoint1: CGPoint(x: 120.8, y: 129.7), controlPoint2: CGPoint(x: 103.5, y: 84))
        path.addCurve(to: CGPoint(x: 240.5, y: 13.1), controlPoint1: CGPoint(x: 182.2, y: 31.1), controlPoint2: CGPoint(x: 182.3, y: 32.7))
        path.addCurve(to: CGPoint(x: 294.3, y: 2.8), controlPoint1: CGPoint(x: 275.2, y: 1.4), controlPoint2: CGPoint(x: 287.5, y: -3.6))
        path.addCurve(to: CGPoint(x: 300.5, y: 42.3), controlPoint1: CGPoint(x: 299.8, y: 8), controlPoint2: CGPoint(x: 295.5, y: 15.2))
        path.addCurve(to: CGPoint(x: 308.8, y: 67.9), controlPoint1: CGPoint(x: 303, y: 55.5), controlPoint2: CGPoint(x: 304.3, y: 62.2))
        path.addCurve(to: CGPoint(x: 343.9, y: 82.3), controlPoint1: CGPoint(x: 316.7, y: 78), controlPoint2: CGPoint(x: 329.9, y: 80.9))
        path.addCurve(to: CGPoint(x: 417.3, y: 77.4), controlPoint1: CGPoint(x: 377.3, y: 85.8), controlPoint2: CGPoint(x: 394.3, y: 78.9))
        path.addCurve(to: CGPoint(x: 579.1, y: 154.6), controlPoint1: CGPoint(x: 461.2, y: 74.5), controlPoint2: CGPoint(x: 530.8, y: 63.4))
        path.addCurve(to: CGPoint(x: 595.8, y: 333), controlPoint1: CGPoint(x: 599.8, y: 193.7), controlPoint2: CGPoint(x: 577.7, y: 272.6))
        path.addCurve(to: CGPoint(x: 584.7, y: 320.6), controlPoint1: CGPoint(x: 596.6, y: 335.6), controlPoint2: CGPoint(x: 586.7, y: 327.3))
        path.addCurve(to: CGPoint(x: 576, y: 309.3), controlPoint1: CGPoint(x: 583.1, y: 314.8), controlPoint2: CGPoint(x: 578.9, y: 308.8))
        path.addCurve(to: CGPoint(x: 571.8, y: 317.1), controlPoint1: CGPoint(x: 573.5, y: 309.7), controlPoint2: CGPoint(x: 572.3, y: 314.9))
        path.addCurve(to: CGPoint(x: 563.1, y: 376.5), controlPoint1: CGPoint(x: 562.6, y: 360.3), controlPoint2: CGPoint(x: 563.1, y: 376.5))
        path.addCurve(to: CGPoint(x: 556.3, y: 426.6), controlPoint1: CGPoint(x: 564.5, y: 434.1), controlPoint2: CGPoint(x: 577.8, y: 428.1))
        path.addCurve(to: CGPoint(x: 484.7, y: 425.5), controlPoint1: CGPoint(x: 545.4, y: 425.9), controlPoint2: CGPoint(x: 502.1, y: 426.7))
        path.addCurve(to: CGPoint(x: 479.8, y: 372.7), controlPoint1: CGPoint(x: 467.2, y: 424.3), controlPoint2: CGPoint(x: 479.8, y: 399.5))
        path.addCurve(to: CGPoint(x: 390.4, y: 342.3), controlPoint1: CGPoint(x: 479.8, y: 349.3), controlPoint2: CGPoint(x: 436, y: 342.6))
        path.addCurve(to: CGPoint(x: 310.9, y: 374.5), controlPoint1: CGPoint(x: 343.9, y: 342), controlPoint2: CGPoint(x: 311.8, y: 362.7))
        path.addCurve(to: CGPoint(x: 299.3, y: 426.6), controlPoint1: CGPoint(x: 308.5, y: 403.8), controlPoint2: CGPoint(x: 311.4, y: 427.5))
        path.addCurve(to: CGPoint(x: 218, y: 427.6), controlPoint1: CGPoint(x: 282.3, y: 425.5), controlPoint2: CGPoint(x: 248.4, y: 429.7))
        path.addCurve(to: CGPoint(x: 234.4, y: 360.2), controlPoint1: CGPoint(x: 203.2, y: 426.6), controlPoint2: CGPoint(x: 233, y: 380.1))
        path.addCurve(to: CGPoint(x: 216.3, y: 233.3), controlPoint1: CGPoint(x: 238.4, y: 301.8), controlPoint2: CGPoint(x: 213.4, y: 275.8))
        path.addCurve(to: CGPoint(x: 85.5, y: 281.7), controlPoint1: CGPoint(x: 217.7, y: 214), controlPoint2: CGPoint(x: 200.9, y: 294.9))
        path.addCurve(to: CGPoint(x: 16.5, y: 153.2), controlPoint1: CGPoint(x: 14.8, y: 273.5), controlPoint2: CGPoint(x: -13.9, y: 186.4))
        path.addCurve(to: CGPoint(x: 37.3, y: 133.9), controlPoint1: CGPoint(x: 24.6, y: 144.4), controlPoint2: CGPoint(x: 31.6, y: 142.1))
        path.addCurve(to: CGPoint(x: 43.8, y: 143.3), controlPoint1: CGPoint(x: 41.8, y: 127.4), controlPoint2: CGPoint(x: 42.7, y: 142.4))
        path.addCurve(to: CGPoint(x: 52.7, y: 153.2), controlPoint1: CGPoint(x: 47, y: 146.1), controlPoint2: CGPoint(x: 60.3, y: 145.3))
        path.addCurve(to: CGPoint(x: 77.7, y: 221.4), controlPoint1: CGPoint(x: 24.1, y: 182.6), controlPoint2: CGPoint(x: 25.5, y: 218.5))
        path.close()
        elephant.path = path.cgPath
        elephant.fillColor = UIColor.red.cgColor
        elephant.lineWidth = 2.0
        elephant.strokeColor = UIColor.black.cgColor
        elephant.transform = CATransform3DMakeScale(0.125, 0.125, 1)
        return elephant
    }
    
}
