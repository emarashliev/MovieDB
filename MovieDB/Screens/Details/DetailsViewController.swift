//
//  DetailsViewController.swift
//  MovieDB
//
//  Created by Emil Marashliev on 5.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailsViewController: UIViewController, BindableType {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var genres: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var runtime: UILabel!
    @IBOutlet var revenue: UILabel!
    @IBOutlet var language: UILabel!
    @IBOutlet var link: UILabel!
    
    var viewModel: DetailsViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Button actions

    @IBAction func linkTaped(_ sender: Any) {
        if let url = viewModel.movie.value.homepageUrl {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - BindableType

    func bindViewModel() {
        viewModel.movie
            .observeOn(MainScheduler.instance)
            .bind { [weak self] movie in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.title = movie.title
                strongSelf.image.kf.setImage(with: movie.posterUrl)
                strongSelf.genres.text = movie.genresString
                strongSelf.desc.text = movie.overview
                strongSelf.score.text = movie.popularity
                strongSelf.year.text = movie.releaseYear
                strongSelf.runtime.text = movie.runtime
                strongSelf.revenue.text = movie.revenue
                strongSelf.language.text = movie.language
                strongSelf.link.attributedText = movie.homepage
            }
            .disposed(by: disposeBag)
    }
}
