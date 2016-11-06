//
//  PointsGraphViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//


import UIKit
import ResearchKit

private let kLivelyGreenColor = UIColor(red: 8 / 255, green: 132 / 255, blue: 67 / 255, alpha: 1)

class PointsGraphViewController: UIViewController, ORKValueRangeGraphChartViewDataSource {
    let graphViewBox = UIView()
    let pointGraph = ORKLineGraphChartView()
    
    var cumulativePoints: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MockData.init()
        NotificationCenter.default.addObserver(self, selector: #selector(setupUser), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        
        configureGraphViewBox()
        setupUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePointsGraph()
        pointGraph.animate(withDuration: 2)
    }
    
    func setupUser(){
        if TravelerController.shared.masterTraveler == nil {
            MockData.shared.setUpTraveler()
        }
        setUpPointsToPresent()
        setUpDateLabels()
        pointGraph.reloadData()
        pointGraph.animate(withDuration: 2)
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
        pointGraph.tintColor = kLivelyGreenColor
        pointGraph.verticalAxisTitleColor = UIColor.black
        //pointGraph.showsVerticalReferenceLines = true
        pointGraph.axisColor = UIColor.black
        pointGraph.noDataText = "No points earned yet."
    }
    
    func setUpPointsToPresent(){
        cumulativePoints = []
        let points = AwardController.updateTravelerPoints().pointsArray
        var sum = 0;
        for point in points {
            sum += point
            cumulativePoints.append(sum)
            print(point)
        }
        
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func setUpDateLabels(){
        guard let traveler = TravelerController.shared.masterTraveler else { return }
        let locations = traveler.locationsVisited
        for location in locations {
            
                for visit in location.datesVisited {
                    print(dateFormatter.string(from: visit))
                }
            
        }
    }
    
    // MARK: - Plot data source
    
    func numberOfDivisionsInXAxis(for graphChartView: ORKGraphChartView) -> Int {
        guard let traveler = TravelerController.shared.masterTraveler else { return 1}
        return traveler.locationsVisited.count
    }
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        guard let traveler = TravelerController.shared.masterTraveler else { return 0 }
        return traveler.locationsVisited.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        let point = ORKValueRange(value: Double(self.cumulativePoints[pointIndex]))
        
        return point
        
    }
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func maximumValue(for graphChartView: ORKGraphChartView) -> Double {
        guard let traveler = TravelerController.shared.masterTraveler else { return 10 }
        return Double(traveler.points + 2)
    }
    
    func minimumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 0
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        if pointIndex == 0 {
            return "2016"
        } else {
            return nil
        }
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, drawsPointIndicatorsForPlotIndex plotIndex: Int) -> Bool {
        return true
    }
    
    
}
 
