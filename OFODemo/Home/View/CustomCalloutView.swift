//
//  CustomCalloutView.swift
//  OFODemo
//
//  Created by zhu on 2018/1/14.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {

    var timeLabel: UILabel!
    var distanceLable: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(frame: frame)
        imageView.image = #imageLiteral(resourceName: "endAnnotationcallout")
        self.addSubview(imageView)
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2))
        self.addSubview(timeLabel)
        
        let distanceLable = UILabel(frame: CGRect(x: 0, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2))
        self.addSubview(distanceLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
