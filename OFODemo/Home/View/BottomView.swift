//
//  BottomView.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class BottomView: UIView {

    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: 0, y: 45))
        path.addLine(to: CGPoint.init(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint.init(x: rect.size.width, y: rect.size.height))
        path.addLine(to: CGPoint.init(x: rect.size.width, y: 45))
        path.addQuadCurve(to: CGPoint.init(x: 0, y: 45), controlPoint: CGPoint.init(x: rect.size.width/2, y: -45))
        
        path.close()
        
        context?.addPath(path.cgPath)
        UIColor.white.setFill()
        context?.fillPath()
        
    }

}
