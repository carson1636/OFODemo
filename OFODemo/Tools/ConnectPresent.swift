//
//  ConnectPresent.swift
//  OFODemo
//
//  Created by zhu on 2018/1/11.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

/// present 动画
class ConnectPresent: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
         1.viewForKey() :          UITransitionContextFromViewKey
                                   UITransitionContextToViewKey
         2.viewControllerForKey(): UITransitionContextFromViewControllerKey
                                   UITransitionContextToViewControllerKey
        */
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        containerView.addSubview(toView!)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            let userVC = UserViewController.shareUser
            userVC.topView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 170)
            userVC.bottomView.frame = CGRect(x: 0, y: 125, width: kScreenWidth, height: kScreenHeight-125)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}

class ConnectDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        containerView.addSubview(toView!)
        containerView.addSubview(fromView!)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            let userVC = UserViewController.shareUser
            userVC.topView.frame = CGRect(x: 0, y: -170, width: kScreenWidth, height: 170)
            userVC.bottomView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight-125)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    
}
