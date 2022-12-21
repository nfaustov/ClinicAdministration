//
//  VisitsPresentationController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import UIKit

final class VisitsPresentationController: UIPresentationController {
    private enum State {
        case thirdScreen
        case fullScreen
    }

    private let blurEffectView: UIVisualEffectView!

    private var state: State = .thirdScreen

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeState))
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        switch state {
        case .thirdScreen: return CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.height * 2 / 3),
            size: CGSize(width: containerView.frame.width, height: containerView.frame.height / 3)
        )
        case .fullScreen: return CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.height * 0.9),
            size: CGSize(width: containerView.frame.width, height: containerView.frame.height * 0.9)
        )
        }
    }

    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            switch self.state {
            case .thirdScreen: self.blurEffectView.alpha = 0
            case .fullScreen: self.blurEffectView.alpha = 0.7
            }
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? .zero
    }

    @objc private func changeState(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up: state = .fullScreen
        case .down: state = .thirdScreen
        default: break
        }
    }
}
