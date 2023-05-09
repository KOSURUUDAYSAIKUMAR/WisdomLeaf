//
//  ViewController.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum TableSection: Int {
        case userList
        case loader
    }
    
    var pagesVM = PagesViewModel.pageSharedInstance
    var translateModel = [PagesModel]()
    var selectedRows:[IndexPath] = []
    //    var selectedUser_IDArrays_ = [Int]()
    private let refreshControl = UIRefreshControl()
    
    var currentPage = 1
    var totalPages:Int = 5
    let perpage = 20
    var parsing_Pagination = "page=1&limit=20"
    
    @IBOutlet weak var pagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagesTableView.tableFooterView = UIView.init(frame: .zero)
        displayDataFromVM(pagination: parsing_Pagination)
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            pagesTableView.refreshControl = refreshControl
        } else {
            pagesTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPageData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Pages Data ...")
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshPageData(_ sender: Any) {
        displayDataFromVM(pagination: parsing_Pagination)
    }
    
    func tableviewReload() {
        pagesTableView.reloadData()
    }
    
    func displayDataFromVM(pagination: String) {
        pagesTableView.refreshControl?.beginRefreshing()
        DispatchQueue.global(qos: .background).async { [self] in
            pagesVM.getResponseFromNetworkManager(page: pagination) { [self] result in
                switch result {
                case .success(let model):
                    translateModel += model
                    DispatchQueue.main.async { [self] in
                        tableviewReload()
                        pagesTableView.refreshControl?.endRefreshing()
                    }
                case .failure(let error):
                    debugPrint("pages error", error)
                    break
                }
            }
        }
    }
    
    //Pagination
    func incrementPage() {
        currentPage = currentPage + 1
        parsing_Pagination = "page=" + "\(currentPage)" + "&limit=" + "\(perpage)"
    }
    
    func loadtableView() {
        incrementPage()
        displayDataFromVM(pagination: parsing_Pagination)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return translateModel.count
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .userList:
            return translateModel.count
        case .loader:
            return translateModel.count >= perpage ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .userList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: .pagesIdentifier, for: indexPath) as? PagesTableViewCell else { return UITableViewCell() }
            let index = indexPath.row
            cell.authorLabel.text = translateModel[index].author 
            cell.descriptionLabel.text = translateModel[index].url
            if let url = URL(string: translateModel[index].download_url) {
                if let image = SDImageCache.shared.imageFromCache(forKey: url.absoluteString) {
                    cell.authorImageView.image = image
                } else if let image = SDImageCache.shared.imageFromMemoryCache(forKey: url.absoluteString) {
                    cell.authorImageView.image = image
                } else {
                    
                }
            }
            
            if selectedRows.contains(indexPath) {
                cell.radioButton.setImage(UIImage(named:"select_checkbox"), for: .normal)
            } else {
                cell.radioButton.setImage(UIImage(named:"unselect_checkbox"), for: .normal)
            }
            
            cell.radioButton.tag = indexPath.row
            cell.radioButton.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
            
            cell.bgView.roundCorners(corners: .allCorners, radius: 5.0)
            cell.bg2View.roundCorners(corners: .allCorners, radius: 5.0)
            cell.setNeedsDisplay()
            cell.layoutIfNeeded()
            return cell
        case .loader:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = "Loading.."
            cell.textLabel?.textColor = .systemBlue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !translateModel.isEmpty else { return }

        if section == .loader {
            if(currentPage < totalPages) {
                loadtableView()
                hideBottomLoader()
            } else {
                tableviewReload()
                hideBottomLoader()
            }
        }
    }
   
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.translateModel.count - 1, section: TableSection.userList.rawValue)
            self.pagesTableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: check box selection
    
    @objc func checkBoxSelection(_ sender:UIButton) {
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if selectedRows.contains(selectedIndexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: selectedIndexPath)!)
            //  self.selectedUser_IDArrays_.removeAll(where: { $0 == Int(self.contacts[sender.tag].index)})
        } else {
            self.selectedRows.append(selectedIndexPath)
            //   self.selectedUser_IDArrays_.append(Int(self.contacts[sender.tag].index) ?? 0)
        }
        tableviewReload()
    }
}
