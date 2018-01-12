//
//  UserBottomView.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class UserBottomView: UIView {

    var tableView: UITableView!
    let userCellIdentifier = "userCellIdentifier"
    var settingBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 头像
        let header = UIButton(type: UIButtonType.custom)
        header.setImage(#imageLiteral(resourceName: "UserInfo_defaultIcon"), for: UIControlState.normal)
        header.backgroundColor = UIColor.clear
        header.addTarget(self, action: #selector(headerDidClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(-30)
            make.left.equalTo(50)
            make.width.height.equalTo(80)
        }
        
        // 主体
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(0)
        }
        tableView.tableHeaderView = setupheaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setupheaderView() -> (UIView) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth-100, height: 100))
        let nameLabel = UILabel()
        nameLabel.text = "Carson"
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        headerView.addSubview(nameLabel)
        let attestBtn = UIButton(type: UIButtonType.custom)
        attestBtn.setBackgroundImage(#imageLiteral(resourceName: "credit_label_bd"), for: UIControlState.normal)
        attestBtn.setTitle("完成认证 >", for: UIControlState.normal)
        attestBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        attestBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        attestBtn.addTarget(self, action: #selector(attestBtnDidClicked), for: UIControlEvents.touchUpInside)
        headerView.addSubview(attestBtn)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.width.equalTo(200)
        }
        attestBtn.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        return headerView
    }
    
    // 点击头像
    @objc func headerDidClicked() {
        self.settingBlock!()
    }
    
    // 点击认证
    @objc func attestBtnDidClicked() {
        
    }
}
