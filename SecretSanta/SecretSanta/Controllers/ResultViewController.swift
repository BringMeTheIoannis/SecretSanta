//
//  ResultViewController.swift
//  SecretSanta
//
//  Created by Ivan Kuzmenkov on 5.01.23.
//

import UIKit

class ResultViewController: UIViewController {
    
    var namesArray = [[String]]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGray4
        snowEffect()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.systemGray4
    }
    
    func snowEffect() {
        let flakeEmitterCell = CAEmitterCell()
                flakeEmitterCell.contents = UIImage(systemName: "snowflake")?.cgImage
                flakeEmitterCell.scale = 0.06
                flakeEmitterCell.scaleRange = 0.3
                flakeEmitterCell.emissionRange = .pi
                flakeEmitterCell.lifetime = 20.0
                flakeEmitterCell.birthRate = 40
                flakeEmitterCell.velocity = -30
                flakeEmitterCell.velocityRange = -20
                flakeEmitterCell.yAcceleration = 20
                flakeEmitterCell.xAcceleration = 5
                flakeEmitterCell.spin = -0.5
                flakeEmitterCell.spinRange = 1.0

                let snowEmitterLayer = CAEmitterLayer()
                snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
                snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
                snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
                snowEmitterLayer.beginTime = CACurrentMediaTime()
                snowEmitterLayer.timeOffset = 10
                snowEmitterLayer.emitterCells = [flakeEmitterCell]
                
        view.layer.addSublayer(snowEmitterLayer)
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return namesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableCell.self), for: indexPath)
        guard let cell = cell as? ResultTableCell else { return cell }
        cell.fromLabel.text = "From: \(namesArray[indexPath.row][0])"
        cell.toLabel.text = "To: \(namesArray[indexPath.row][1])"
        return cell
    }
}

extension ResultViewController: UITableViewDelegate {
}
