//
//  SettingsViewController.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 28/12/2024.
//

import UIKit

private struct Item {
    let title: String
    let action: Selector

    init(title: String, action: Selector) {
        self.title = title
        self.action = action
    }
}

final class SettingsViewController: UIViewController {
    private lazy var items = [
        Item(title: "清除缓存", action: #selector(cleanCache)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        setupNavigationBar()
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupNavigationBar() {
        navigationItem.setRightBarButton(UIBarButtonItem(title: "完成",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(onComplete)),
                                         animated: false)
    }

    @objc
    private func cleanCache() {
        present(UIAlertController(title: "清除缓存", message: "确认清除缓存？", preferredStyle: .alert).then {
            $0.addAction(UIAlertAction(title: "取消", style: .cancel))
            $0.addAction(UIAlertAction(title: "确定", style: .destructive) { _ in
                CacheManager.shared.clear()
                ImageManager.shared.clear()
            })
        }, animated: true)
    }

    @objc
    private func onComplete() {
        dismiss(animated: true)
    }

    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 58
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil).then {
            $0.textLabel?.text = items[indexPath.row].title
            $0.selectionStyle = .none
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(items[indexPath.row].action)
    }
}
