//
//  ViewController.swift
//  TempConverter
//
//  Created by Admin on 8/18/20.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0;
        nf.maximumFractionDigits = 1;
        return nf;
    }()

    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        }
        else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        var replacementTextHasAlpha = false;
        for char in string.unicodeScalars {
            if CharacterSet.letters.contains(char) {
                replacementTextHasAlpha = true
                break
            }
        }

            if (existingTextHasDecimalSeparator != nil &&
                replacementTextHasDecimalSeparator != nil) || replacementTextHasAlpha {
                return false
            }
        return true
    }
    
    func updateCelsiusLabel(){
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.init(
            red: CGFloat.random(in: 0.0 ... 1.0),
            green: CGFloat.random(in: 0.0 ... 1.0),
            blue: CGFloat.random(in: 0.0 ... 1.0),
            alpha: CGFloat.random(in: 0.0 ... 1.0)
        )
    }
}

