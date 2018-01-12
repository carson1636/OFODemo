//
//  BaseViewController.swift
//  OFODemo
//
//  Created by zhu on 2018/1/12.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = UIColor.white
        
        guard navigationController != nil else {
            return
        }
        
        if navigationController!.viewControllers.count > 1 {
            let backBtn = UIButton(type: UIButtonType.custom)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            backBtn.setImage(#imageLiteral(resourceName: "backIndicator"), for: UIControlState.normal)
            backBtn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
