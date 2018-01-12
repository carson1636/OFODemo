//
//  UserTopView.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class UserTopView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint.init(x: rect.size.width, y: rect.size.height))
        path.addQuadCurve(to: CGPoint.init(x: 0, y: rect.size.height), controlPoint: CGPoint.init(x: rect.size.width/2, y: rect.size.height-45))
        
        
        
        path.close()
        
        context?.addPath(path.cgPath)
        UIColor(red: 1, green: 223/255.0, blue: 50/255.0, alpha: 1).setFill()
        context?.fillPath()
    }

}
