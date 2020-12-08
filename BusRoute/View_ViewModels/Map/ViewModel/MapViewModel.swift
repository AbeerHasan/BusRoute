//
//  MapViewModel.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/7/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
//--- Variables--------------------------------------
    let apiService: BaseAPIProtocol
  
    var driverNameBehavior = BehaviorRelay<String>(value: "")
    var driverPasswordBehavior = BehaviorRelay<String>(value: "")
    var deviceTokenBehavior = BehaviorRelay<String>(value: "")
    
    private var routeSubject = PublishSubject<Route>()
    
    var loginResultObservable: Observable<Route> {
         return routeSubject
     }
//--- init ------------------------------------------
    init(apiService: BaseAPIProtocol = ApiService()) {
        self.apiService = apiService
    }

//--- Data manapulation functions--------------------
    func getRoute(){
        apiService.getBusRouteAndStopPoints(name: driverNameBehavior.value, password: driverPasswordBehavior.value, deviceToken: deviceTokenBehavior.value) { [weak self] (result) in
             guard let self = self else { return }
            switch result {
            case .success(let responseData):
                self.routeSubject.onNext(responseData!.data.user.bus.route)
            case .failure(let error):
                    print(error)
            }
        }
    }
}
