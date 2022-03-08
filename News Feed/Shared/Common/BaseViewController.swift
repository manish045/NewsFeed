//
//  BaseViewController.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView?
    var navigationTitleView: NavigationTitleView?
    var rightBarButton: UIBarButtonItem!
    
    var tabBarView: UIView?
    var footerHeight: CGFloat = 50
    
    var showActivityIndicator: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.performActivityIndicator()
            }
        }
    }
    
    override func viewDidLoad() {
        addBackground()
        super.viewDidLoad()
    }
   
    private func addBackground() {
        self.view.backgroundColor = UIColor.white
        activityIndicator?.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = nil
        navigationBar.prefersLargeTitles = false
    }
    
    func configureNavigationItems() {
        guard navigationTitleView == nil else {
            return
        }
        let navigationTitleView = makeNavigationTitleView()
        self.navigationTitleView = navigationTitleView
        navigationItem.titleView = navigationTitleView
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    func makeNavigationTitleView() -> NavigationTitleView {
        let view = NavigationTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setTitleToBar(text: String, rightBarButtonNeeded: Bool = false, rightButtonTitle: String? = nil) {
        configureNavigationItems()
        configureNavigationBar()
        navigationTitleView?.setText(text)
        if rightBarButtonNeeded {
            rightBarButton = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(rightBarButtonAction))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationController?.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    @objc func rightBarButtonAction() {}
    
    func performActivityIndicator() {
       if showActivityIndicator {
           activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator?.center = view.center
           activityIndicator?.isHidden = false
           view.addSubview(activityIndicator!)
           activityIndicator?.startAnimating()
       } else {
           activityIndicator?.isHidden = true
           activityIndicator?.stopAnimating()
           activityIndicator?.removeFromSuperview()
           activityIndicator = nil
       }
   }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message as String, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeTabBar(hidden:Bool, animated: Bool = true) {
        guard let tabBarView = tabBarView else {return}
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0

        let offset = (hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (self.footerHeight + (bottomPadding + 16)))
        if offset == tabBarView.frame.origin.y {return}
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        UIView.animate(withDuration: duration,
                       animations: {tabBarView.frame.origin.y = offset},
                       completion:nil)
    }
}
