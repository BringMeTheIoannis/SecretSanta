//
//  ViewController.swift
//  SecretSanta
//
//  Created by Ivan Kuzmenkov on 3.01.23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var arrayOfTextFields = [UITextField]()
    var arrayOfNames = [String]()
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addNewView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray4
        addNewView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        snowEffect()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        addObserversForKeyboard()
    }
    
    @IBAction func resultsButtonAction(_ sender: Any) {
        arrayOfNames = []
        arrayOfTextFields.forEach { textField in
            guard let name = textField.text else { return }
            if name.isEmpty {
                alertIfEmpty()
            } else {
                arrayOfNames.append(name)
            }
        }
        if arrayOfNames.count % 2 != 0 {
            alertIfOdd()
        } else if arrayOfTextFields.isEmpty {
            alertNoTextFields()
        } else {
        arrayOfNames.shuffle()
            var names2dArray = Array(zip(arrayOfNames, arrayOfNames.dropFirst())).map {[$0.0, $0.1]}
            if arrayOfNames.count >= 2 {
                names2dArray.append([arrayOfNames.last ?? "", arrayOfNames.first ?? ""])
            }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultVC = storyboard.instantiateViewController(withIdentifier: String(describing: ResultViewController.self)) as? ResultViewController else { return }
        resultVC.namesArray = names2dArray
        navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    @IBAction func addFieldButton(_ sender: Any) {
        let view = UIView()
        let textField = UITextField()
        let deleteButton = UIButton(type: .system)
        buttonSetup(deleteButton: deleteButton)
        textfieldSetup(textfield: textField)
        arrayOfTextFields.append(textField)
        view.addSubview(textField)
        view.addSubview(deleteButton)
        self.stackView.insertArrangedSubview(view, at: stackView.arrangedSubviews.count - 1)
        self.addNewView.alpha = 0.0
        view.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1.0
            self.addNewView.alpha = 1.0
            //            textField.becomeFirstResponder()
        }
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(31)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(view.snp.centerY)
        }
        textField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        view.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    func alertIfEmpty() {
        let alert = UIAlertController(title: "Warning", message: "One of fields is empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func alertNoTextFields() {
        let alert = UIAlertController(title: "Warning", message: "No names here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func alertIfOdd() {
        let alert = UIAlertController(title: "Warning", message: "Somebody will be without a gift", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func buttonSetup(deleteButton: UIButton) {
        deleteButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(deleteView), for: .touchUpInside)
    }
    
    @objc func deleteView(sender: UIButton) {
        let textField = sender.superview?.subviews[0]
        arrayOfTextFields = arrayOfTextFields.filter({$0 != textField})
        UIView.animate(withDuration: 0.3) {
            sender.superview?.alpha = 0.0
        } completion: { isCompleted in
            if isCompleted {
                UIView.animate(withDuration: 0.3, delay: 0) {
                    sender.superview?.removeFromSuperview()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func textfieldSetup(textfield: UITextField) {
        textfield.delegate = self
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.placeholder = "Enter your nickname"
    }
    
    func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        view.bringSubviewToFront(scrollView)
        view.bringSubviewToFront(resultsButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func removeObservers() {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if  buttonBottomConstraint.constant == 10 {
            //            self.view.frame.origin.y -= keyboard.cgRectValue.height
            buttonBottomConstraint.constant = keyboard.cgRectValue.height
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if buttonBottomConstraint.constant != 10 {
            buttonBottomConstraint.constant = 10
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

