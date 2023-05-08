//
//  ViewController.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pagesVM = PagesViewModel.pageSharedInstance
    
    var translateModel = [PagesModel]()
    var selectedRows:[IndexPath] = []
    //    var selectedUser_IDArrays_ = [Int]()
    
    @IBOutlet weak var pagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDataFromVM()
        // Do any additional setup after loading the view.
    }
    
    func tableviewReload() {
        pagesTableView.reloadData()
    }
    
    func displayDataFromVM() {
        DispatchQueue.global(qos: .background).async { [self] in
            pagesVM.getResponseFromNetworkManager { [self] result in
                switch result {
                case .success(let model):
                    translateModel = model
                    DispatchQueue.main.async { [self] in
                        tableviewReload()
                    }
                case .failure(let error):
                    debugPrint("pages error", error)
                    break
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .pagesIdentifier, for: indexPath) as? PagesTableViewCell else { return UITableViewCell() }
        let index = indexPath.row
        cell.authorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cell.descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
