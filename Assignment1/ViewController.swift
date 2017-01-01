//
//  ViewController.swift
//  Assignment1
//
//  Created by Vinupriya on 12/30/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var storeTableView: UITableView!
    
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Assignment1"
        
        storeTableView.estimatedRowHeight = 50.0
        storeTableView.rowHeight = UITableViewAutomaticDimension
        
        ServiceHandler.getStores { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            strongSelf.loadingView.hidden = true
            strongSelf.loadingIndicator.stopAnimating()
            
            switch result {
            case .Success(let storesResult):
                if let storesResult = storesResult as? [Store] {
                    strongSelf.stores.removeAll()
                    strongSelf.stores = storesResult
                    strongSelf.storeTableView.reloadData()
                }
                
            case .Failure(_): break
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? StoreCellTableViewCell {
            cell.nameLabel.text = stores[indexPath.row].name
            cell.addressLabel.text = stores[indexPath.row].fullAddress
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController {
            controller.store = stores[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}



