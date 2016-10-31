//
//  PointsGraphViewController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/28/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import ResearchKit

class PointsGraphViewController: UIViewController, ORKValueRangeGraphChartViewDataSource {
    let graphViewBox = UIView()
    let pointGraph = ORKLineGraphChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setupUser), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        
        configureGraphViewBox()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePointsGraph()
        pointGraph.animate(withDuration: 2)
    }
    
    func setupUser(){
        if TravelerController.shared.masterTraveler == nil {
        MockData.shared.setUpTraveler()
        }
        pointGraph.reloadData()
    }
    
    func configureGraphViewBox(){
        graphViewBox.translatesAutoresizingMaskIntoConstraints = false
//        graphViewBox.backgroundColor = UIColor.green
        self.view.addSubview(graphViewBox)
        
        let viewTop = NSLayoutConstraint(item: graphViewBox, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 8)
        let viewLeading = NSLayoutConstraint(item: graphViewBox, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
        let viewTrailing = NSLayoutConstraint(item: graphViewBox, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1.0, constant: 0)
        let viewBottom = NSLayoutConstraint(item: graphViewBox, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: -8)
        self.view.addConstraints([viewTop, viewLeading, viewTrailing, viewBottom])
    }
    
    func configurePointsGraph(){
        pointGraph.frame = graphViewBox.bounds
        self.graphViewBox.addSubview(pointGraph)
        
        pointGraph.dataSource = self
        pointGraph.tintColor = UIColor(red: 157/255.0, green: 173/255.0, blue: 111/255.0, alpha: 1)

        pointGraph.verticalAxisTitleColor = UIColor.black
        //pointGraph.showsVerticalReferenceLines = true
        pointGraph.axisColor = UIColor.black
        pointGraph.noDataText = "No points earned yet."
    }
    
    // MARK: - Plot data source
    
    func numberOfDivisionsInXAxis(for graphChartView: ORKGraphChartView) -> Int {
        return 10
    }
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return 0
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        let point = ORKValueRange(value: 43.0 + Double(pointIndex)*Double(pointIndex))
        
        return point
        
    }
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func maximumValue(for graphChartView: ORKGraphChartView) -> Double {
        guard let traveler = TravelerController.shared.masterTraveler else { return 10 }
        return Double(traveler.points)
    }
    
    func minimumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 0
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return nil//"Date"
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, drawsPointIndicatorsForPlotIndex plotIndex: Int) -> Bool {
        return false
    }
    
    
}
