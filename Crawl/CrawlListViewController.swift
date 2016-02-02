//
//  CrawlListViewController.swift
//  Crawl
//
//  Created by Tom Burns on 2/2/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class CrawlListViewController: UIViewController {

    private let viewModel = CrawlListViewModel()

    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = RxTableViewSectionedAnimatedDataSource<CrawlSection>()

        dataSource.configureCell = { (tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("CrawlCell") ?? UITableViewCell(style:.Default, reuseIdentifier: "Cell")

            cell.textLabel!.text = "\(i)"

            return cell
        }

        viewModel.sections
            .drive(tableView.rx_itemsAnimatedWithDataSource(dataSource))
            .addDisposableTo(disposeBag)

        tableView.rx_modelSelected(Crawl)
            .bindNext { [weak self] crawl in
                self?.pushPresentationForCrawl(crawl)
                
            }
            .addDisposableTo(disposeBag)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: animated)
        }
    }

    func pushPresentationForCrawl(crawl: Crawl) {
        let viewController = CrawlViewController()

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}