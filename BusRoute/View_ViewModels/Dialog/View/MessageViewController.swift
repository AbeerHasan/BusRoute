//
//  MessageViewController.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class MessageViewController: UIViewController {

//--- Outlets ----------------------------------------
    @IBOutlet weak var webView: WKWebView!
    
//--- Variables --------------------------------------
    lazy var viewModel: MessageViewModel = {
        return MessageViewModel()
    }()

    let disposeBag = DisposeBag()
//--- ViewDidLoad ------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setUp()
        /**/
    }
    
//--- Actions --------------------------------------
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//--- Helper Functions ------------------------------
    func setUp(){
        viewModel.loginResultObservable.subscribe(onNext: { [weak self](content) in
            guard let self = self else {return}
            let html = """
                        \(content)
                        """
            self.webView.loadHTMLString(html, baseURL: nil)
        }).disposed(by: disposeBag)
    }
}
