//
//  ViewController.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit

class ViewController: UIViewController {

    var pagesVM = PagesViewModel.pageSharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func displayDataFromVM() {
        pagesVM.getResponseFromNetworkManager { result in
            
        }
    }

}

