//
//  CustomPresentationController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        return CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.height * 2 / 3),
            size: CGSize(width: containerView.frame.width, height: containerView.frame.height / 3)
        )
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }

    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.4
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? .zero
    }

    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
