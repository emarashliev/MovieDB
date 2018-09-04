//
//  HomeViewController.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: UIViewController, BindableType {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: HomeViewModel!
    var prefetchedIndexPaths = [IndexPath]()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerCell(type: HomeCollectionViewCell.self)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        let nibId = HomeCollectionViewCell.nibIdentifier
        let cellType = HomeCollectionViewCell.self
        viewModel.movies
            .bind(to: collectionView.rx.items(cellIdentifier: nibId, cellType: cellType)) { (_, movie, cell) in
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")
                cell.poster.kf.setImage(with: url)

                cell.title.text = movie.title
                cell.genres.text = movie.genres.compactMap { $0.name }.joined(separator: ", ")
                cell.score.text = String(format: "%.3f", movie.popularity!) + " popularity score"
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY"
                let parser = DateFormatter()
                parser.dateFormat = "YYYY-MM-DD"
                cell.year.text =  formatter.string(from: parser.date(from: movie.releaseDate!)!) + " year"
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize()
    }

    private func itemSize() -> CGSize {
        let numberOfColumns = CGFloat(2)
        let minimumInteritemSpacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
            .minimumInteritemSpacing
        let itemSize = floor((UIScreen.main.bounds.width - ((numberOfColumns - 1) *  minimumInteritemSpacing)) /
            numberOfColumns)
        return CGSize(width: itemSize, height: itemSize * 1.5)
    }
}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.item  == viewModel.movies.value.count  - 1 {
            viewModel.fetchNextPage()
        }
    }
}
