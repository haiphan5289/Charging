//
//  Setting.swift
//  Charging
//
//  Created by haiphan on 23/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class Setting: UIViewController {
    
    struct Constant {
        static let heightHeaderView: CGFloat = 160
    }
    
    enum StatusCell: Int, CaseIterable {
        case animation, share, contact, term, privacy
        
        var text: String {
            switch self {
            case .animation:
                return "How to use Animation"
            case .share:
                return "Share app"
            case .contact:
                return "Contact Us"
            case .term:
                return "Term of Service"
            case .privacy:
                return "Privacy Policy"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .animation:
                return Asset.icUseAnimation.image
            case .share:
                return Asset.icSettingShare.image
            case .contact:
                return Asset.icSettingContact.image
            case .term:
                return Asset.icSettingTerm.image
            case .privacy:
                return Asset.icSettingPrivacy.image
            }
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var vHeaderSetting: HeaderSetting? = HeaderSetting.loadXib()
    
    @VariableReplay private var datatSource: [StatusCell] = StatusCell.allCases
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension Setting {
    
    private func setupUI() {
        tableView.delegate = self
        tableView.register(SettingCell.nib, forCellReuseIdentifier: SettingCell.identifier)
    }
    
    private func setupRX() {
        self.$datatSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SettingCell.identifier, cellType: SettingCell.self)) {(row, element, cell) in
                cell.lbTitle.text = element.text
                cell.imgSetting.image = element.image
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (index, wSelf) in
            let type = wSelf.datatSource[index.row]
            
            switch type {
            case .animation:
                let vc = HowToUserAnimation.createVC()
                wSelf.navigationController?.pushViewController(vc, animated: true)
            case .contact:
                guard let url = URL(string: LINK_SUPPORT) else { return }
                UIApplication.shared.open(url)
            case .privacy:
                guard let url = URL(string: LINK_PRICAVY) else { return }
                UIApplication.shared.open(url)
            case .term:
                guard let url = URL(string: LINK_TERM) else { return }
                UIApplication.shared.open(url)
            case .share:
                let objectsToShare: [String] = ["Charging Animation"]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact,
                                                    .mail, .message, .postToFacebook, .postToWhatsApp]
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
        //            if !completed {
        //                return
        //            }
//                    activityVC.dismiss(animated: true) {
//                        self.dismiss(animated: true, completion: nil)
//                    }
                }
                self.present(activityVC, animated: true, completion: nil)
            }
            
        })).disposed(by: disposeBag)
    }
    
}
extension Setting: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = .clear
        
        if self.vHeaderSetting == nil {
            self.vHeaderSetting = HeaderSetting.loadXib()
        }
        
        if let h = self.vHeaderSetting {
            v.addSubview(h)
            h.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            h.actionPrenium = {
                if !Configuration.inPremiumUser() {
                    let vc = InAppVC.createVC()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightHeaderView
    }
    
}
