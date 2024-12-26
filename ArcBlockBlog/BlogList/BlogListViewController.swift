//
//  BlogListViewController.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation
import UIKit
import SafariServices

@MainActor
final class BlogListViewController: UIViewController {
    private var models: [BlogListModel] = [] {
        didSet {
            reloadData()
        }
    }

    private var page: Int = 0

    private var isLoading = false {
        didSet {
            reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        view += [
            collectionView += [
                emptyView,
            ],
        ]

        fetchBlogListFromCache()

        collectionView.startHeaderRefresh()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        emptyView.frame = view.bounds
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func setupNavigationBar() {
        navigationItem.titleView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "logo-rect")
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 28),
            ])
        }

        navigationItem.setRightBarButton(UIBarButtonItem(image: .init(systemName: "gear"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(toSettings)),
                                         animated: false)
    }

    /// 刷新页面数据
    private func reloadData() {
        collectionView.reloadData()

        // 数据列表为空，且不在加载中
        isEmpty = models.isEmpty && !isLoading
    }

    @objc
    private func toSettings() {
        present(UINavigationController(rootViewController: SettingsViewController().then {
            $0.modalPresentationStyle = .formSheet
        }), animated: true)
    }

    /// 加载缓存数据
    private func fetchBlogListFromCache() {
        if let models = BlogListApi.fetchBlogListFromCache() {
            self.models = models.data
        }
    }

    /// 拉取 blog 列表数据
    private func fetchBlogList(isRefresh: Bool) async {
        guard !isLoading else { return }
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            let page = isRefresh ? 1 : (self.page + 1)
            let result = try await BlogListApi.fetchBlogList(page: page)
            models = isRefresh ? result.data : (models + result.data)
            self.page = page
        } catch {
            Toast.show("加载失败")
        }

        collectionView.endRefresh()
    }

    @objc
    private func onWillEnterForeground() {
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }

    // 内容是否为空
    private var isEmpty: Bool = false {
        didSet {
            emptyView.isHidden = !isEmpty

            if isEmpty {
                // 空内容时不要上拉加载
                collectionView.setFooterRefresh(nil)
            } else {
                collectionView.setFooterRefresh { [weak self] in
                    Task {
                        await self?.fetchBlogList(isRefresh: false)
                    }
                }
            }
        }
    }

    private let layout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = BlogList.spacing
        $0.minimumLineSpacing = BlogList.spacing
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = UIColor(0xF7F7F7, 0x080808)
        $0.dataSource = self
        $0.delegate = self
        $0.registerCells([
            BlogListCell.self,
        ])
        $0.setHeaderRefresh { [weak self] in
            Task {
                await self?.fetchBlogList(isRefresh: true)
            }
        }
    }

    private let emptyView = EmptyView().then {
        $0.isHidden = true
    }
}

extension BlogListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading && models.isEmpty {
            return 3
        }
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(BlogListCell.self, for: indexPath).then {
            $0.model = models[safe: indexPath.item]
        }
    }
}

extension BlogListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - BlogList.inset.left - BlogList.inset.right
        let numberOfColumns = CGFloat(BlogList.numberOfColumns())
        let itemSpacing = BlogList.spacing * (numberOfColumns - 1)
        let itemWidth = ceil((width - itemSpacing) / numberOfColumns)

        let model = models[safe: indexPath.item]
        let itemHeight = ceil(BlogListCell.height(model: model, width: itemWidth))

        return CGSize(itemWidth, itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        BlogList.inset
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = models[safe: indexPath.item],
              let url = URL(string: "https://www.arcblock.io/blog/zh/\(model.slug)")
        else {
            return
        }
        present(SFSafariViewController(url: url).then {
            $0.modalPresentationStyle = .formSheet
        }, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? BlogListCell)?.didEndDisplaying()
    }
}
