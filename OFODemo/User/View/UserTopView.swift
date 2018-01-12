//
//  UserTopView.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class UserTopView: UIView {

    var backBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 返回按钮
        let dismissBtn = UIButton(type: UIButtonType.custom)
        dismissBtn.frame = CGRect(x: kScreenWidth-40, y: 25, width: 25, height: 25)
        dismissBtn.setImage(UIImage(named: "closeFork"), for: UIControlState.normal)
        dismissBtn.addTarget(self, action: #selector(dismissBtnDidClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(dismissBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    @objc func dismissBtnDidClicked() {
        self.backBlock?()
    }
    
}
