//
//  CalculatorViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    //MARK: - Variables
    
    var number: Double = 0.0
    var numberShow: String = ""
    var operative: Symbol.Light = .null
    var numberLeft: Double = 0
    var numberRight: Double = 0
    var result: Double = 0
    var lastAction: [String] = []
    var modelName: String = ""
    
    @IBOutlet weak var calculatorScreen: UILabel!
    @IBOutlet weak var labelAdd: UILabel!
    @IBOutlet weak var labelSubtract: UILabel!
    @IBOutlet weak var labelMultiply: UILabel!
    @IBOutlet weak var labelDivide: UILabel!
    
    @IBOutlet weak var acButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var sumButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    
    private let calculator = Calculator()
    private let preferences = Preferences()
    private let symbol = Symbol()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDisplay()
    }
    
    //MARK: - Additionnal functions
    
    @IBAction func percent() {
        if numberShow != "" {
            lastAction.append("%")
            number = Double(numberShow)! / 100
            numberShow = "\(number)"
            updateDisplay()
        }
    }
    
    @IBAction func sum() {
        lastAction.append("sum")
        let sum: Double
        if numberShow == "" {
            sum = preferences.displaySum()
        } else {
            if calculatorScreen.text == "0" {
                preferences.resetSum()
                sum = 0
            } else {
                preferences.addSum(spent: Double(numberShow)!)
                sum = preferences.displaySum()
            }
        }
        numberShow = String(format: sum == floor(sum) ? "%.0f" : "%.1f", sum)
        updateDisplay()
    }
    
    //MARK: - Cancel functions
    
    @IBAction func cancel() {
        guard lastAction.count > 0 else { return }
        switch lastAction.last! {
        case ".","0","1","2","3","4","5","6","7","8","9":
            numberShow.removeLast()
        case "+","-","*","/":
            numberShow = floatToString(number: numberLeft)
            operative = .null
            updateLabelOperative()
        case "%":
            number = Double(numberShow)! * 100
            numberShow = floatToString(number: number)
        case "sum":
            if lastAction.count > 1 {
                if operative != .null {
                    let operation: String = symbol.getOperator(light: operative)
                    numberShow = lastAction[lastAction.firstIndex(of: operation)! + 1..<lastAction.count - 1].joined()
                } else {
                    lastAction.removeLast()
                    let sum = preferences.displaySum() - Double(lastAction.joined())!
                    preferences.saveSum(spent: sum)
                    lastAction.removeAll()
                    lastAction.append("sum")
                    lastAction.append("\(sum)")
                    numberShow = floatToString(number: sum)
                }
            } else {
                numberShow = ""
            }
        default:
            break
        }
        lastAction.removeLast()
        updateDisplay()
    }
    
    @IBAction func allCancel() {
        guard lastAction.count > 0 else { return }
        number = 0
        numberShow = ""
        operative = .null
        numberLeft = 0
        numberRight = 0
        result = 0
        lastAction.removeAll()
        updateDisplay()
        updateLabelOperative()
    }
    
    //MARK: - Calculator functions
    
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        guard numberShow != "" else { return }
        numberLeft = Double(numberShow)!
        let thisOperator = sender.titleLabel!.text!
        numberShow += "\(thisOperator)"
        updateLabelOperative()
        switch thisOperator {
        case "+":
            operative = .add
            lastAction.append("+")
            updateLabel(label: labelAdd, shadow: .selected)
            setColorLabel(label: labelAdd)
        case "-":
            operative = .subtract
            lastAction.append("-")
            updateLabel(label: labelSubtract, shadow: .selected)
            setColorLabel(label: labelSubtract)
        case "*":
            operative = .multiply
            lastAction.append("*")
            updateLabel(label: labelMultiply, shadow: .selected)
            setColorLabel(label: labelMultiply)
        case "/":
            operative = .divide
            lastAction.append("/")
            updateLabel(label: labelDivide, shadow: .selected)
            setColorLabel(label: labelDivide)
        default:
            operative = .null
        }
        updateDisplay()
        numberShow = ""
    }
    
    @IBAction func buttonResult(_ sender: Any) {
        guard numberLeft != 0 && numberShow != "" else { return }
        numberRight = Double(numberShow)!
        calculate()
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        if lastAction.count > 0 {
            switch lastAction.last! {
                case "sum","=":
                    allCancel()
                default:
                    break
            }
        }
        let thisNumber = sender.titleLabel!.text!
        lastAction.append(thisNumber)
        numberShow += "\(thisNumber)"
        updateDisplay()
    }
    
    @IBAction func buttonPoint(_ sender: Any) {
        lastAction.append(".")
        if numberShow == "" {
            numberShow += "0."
        } else {
            numberShow += "."
        }
        updateDisplay()
    }
    
    func calculate() {
        updateLabelOperative()
        lastAction.removeAll()
        lastAction.append("=")
        result = calculator.result(numberLeft: numberLeft, numberRight: numberRight, operative: operative.rawValue)
        numberLeft = result
        numberRight = 0
        numberShow = floatToString(number: result)
        updateDisplay()
    }
    
    //MARK: - DisplayFunction
    
    func updateDisplay() {
        calculatorScreen.text = numberShow
    }
    
    // MARK: - Color Functions
    
    func setColorLabel(label: UILabel) {
        label.textColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1)
    }
    
    //MARK: - Label functions
    
    func updateLabel(label: UILabel, shadow: Symbol.Shadow) {
        label.textColor = UIColor(red: shadow.val, green: shadow.val, blue: shadow.val, alpha: 1)
    }
    
    func updateLabelOperative() {
        updateLabel(label: labelAdd, shadow: .empty)
        updateLabel(label: labelSubtract, shadow: .empty)
        updateLabel(label: labelMultiply, shadow: .empty)
        updateLabel(label: labelDivide, shadow: .empty)
    }
    
    func updateLabelOperative(label: UILabel) {
        switch label {
        case labelAdd:
            updateLabel(label: labelAdd, shadow: .selected)
            updateLabel(label: labelSubtract, shadow: .empty)
            updateLabel(label: labelMultiply, shadow: .empty)
            updateLabel(label: labelDivide, shadow: .empty)
        case labelSubtract:
            updateLabel(label: labelAdd, shadow: .empty)
            updateLabel(label: labelSubtract, shadow: .selected)
            updateLabel(label: labelMultiply, shadow: .empty)
            updateLabel(label: labelDivide, shadow: .empty)
        case labelMultiply:
            updateLabel(label: labelAdd, shadow: .empty)
            updateLabel(label: labelSubtract, shadow: .empty)
            updateLabel(label: labelMultiply, shadow: .selected)
            updateLabel(label: labelDivide, shadow: .empty)
        case labelDivide:
            updateLabel(label: labelAdd, shadow: .empty)
            updateLabel(label: labelSubtract, shadow: .empty)
            updateLabel(label: labelMultiply, shadow: .empty)
            updateLabel(label: labelDivide, shadow: .selected)
        default:
            return
        }
    }
    
    //MARK: - general functions
    
    func design() {
        calculatorScreen.layer.borderWidth = 1.0
        calculatorScreen.layer.borderColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1).cgColor
    }
    
    func floatToString(number: Double) -> String {
        // fonction pour supprimer la décimal si elle est nulle.
        return String(format: "%g", number)
    }
}
