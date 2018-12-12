//
//  AnimUtils.swift
//  LazyHUE
//
//  Created by 양창엽 on 13/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit

class AnimUtils: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollingAnim(tabBarController: tabBarController)
    }
}

class ScrollingAnim: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal weak var transitionContext: UIViewControllerContextTransitioning?
    internal var tabBarController: UITabBarController!
    internal var fromIndex: Int = 0
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.fromIndex = tabBarController.selectedIndex
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // MARK: Create View here
        self.transitionContext = transitionContext
        let containerView: UIView = transitionContext.containerView
        
        guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        containerView.addSubview(toView.view)
        
        var width: CGFloat = toView.view.bounds.width

        // MARK: Current Tap Index Inverse (2 Tap -> 1 Tap 할 경우 값 역전)
        if tabBarController.selectedIndex < fromIndex {
            width = -width
        }
        
        toView.view.transform = CGAffineTransform(translationX: width, y: 0)
        
        // MARK: UIView Animated here.
        UIView.animate(withDuration: self.transitionDuration(using: self.transitionContext), animations: {
        
            toView.view.transform = CGAffineTransform.identity
            fromView.view.transform = CGAffineTransform(translationX: -width, y: 0)
        }, completion: { _ in
            
            fromView.view.transform = CGAffineTransform.identity
            // MARK: Animation 사용 중 Tap 입력 금지.
            if let isBlock: Bool = self.transitionContext?.transitionWasCancelled {
                self.transitionContext?.completeTransition(!isBlock)
            }
        })
    }
}
