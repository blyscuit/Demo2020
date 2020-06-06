//
//  ListViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    let viewModel = ListViewModel()
    
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var colorTopView: UIView!
    @IBOutlet weak var colorTopConstraint: NSLayoutConstraint!

    var refreshControl: UIRefreshControl!

    static let id = "ListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreView.layer.cornerRadius = 20

        colorTopView.backgroundColor = .orange
        scoreView.layer.borderWidth = 1
        scoreView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        scoreView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        pointTitleLabel.setStyle(font: .systemFont(ofSize: 12), color: .white)
        pointLabel.setStyle(font: .boldSystemFont(ofSize: 28), color: .white)
        pointTitleLabel.text = "List"
        pointLabel.text = "Welcome"
        
        dateLabel.numberOfLines = 0
        dateLabel.setStyle(font: .systemFont(ofSize: 12), color: UIColor.white.withAlphaComponent(0.7))
        dateLabel.text = "Detail"
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = viewModel.datasource
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 66;
        
        tableView.separatorStyle = .none
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        edgesForExtendedLayout = []
        self.view.clipsToBounds = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadDidPull), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    override func addObserver() {
        super.addObserver()
        viewModel.datasource?.data.addAndNotify(observer: self, completionHandler: { [weak self] (_) in
            self?.tableView.reloadData()
        })
        
        viewModel.networkState.addObserver(self) { [weak self] (state) in
            guard let `self` = self else { return }
            switch state {
            case .loading:
                self.refreshControl.beginRefreshing()
            default:
                // finish with value, no value, error
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func reloadDidPull(_ sender: Any) {
        viewModel.getData()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.datasource?.data.value[indexPath.row]
        
        let vc = DetailContainerViewController()
        vc.viewModel.model.value = item
        let nav = TransparentViewController(rootViewController: vc)
        presentFromRightToLeft(nav, animated: true, addSwipeBack: indexPath.row % 2 == 0 ? .Edge : .Full, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if scrollView.contentOffset.y >= 0 {
                let top = colorTopView.frame.size.height * -1
                let offset = scrollView.contentOffset.y * -1.5
                colorTopConstraint.constant = offset < top ? top : offset
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.colorTopConstraint.constant = 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
