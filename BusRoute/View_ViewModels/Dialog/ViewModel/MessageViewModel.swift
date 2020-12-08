//
//  MessageViewModel.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MessageViewModel {
//--- Variables--------------------------------------
    let apiService: BaseAPIProtocol
    
    private var htmlStringSubject = PublishSubject<String>()
       
       var loginResultObservable: Observable<String> {
            return htmlStringSubject
        }
    
//--- init ------------------------------------------
    init(apiService: BaseAPIProtocol = ApiService()) {
        self.apiService = apiService
        getHTMLContent()
    }

//--- Data manapulation functions--------------------
    func getHTMLContent(){
         apiService.getHtmlPageContent {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let resultData):
                self.htmlStringSubject.onNext(resultData!.innerData[0].content)
            case .failure(let error):
                print(error)
            }
        }
    }
}
