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
    private let disposeBag = DisposeBag()
    private var executedOnce = false

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerCell(type: HomeCollectionViewCell.self)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPressed))
        navigationItem.rightBarButtonItem = button
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true

        if executedOnce { return }
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController

        searchController.searchBar.rx.value
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text?.count == 0 {
                    self.viewModel.reset()
                } else {
                    self.viewModel.search(forMovies: text!)
                }
            } )
            .disposed(by: disposeBag)

        searchController.searchBar.rx.textDidEndEditing.subscribe(onNext: {
            self.viewModel.reset()
        })
            .disposed(by: disposeBag)
        executedOnce = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.searchController?.isActive = false
    }

    // MARK: - Button actions

    @objc
    func refreshPressed() {
        viewModel.refresh()
    }

    // MARK: - BindableType

    func bindViewModel() {
        let nibId = HomeCollectionViewCell.nibIdentifier
        let cellType = HomeCollectionViewCell.self
        viewModel.movies
            .bind(to: collectionView.rx.items(cellIdentifier: nibId, cellType: cellType)) { (_, movie, cell) in
                cell.poster.kf.setImage(with: movie.posterUrl)
                cell.title.text = movie.title
                cell.genres.text = movie.genres
                cell.score.text = "Popularity score: " + movie.popularity
                cell.year.text = "Year: " + movie.releaseYear
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.viewModel.showDetails(for: indexPath.item)
            } )
            .disposed(by: disposeBag)
    }
}

// MARK: - Collection View Delegate Flow Layout

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

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.item  == viewModel.movies.value.count  - 1 {
            viewModel.fetchNextPage()
        }
    }
}
