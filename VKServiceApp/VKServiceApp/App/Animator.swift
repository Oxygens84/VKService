//
//  Animator.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 16/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
            else { return }

        let containerViewFrame = transitionContext.containerView.frame
        let sourceViewTargetFrame = source.view.frame
            CGRect(x: 0,
                                           y: 0,
                                           width: source.view.frame.width,
                                           height: source.view.frame.height)

        let rotation = CATransform3DMakeRotation(0, 0, 1, 0)
        let scale = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        let transform = CATransform3DConcat(rotation, scale)
        destination.view.transform = CATransform3DGetAffineTransform(transform)

        let destinationViewTargetFrame = source.view.frame

        transitionContext.containerView.addSubview(destination.view)

        destination.view.frame = CGRect(x: source.view.frame.width,
                                        y: 0,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)


        UIView
            .animate(withDuration: self.transitionDuration(using: transitionContext),
                     animations: {
                        source.view.frame = sourceViewTargetFrame
                        destination.view.frame = destinationViewTargetFrame
                        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: source.view, cache: false)
                        
            }) { finished in
                UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: destination.view, cache: false)
                transitionContext.completeTransition(finished)
        }
        
    }
    
}
