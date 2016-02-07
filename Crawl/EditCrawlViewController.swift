//
//  EditCrawlViewController.swift
//  Crawl
//
//  Created by Tom Burns on 2/6/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EditCrawlViewController: MainInterfaceViewController {
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    private lazy var viewModel: EditCrawlViewModelType = {
        return EditCrawlViewModel(dependencies: self.dependencies)
    }()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButtonItem.rx_tap
            .bindNext {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        saveBarButtonItem.rx_tap
            .bindNext(saveTap)
            .addDisposableTo(disposeBag)
    }

    func saveTap() {
        self.viewModel.save()
            .subscribeOn(MainScheduler.instance)
            .subscribe { event in
                switch event {
                case .Next:
                    break
                case .Completed:
                    self.dismissViewControllerAnimated(true, completion: nil)
                case .Error(let error):
                    print(error)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            .addDisposableTo(disposeBag)
    }
}