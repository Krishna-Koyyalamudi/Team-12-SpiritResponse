//
//  ResponsesGraphViewController.swift
//  Spirit Response
//
//  Created by Student on 11/16/20.
//

import UIKit
import Charts
import TinyConstraints
import Parse

// ResponsesGraphViewController class to represent the graph
class ResponsesGraphViewController: UIViewController {
    var responses = Responses.shared
    
    /// Outlets for slider and counter label
    @IBOutlet weak var responseSlider:UISlider!
    @IBOutlet weak var responseCountLBL:UILabel!
    
    /// Method to draw the graph
    @IBAction func drawGraph(sender: UISlider){
        setData(sender: sender);
    }
    /// static data as of now to display graph, y values as response time in seconds, x axis as number of responses.
    var graphValues:[ChartDataEntry] = []
    
    /// returns lineChartView for displaying the chart
    lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .systemGray
        lineChartView.rightAxis.enabled = false
        
        /// yAxis constraints
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 15)
        yAxis.axisLineWidth = 2
        yAxis.axisLineColor = .black
        
        /// xAxis constraints
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisLineWidth = 2
        xAxis.labelFont = .boldSystemFont(ofSize: 15)
        xAxis.axisLineColor = .black
        xAxis.labelHeight = 20
        
        lineChartView.animate(xAxisDuration: 2)
        return lineChartView
    }()
    
    /// viewDidLoad() method
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Response Graph"
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        setData(sender: responseSlider)
    }
    
    /// setData funcion to set data on graph and gives line chart
    func setData(sender:UISlider){
        let percentageValue  = Int(floor(sender.value * Float(responses.numResponses())))
        self.graphValues = []
        responseCountLBL.text = "First \(percentageValue) Values"
        for index in 0..<percentageValue{
            if self.responses.getResponse(at: index) != nil {
                let ySeconds = responses.getResponseTime(indes: index)
                self.graphValues.append(ChartDataEntry(x: Double(index), y: ySeconds))
            }
        }
        let dataSet = LineChartDataSet(entries: self.graphValues, label: "Response Time in seconds")
        dataSet.lineWidth = 2
        let data = LineChartData(dataSet: dataSet)
        self.lineChartView.data = data
    }

}
