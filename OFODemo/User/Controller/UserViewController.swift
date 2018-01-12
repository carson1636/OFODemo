//
//  UserViewController.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    static let shareUser = UserViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissBtnDidClicked))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var topView: UserTopView!
    var bottomView: UserBottomView!
    
    func setupUI() {
        // 顶部
        topView = UserTopView.init(frame: CGRect(x: 0, y: -170, width: kScreenWidth, height: 170))
        topView.backgroundColor = UIColor.clear
        view.addSubview(topView)
        
        // 返回按钮
        let dismissBtn = UIButton(type: UIButtonType.custom)
        dismissBtn.frame = CGRect(x: kScreenWidth-40, y: 25, width: 25, height: 25)
        dismissBtn.setImage(UIImage(named: "closeFork"), for: UIControlState.normal)
        dismissBtn.addTarget(self, action: #selector(dismissBtnDidClicked), for: UIControlEvents.touchUpInside)
        topView.addSubview(dismissBtn)
        
        // 尾部
        bottomView = UserBottomView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight-125))
        bottomView.backgroundColor = UIColor.clear
        view.addSubview(bottomView)
    }
    
    
    
    @objc func dismissBtnDidClicked() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    

}
