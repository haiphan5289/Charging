//
//  BaseNavigationViewController.swift
//  Audio
//
//  Created by paxcreation on 3/30/21.
//

import UIKit
import RxSwift
import RxCocoa

class BaseNavigationViewController: UIViewController {
    
    let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let btExport = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let btSetting = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    
    var titleLarge: String = ""
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                    NSAttributedString.Key.font: UIFont(name: "GoogleSans-Bold", size: 17.0) ?? UIImage() ]
        setupNavigation()
    }
    
    private func setupNavigation() {
        buttonLeft.setImage(UIImage(named: "icArrowLeft"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        btExport.setImage(UIImage(named: "icExport"), for: .normal)
        btExport.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        let rightBarButton = UIBarButtonItem(customView: btExport)
        
        btSetting.setImage(UIImage(named: "icSetting"), for: .normal)
        btSetting.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        let rightBarButtonSetting = UIBarButtonItem(customView: btSetting)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItems = [rightBarButton, rightBarButtonSetting]
        
        title = titleLarge
    }
    
    private func setupRX() {
        self.buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposebag)
    }
    
}
