//
//  DetailsViewController.swift
//  MovieDB
//
//  Created by Emil Marashliev on 5.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit
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

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.movie.title
        image.kf.setImage(with: viewModel.movie.posterUrl)
        genres.text = viewModel.movie.genres
        desc.text = viewModel.movie.overview
        score.text = viewModel.movie.popularity
        year.text = viewModel.movie.releaseYear
        runtime.text = viewModel.movie.runtime
        revenue.text = viewModel.movie.revenue
        language.text = viewModel.movie.language
        link.attributedText = viewModel.movie.homepage
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Button actions

    @IBAction func linkTaped(_ sender: Any) {
        if let url = viewModel.movie.homepageUrl {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - BindableType

    func bindViewModel() {

    }
}
