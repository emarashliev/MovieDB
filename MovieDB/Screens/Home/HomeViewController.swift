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

        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPressed))
        navigationItem.rightBarButtonItem = button
    }

    func bindViewModel() {
        let nibId = HomeCollectionViewCell.nibIdentifier
        let cellType = HomeCollectionViewCell.self
        viewModel.movies
            .bind(to: collectionView.rx.items(cellIdentifier: nibId, cellType: cellType)) { (_, movie, cell) in
                cell.poster.kf.setImage(with: movie.posterUrl)
                cell.title.text = movie.title
                cell.genres.text = movie.genres
                cell.score.text = movie.popularity
                cell.year.text = movie.releaseYear
            }
            .disposed(by: disposeBag)
    }

    @objc
    func refreshPressed() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        viewModel.refresh()
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
