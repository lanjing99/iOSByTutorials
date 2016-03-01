//
//  TodayViewController.swift
//  BTC widget
//
//  Created by lanjing on 3/1/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptoCurrencyKit

class TodayViewController: CurrencyDataViewController, NCWidgetProviding {
    
    @IBOutlet weak var toggleLineChartButton: UIButton!
    @IBOutlet weak var lineChartHeightConstraint: NSLayoutConstraint!
    
    var lineChartIsVisibale = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        lineChartHeightConstraint.constant = 0
        lineChartView.delegate = self
        lineChartView.dataSource = self
        priceChangeLabel.text = "--"
        priceLabel.text = "--"
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchPrices{ error in
            if error == nil {
                self.updatePriceLabel()
                self.updatePriceChangeLabel()
                self.updatePriceHistoryLineChart()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePriceHistoryLineChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        fetchPrices { error in
            if error == nil {
            self.updatePriceLabel()
            self.updatePriceChangeLabel()
            self.updatePriceHistoryLineChart()
            completionHandler(.NewData)
        } else {
                completionHandler(.NoData)
            }
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    
    override func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 0.17, green: 0.49, blue: 0.82, alpha: 1.0)
    }
    @IBAction func toggleLineChart(sender: UIButton) {
        if lineChartIsVisibale {
            lineChartHeightConstraint.constant = 0
            let transform = CGAffineTransformMakeRotation(0);
            toggleLineChartButton.transform = transform
            lineChartIsVisibale = false
        }else{
            lineChartHeightConstraint.constant = 98
            let transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            toggleLineChartButton.transform = transform
            lineChartIsVisibale = true
        }
        
//        let url = NSURL(string: "crypticker://")
//        extensionContext!.openURL(url!, completionHandler: nil)
        
    }
}
