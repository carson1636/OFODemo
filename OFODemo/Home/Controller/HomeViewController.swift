//
//  HomeViewController.swift
//  OFODemo
//
//  Created by zhu on 2018/1/10.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ConnectPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ConnectDismiss()
    }
}

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        self.setupNavigation()
        self.setupBottomView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 导航
    /// 右按钮
    var rightView: UIView {
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        tempView.addSubview(rightBtn)
        tempView.backgroundColor = UIColor.clear
        return tempView
    }
    var rightBtn: UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 40, y: 12, width: 20, height: 20)
        btn.setImage(UIImage.init(named: "bluebar_fold"), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "bluebar_unfold"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(rightBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    
    var leftImageView: UIImageView!
    
    func setupNavigation() {
        // 设置半透明导航
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let image = self.imageWithColor(color: color)
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        leftImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 120*0.8, height: 26*0.8))
        leftImageView.image = UIImage(named: "yellowBikeLogo")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 10, width: 120, height: 26))
        leftView.backgroundColor = UIColor.clear
        leftView.addSubview(leftImageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    /// 右按钮响应
    @objc func rightBtnDidClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            var frame = sender.frame
            let center = sender.center
            frame.size = CGSize.init(width: 43, height: 43)
            sender.frame = frame
            sender.center = center
            
            UIView.animate(withDuration: 0.3) {
                self.leftImageView.frame = CGRect(x: 0, y: 0, width: 120, height: 26)
            }
        }
        else {
            var frame = sender.frame
            let center = sender.center
            frame.size = CGSize.init(width: 20, height: 20)
            sender.frame = frame
            sender.center = center
            
            UIView.animate(withDuration: 0.3) {
                self.leftImageView.frame = CGRect(x: 0, y: 0, width: 120*0.8, height: 26*0.8)
            }
        }
    }
    
    /// 通过颜色生成图片
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - 底部
    var bottom: BottomView! // 底部视图
    var arrowBtn: UIButton! // 箭头
    var scanBtn: UIButton! // 扫描用车
    
    func setupBottomView() {
        bottom = BottomView.init(frame: CGRect.init(x: 0, y: kScreenHeight-260, width: kScreenWidth, height: 260))
        bottom.backgroundColor = UIColor.clear // 背景透明
        view.addSubview(bottom)
        
        // 滑动手势
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDidHandle(swipe:)))
        downSwipe.direction = .down
        bottom.addGestureRecognizer(downSwipe)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDidHandle(swipe:)))
        upSwipe.direction = .up
        bottom.addGestureRecognizer(upSwipe)
        
        // 箭头
        arrowBtn = UIButton(type: UIButtonType.custom)
        arrowBtn.frame = CGRect(x: bottom.center.x-10, y: 20, width: 20, height: 20)
        arrowBtn.setImage(UIImage(named: "arrowdown"), for: UIControlState.normal)
        arrowBtn.setImage(UIImage(named: "arrowup"), for: UIControlState.selected)
        arrowBtn.addTarget(self, action: #selector(arrowBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(arrowBtn)
        
        // 刷新
        let refreshBtn = UIButton(type: UIButtonType.custom)
        refreshBtn.frame = CGRect(x: kScreenWidth-50, y: -40, width: 40, height: 40)
        refreshBtn.backgroundColor = UIColor.white
        refreshBtn.layer.cornerRadius = 20
        refreshBtn.setImage(UIImage(named: "leftBottomRefreshImage"), for: UIControlState.normal)
        refreshBtn.addTarget(self, action: #selector(refreshBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(refreshBtn)
        
        // 客服
        let serviceBtn = UIButton(type: UIButtonType.custom)
        serviceBtn.frame = CGRect(x: kScreenWidth-50, y: -100, width: 40, height: 40)
        serviceBtn.setImage(UIImage(named: "rightBottomImage"), for: UIControlState.normal)
        serviceBtn.addTarget(self, action: #selector(servicerBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(serviceBtn)
        
        // 扫描
        scanBtn = UIButton(type: UIButtonType.custom)
        scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 50, width: 150, height: 150)
        scanBtn.setImage(UIImage(named: "start_button_bg_scan"), for: UIControlState.normal)
        scanBtn.addTarget(self, action: #selector(scanBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(scanBtn)
        // 个人中心
        let userBtn = UIButton(type: UIButtonType.custom)
        userBtn.frame = CGRect(x: 15, y: bottom.bounds.size.height-55, width: 40, height: 40)
        userBtn.setImage(UIImage(named: "user_center_icon"), for: UIControlState.normal)
        userBtn.addTarget(self, action: #selector(userBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(userBtn)
        
        // 消息
        let messageBtn = UIButton(type: UIButtonType.custom)
        messageBtn.frame = CGRect(x: kScreenWidth-15-40, y: bottom.bounds.size.height-55, width: 40, height: 40)
        messageBtn.setImage(UIImage(named: "gift_icon"), for: UIControlState.normal)
        messageBtn.addTarget(self, action: #selector(messageBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(messageBtn)
    }

    @objc func swipeDidHandle(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .down {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottom.frame = CGRect(x: 0, y: kScreenHeight-70, width: kScreenWidth, height: 190)
                self.scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 100, width: 150, height: 150)
                self.arrowBtn.isSelected = !self.arrowBtn.isSelected
            })
        }
        if swipe.direction == .up {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottom.frame = CGRect(x: 0, y: kScreenHeight-260, width: kScreenWidth, height: 260)
                self.scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 50, width: 150, height: 150)
                self.arrowBtn.isSelected = !self.arrowBtn.isSelected
            })
        }
    }
    
    @objc func arrowBtnDidClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            UIView.animate(withDuration: 0.5, animations: {
                self.bottom.frame = CGRect(x: 0, y: kScreenHeight-70, width: kScreenWidth, height: 190)
                self.scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 100, width: 150, height: 150)
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.bottom.frame = CGRect(x: 0, y: kScreenHeight-260, width: kScreenWidth, height: 260)
                self.scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 50, width: 150, height: 150)
            })
        }
    }

    @objc func refreshBtnDidClicked(sender: UIButton) {
        
    }
    
    @objc func servicerBtnDidClicked(sender: UIButton) {
        
    }
    
    @objc func scanBtnDidClicked(sender: UIButton) {
        
    }
    
    @objc func userBtnDidClicked(sender: UIButton) {
        let userVC = UserViewController.shareUser
        let userNav = UINavigationController(rootViewController: userVC)
        userNav.transitioningDelegate = self
        self.present(userNav, animated: true, completion: nil)
    }
    
    @objc func messageBtnDidClicked(sender: UIButton) {
        
    }
}
