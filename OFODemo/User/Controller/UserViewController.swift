//
//  UserViewController.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let shareUser = UserViewController()
    var topView: UserTopView!
    var bottomView: UserBottomView!
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissAction))
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
    
    func setupUI() {
        // 顶部
        topView = UserTopView.init(frame: CGRect(x: 0, y: -170, width: kScreenWidth, height: 170))
        topView.backgroundColor = UIColor.clear
        view.addSubview(topView)
        topView.backBlock = { [weak self]() in
            self?.dismissAction()
        }
        
        // 尾部
        bottomView = UserBottomView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight-125))
        bottomView.backgroundColor = UIColor.clear
        view.addSubview(bottomView)
        bottomView.tableView.delegate = self
        bottomView.tableView.dataSource = self
        bottomView.settingBlock = { [weak self]() in
            let setUserVC = SetUserViewController()
            self?.navigationController?.pushViewController(setUserVC, animated: true)
        }
    }
    
    // 返回主界面
    @objc func dismissAction() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bottomView.userCellIdentifier)
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "我的行程"
            cell?.imageView?.image = #imageLiteral(resourceName: "icon_slide_trip2")
        case 1:
            cell?.textLabel?.text = "我的钱包"
            cell?.imageView?.image = #imageLiteral(resourceName: "icon_slide_wallet2")
        case 2:
            cell?.textLabel?.text = "邀请好友"
            cell?.imageView?.image = #imageLiteral(resourceName: "icon_slide_invite2")
        case 3:
            cell?.textLabel?.text = "我的客服"
            cell?.imageView?.image = #imageLiteral(resourceName: "icon_slide_usage_guild2")
        default:
            break
        }
    
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
