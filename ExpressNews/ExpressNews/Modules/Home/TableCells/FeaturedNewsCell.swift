//
//  FeaturedNewsCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import UIKit
import SwiftUI

class FeaturedNewsCell: UITableViewCell {
    private var timer: Timer?
    var openNewsDetails: ((NewsArticle) -> Void)?
    var cellModel: FeaturedNewsCellModel = FeaturedNewsCellModel()

    var payload: [String: Any] = [:] {
        didSet {
            cellModel.configure(payload: payload)
        }
    }

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 200),

                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
                pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.CellIds.featuredNewsItemCell)
        pageControl.numberOfPages = cellModel.getNumberOfRows()
    }

    func configure(with news: [NewsArticle]) {
        cellModel.newsArticles = news
        pageControl.numberOfPages = cellModel.getNumberOfRows()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        startAutoScroll()
    }
    
    func stopAutoScroll() {
        timer?.invalidate()
    }

    func startAutoScroll() {
        timer?.invalidate() // Invalidate existing timer if any
        guard cellModel.getNumberOfRows() > 1 else { return }
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }

    @objc private func autoScroll() {
        guard cellModel.getNumberOfRows() > 1 else { return }

        let visibleItems = collectionView.indexPathsForVisibleItems
        if let currentItem = visibleItems.first {
            var nextItem = currentItem.item + 1

            if nextItem == cellModel.getNumberOfRows() {
                nextItem = 0
            }

            let nextIndexPath = IndexPath(item: nextItem, section: currentItem.section)

            // Make sure to check if the nextIndexPath is within the range
            guard nextItem < cellModel.getNumberOfRows() else { return }

            let rect = self.collectionView.layoutAttributesForItem(at:nextIndexPath)?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
            pageControl.currentPage = nextItem
        }
    }
}

extension FeaturedNewsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.getNumberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.featuredNewsItemCell, for: indexPath) 
        if let news = cellModel.getNewsForRow(index: indexPath.item) {
            if #available(iOS 16.0, *) {
                cell.contentConfiguration = UIHostingConfiguration(content: {
                    FeaturedNewsItemCell(news: news)
                })
            } else {
                cell.contentConfiguration = HostingContentConfiguration{
                    FeaturedNewsItemCell(news: news)
                }
            }
        }
        return cell
    }
}

extension FeaturedNewsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let news = cellModel.getNewsForRow(index: indexPath.item) {
            openNewsDetails?(news)
        }
    }
}

extension FeaturedNewsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width // Use the screen width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension FeaturedNewsCell {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageControl()
    }

    private func updatePageControl() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = indexPath.item
        }
    }
}
