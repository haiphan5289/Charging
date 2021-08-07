//
//  PremiumViewController.swift
//  Drama_iOS
//
//  Created by Nguyễn Hải Âu on 3/29/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit
import SwiftyStoreKit

enum ProductID: String, CaseIterable {
    case weekly = "One_Week1"
    case monthly = "One_Month1"
    case yearly = "One_Year1"
    case dayfree = "3Day_Trial"

    var text: String {
        switch self {
        case .weekly:
            return "Week"
        case .monthly:
            return "Month"
        case .yearly:
            return "Year"
        default:
            return "Trial"
        }
    }
    
    var valuePrenium: FullAccessView.Prenium {
        switch self {
        case .weekly: return FullAccessView.Prenium.week
        case .monthly: return FullAccessView.Prenium.month
        case .yearly: return FullAccessView.Prenium.year
        default: return FullAccessView.Prenium.year
        }
    }
    
}

enum ProductIDAutoRenew: String {
    case weekly = "One_Week"
    case monthly = "One_Month"
    case yearly = "One_Year"
    case dayfree = "3Day_Trial"

}

protocol PremiumDelegate {
    func didFinishJoinPremium()
}

class PremiumViewController: UIViewController {
    
    // MARK:- UI
    let premiumView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        return v
    }()
    
    let backgroundImageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .orange
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let scrollView : UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        s.contentSize.height = 672 // 780
        s.bounces = false
        return s
    }()
    
    let joinPremiumLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 26)
        l.textColor = .white
        l.text = "Join Premium Plan"
        return l
    }()
    
    lazy var dismissButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "iconsCircleIcCircleClose"), for: .normal)
        b.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return b
    }()
    
    let latestMoviesLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Latest movies news updates"
        l.font = .systemFont(ofSize: 15)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()
    
    let updateTrendingLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Update trending movies show"
        l.font = .systemFont(ofSize: 15)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()
    
    let searchLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Search for recent theaters"
        l.font = .systemFont(ofSize: 15)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PremiumCVCell.self, forCellWithReuseIdentifier: PremiumCVCell.identifier)
        return cv
    }()
    
    let trialLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "3 days free trial"
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()
    
    let desLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Payment will be charged to iTunes Account at confirmation of purchase. Subscriptions automatically renew unless auto-renew is turned off at least 24-hours before the end of the current subscription period. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user’s Account Setting after purchase."
        l.font = .systemFont(ofSize: 11, weight: .regular)
        l.textColor = UIColor(white: 1, alpha: 1)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var restorePurchaseButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restore Purchase", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        b.addTarget(self, action: #selector(self.restoreInApp), for: .touchUpInside)
        return b
    }()
    
    let termOfUseButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Term of Use", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return b
    }()
    
    let privacyPolicyButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Privacy Policy", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return b
    }()
    
    lazy var continuteButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Continue", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        b.backgroundColor = UIColor(white: 0, alpha: 0.3)
        b.layer.cornerRadius = 8
        b.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        return b
    }()
    
    // MARK:- VARS
    var delegate: PremiumDelegate?
    
    // MARK:- VIEW LIFTCYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    // MARK:- SETUP UI
    func setupUI() {
        view.addSubview(premiumView)
        premiumView.addSubview(backgroundImageView)
        premiumView.addSubview(scrollView)

        scrollView.addSubview(joinPremiumLabel)
        scrollView.addSubview(dismissButton)
        scrollView.addSubview(latestMoviesLabel)
        scrollView.addSubview(updateTrendingLabel)
        scrollView.addSubview(searchLabel)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(trialLabel)
        scrollView.addSubview(desLabel)
        scrollView.addSubview(restorePurchaseButton)
        scrollView.addSubview(termOfUseButton)
        scrollView.addSubview(privacyPolicyButton)
        scrollView.addSubview(continuteButton)

        let constraints = [
            premiumView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            premiumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            premiumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            premiumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            
            backgroundImageView.topAnchor.constraint(equalTo: premiumView.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: premiumView.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: premiumView.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: premiumView.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: premiumView.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: premiumView.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: premiumView.bottomAnchor, constant: -16),
            
            joinPremiumLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            joinPremiumLabel.leadingAnchor.constraint(equalTo: premiumView.leadingAnchor, constant: 24),
            joinPremiumLabel.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -52),
            
            dismissButton.centerYAnchor.constraint(equalTo: joinPremiumLabel.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -24),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            
            latestMoviesLabel.topAnchor.constraint(equalTo: joinPremiumLabel.bottomAnchor, constant: 32),
            latestMoviesLabel.leadingAnchor.constraint(equalTo: joinPremiumLabel.leadingAnchor),
            latestMoviesLabel.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -24),
            
            updateTrendingLabel.topAnchor.constraint(equalTo: latestMoviesLabel.bottomAnchor, constant: 12),
            updateTrendingLabel.leadingAnchor.constraint(equalTo: joinPremiumLabel.leadingAnchor),
            updateTrendingLabel.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -24),
            
            searchLabel.topAnchor.constraint(equalTo: updateTrendingLabel.bottomAnchor, constant: 12),
            searchLabel.leadingAnchor.constraint(equalTo: joinPremiumLabel.leadingAnchor),
            searchLabel.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -24),

            collectionView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: searchLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: searchLabel.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.1 / 4),

            trialLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            trialLabel.leadingAnchor.constraint(equalTo: searchLabel.leadingAnchor),
            trialLabel.trailingAnchor.constraint(equalTo: searchLabel.trailingAnchor),

            desLabel.topAnchor.constraint(equalTo: trialLabel.bottomAnchor, constant: 20),
            desLabel.leadingAnchor.constraint(equalTo: trialLabel.leadingAnchor),
            desLabel.trailingAnchor.constraint(equalTo: trialLabel.trailingAnchor),

            restorePurchaseButton.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 32),
            restorePurchaseButton.leadingAnchor.constraint(equalTo: desLabel.leadingAnchor),
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: 20),
            
            termOfUseButton.topAnchor.constraint(equalTo: restorePurchaseButton.bottomAnchor, constant: 16),
            termOfUseButton.leadingAnchor.constraint(equalTo: desLabel.leadingAnchor),
            termOfUseButton.heightAnchor.constraint(equalToConstant: 20),
            
            privacyPolicyButton.topAnchor.constraint(equalTo: termOfUseButton.bottomAnchor, constant: 16),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: desLabel.leadingAnchor),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 20),
            
            continuteButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 16),
            continuteButton.leadingAnchor.constraint(equalTo: trialLabel.leadingAnchor),
            continuteButton.trailingAnchor.constraint(equalTo: trialLabel.trailingAnchor),
            continuteButton.heightAnchor.constraint(equalToConstant: 50),

        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK:- FUNCS
    
    var inAppAutoRenew = false
    
    func weeklySubscription() {
        if inAppAutoRenew == true {
            self.subscriptionAction(productId: ProductIDAutoRenew.weekly.rawValue)
        } else {
            self.subscriptionAction(productId: ProductID.weekly.rawValue)
        }
    }
    
    func monthlySubscription() {
        if inAppAutoRenew == true {
            self.subscriptionAction(productId: ProductIDAutoRenew.monthly.rawValue)
        } else {
            self.subscriptionAction(productId: ProductID.monthly.rawValue)
        }
    }
    
    func yearlySubscription() {
        
        if inAppAutoRenew == true {
            self.subscriptionAction(productId: ProductIDAutoRenew.yearly.rawValue)
        } else {
            self.subscriptionAction(productId: ProductID.yearly.rawValue)
        }
    }
    
    func subscriptionAction(productId: String) {
        //self.showLoading()
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { [weak self] (result) in
            guard let `self` = self else { return }
            //self.hideLoading()
            switch result {
            case .success(_):
                Configuration.joinPremiumUser(join: true)
                if self.inAppAutoRenew {
                    Configuration.joinDiamondUser(join: true)
                }
                self.showAlert(title: "Successful", message: "Successful") { [weak self] in
                    self?.dismiss(animated: true, completion: { [weak self] in
                        //self?.delegate?.didFinishJoinPremium()
                        SHARE_APPLICATION_DELEGATE.setupFlowApp()
                    })
                }
            case .error(_):
                self.showAlert(title: "Cannot subcribe", message: "Cannot subcribe")
                break
            }
        }
        
    }
    
    // MARK:- BUTTON ACTIONS
    @objc private func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var purchaseOptionIndex = 0
    
    @objc func continueButtonDidTap() {
        if purchaseOptionIndex != 0 {
            // Make an payment
            switch purchaseOptionIndex {
            case 1:
                self.weeklySubscription()
            case 2:
                self.monthlySubscription()
            case 3:
                self.yearlySubscription()
            default:
                self.weeklySubscription()
            }

        } else {
            showAlert(title: "Alert", message: "Please choose an option!")
        }
    }
    
    @objc func restoreInApp() {
        if (SHARE_APPLICATION_DELEGATE.inappManager.canMakePurchase()) {
            SHARE_APPLICATION_DELEGATE.inappManager.restoreCompletedTransactions()
        }
    }
    
    private func switchPlan(index: Int) {
        if inAppAutoRenew == false {
            return
        }
        
        let prices = [
            [
                "Weekly",
                 "0.99$" //self.lblWeekPrice.text
            ],
            [
                "Monthly",
                "1.99$" //self.lblMonthPrice.text
            ],
            [
                "Yearly",
                "14.99$" //self.lblYearPrice.text
            ]
        ]
        print([prices[index][0], prices[index][1]])
        DispatchQueue.main.async {
            
            print("%@ subscription is %@ and will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. Eligible for new users only.", prices[index][0], prices[index][1])
            
//            self.subscriptionShortTerm.text = String(format: "%@ subscription is %@ and will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. Eligible for new users only.", prices[index][0], prices[index][1])
        }
    }
    
    // Choose purchase option
    func didTapPurchaseWeekly() {
        if purchaseOptionIndex == 1 {
            purchaseOptionIndex = 0
        } else {
            DispatchQueue.main.async {
                self.purchaseOptionIndex = 1
                self.switchPlan(index: 0)
            }
        }
    }
    
    func didTapPurchaseMonthly() {
        if purchaseOptionIndex == 2 {
            purchaseOptionIndex = 0
        } else {
            self.purchaseOptionIndex = 2
            self.switchPlan(index: 1)
        }
    }
    
    func didTapPurchaseYearly() {
        if purchaseOptionIndex == 3 {
            purchaseOptionIndex = 0
        } else {
            self.purchaseOptionIndex = 3
            self.switchPlan(index: 2)
        }
    }
    
    
}

extension PremiumViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremiumCVCell.identifier, for: indexPath) as! PremiumCVCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "One Week"
            cell.priceLabel.text = "0.99$"
            break
        case 1:
            cell.titleLabel.text = "One Month"
            cell.priceLabel.text = "1.99$"
            break
        case 2:
            cell.titleLabel.text = "One Year"
            cell.priceLabel.text = "14.99$"
            break
        default:
            break
        }
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 8, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            didTapPurchaseWeekly()
            break
        case 1:
            didTapPurchaseMonthly()
            break
        case 2:
            didTapPurchaseYearly()
            break
        default:
            break
        }
    }
    
}
