//
//  UIScrollView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit
import MJRefresh

extension UIScrollView {
    /// 触发下拉刷新
    func startHeaderRefresh() {
        mj_header?.beginRefreshing()
    }

    /// 停止刷新
    func endRefresh() {
        mj_header?.endRefreshing()
        mj_footer?.endRefreshing()
    }

    /// 下拉刷新
    func setHeaderRefresh(_ block: (() -> Void)?) {
        if let block {
            mj_header = HeaderRefresh {
                block()
            }
        } else {
            mj_header = nil
        }
    }

    /// 上拉加载
    func setFooterRefresh(_ block: (() -> Void)?) {
        if let block {
            mj_footer = FooterRefresh {
                block()
            }
        } else {
            mj_footer = nil
        }
    }
}

private class HeaderRefresh: MJRefreshNormalHeader {
    required init?(coder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
    }

    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView else { return }
        let offsetY = scrollView.mj_offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        let pullingPercent = (happenOffsetY - offsetY) / mj_h
        alpha = max(0, min(1, (pullingPercent - 0.3) / 0.7))
    }
}

private class FooterRefresh: MJRefreshAutoNormalFooter {
    required init?(coder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isRefreshingTitleHidden = true
        stateLabel?.isHidden = true
    }
}
