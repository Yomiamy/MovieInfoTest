//
//  ViewController.swift
//  MovieInfoTest
//
//  Created by yomi on 2021/8/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // API Test
//        let req:MovieListRequest = MovieListRequest(
//            apiKey: Constants.API_KEY,
//            primaryReleaseDate: "2016-12-31",
//            sortBy: "release_date.desc",
//            page: 1
//        )
        
        let req:MovieDetailRequest = MovieDetailRequest(
            apiKey: Constants.API_KEY
        )
        
        let _ = ApiUtils.requestApi(apiType: MovieInfoApi.MovieDetail("328111", ApiUtils.getBodyParams(obj: req)),
                                    responseType: MovieDetailInfo.self) { data in
            print("Request Success")
        } onFail: { error in
            print("Error")
        } onFinally: {
            print("Finish")
        }

    }


}

