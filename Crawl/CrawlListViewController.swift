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

    private lazy var viewModel: CrawlListViewModelType = {
        // normally other config/injection happens here, this is a simple case
        return CrawlListViewModel()
    }()

    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = RxTableViewSectionedAnimatedDataSource<CrawlSection>()

        dataSource.configureCell = { (tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCellWithIdentifier("CrawlCell") ?? UITableViewCell(style:.Default, reuseIdentifier: "Cell")

            cell.textLabel!.text = "\(item)"

            return cell
        }

        viewModel.sections
            .drive(tableView.rx_itemsAnimatedWithDataSource(dataSource))
            .addDisposableTo(disposeBag)

        tableView.rx_modelSelected(Crawl)
            .bindNext { [weak self] crawl in
                self?.showCrawlDetail(crawl)
            }
            .addDisposableTo(disposeBag)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: animated)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if let identifier = segue.identifier where identifier == Segue.ShowCrawlDetailFromList,
            let crawlBox = sender as? Box<Crawl>,
            let detailViewController = segue.destinationViewController as? CrawlDetailViewController {
                detailViewController.crawl = crawlBox.value
        }
    }

    func showCrawlDetail(crawl: Crawl) {
        self.performSegue(Segue.ShowCrawlDetailFromList, sender: Box(crawl))
    }
}