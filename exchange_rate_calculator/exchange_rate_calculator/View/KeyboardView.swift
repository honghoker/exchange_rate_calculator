//
//  CalculateKeyboardView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/30.
//

import Foundation
import SwiftUI

enum Operator: String {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divide = "/"
    case dot = "."
}

struct KeyboardView: View {
    
    @Binding var inputValue: String
    @Binding var calculateValueText: String
    
    @State var dotCheck = false
    
    init(_ inputValue: Binding<String>, _ calculateValueText: Binding<String>) {
        self._inputValue = inputValue
        self._calculateValueText = calculateValueText
    }
    
    // 숫자 입력
    fileprivate func onNumberTapGesture(_ inputNumber: String) {
        if calculateValueText.count > 20 {
            calculateValueText = String(calculateValueText.prefix(20))
        } else if calculateValueText == "" {
            inputValue += inputNumber
        }
        calculateValueText += inputNumber
        inputValue = String(describing: calculate(calculateValueText))
        dotCheck = false
    }
        
    // 연산자 입력
    fileprivate func onOperatorTapGesture(_ operatorValue: Operator) {
        if operatorValue == Operator.dot {
            if calculateValueText != "" && calculateValueText.last != " " && calculateValueText.last != "." && calculateValueText.count < 20 && !dotCheck{
                calculateValueText += "."
                dotCheck = true
            }
        }
        else {
            if calculateValueText != "" && calculateValueText.last != " " && calculateValueText.count < 18 {
                calculateValueText += " \(operatorValue.rawValue) "
                dotCheck = false
                inputValue = String(describing: calculate(calculateValueText))
            }
        }
    }

    var body: some View {
        VStack (alignment: .trailing){
            HStack{
                Text("7")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("7")
                    }
                Text("8")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("8")
                    }
                Text("9")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("9")
                    }
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onOperatorTapGesture(Operator.plus)
                    }
            } // HStack
            HStack{
                Text("4")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("4")
                    }
                Text("5")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("5")
                    }
                Text("6")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("6")
                    }
                Image(systemName: "minus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onOperatorTapGesture(Operator.minus)
                    }
            } // HStack
            HStack{
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("1")
                    }
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("2")
                    }
                Text("3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onNumberTapGesture("3")
                    }
                Image(systemName: "multiply")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onOperatorTapGesture(Operator.multiply)
                    }
            } // HStack
            HStack{
                Text(".")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        print("calculateValueText \(calculateValueText)")
                        onOperatorTapGesture(Operator.dot)
                    }
                Text("0")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if ((calculateValueText.last != "0" || calculateValueText.count != 1) && calculateValueText.count < 20){
                            calculateValueText += "0"
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
                Image(systemName: "delete.left")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText.last == " " {
                            calculateValueText.removeLast()
                            calculateValueText.removeLast()
                            calculateValueText.removeLast()
                            inputValue = String(describing: calculate(calculateValueText))
                        } else {
                            if calculateValueText.count == 1 {
                                calculateValueText.removeLast()
                                inputValue = String(describing: calculate("0"))
                            } else if calculateValueText != ""{
                                calculateValueText.removeLast()
                                inputValue = String(describing: calculate(calculateValueText))
                            }
                        }
                        print(calculateValueText)
                        print("calculateValueText last \(String(describing: calculateValueText.last))")
                    }
                Image(systemName: "divide")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        onOperatorTapGesture(Operator.divide)
                    }
            } // HStack
        } // VStack
        .background(Color.white)
    } // View
}

func calculate(_ calculateValueText: String) -> String {
    let calculateValueTexts = calculateValueText.split(separator: " ").map {String($0)}
    var result = Double(calculateValueTexts[0])!
    var tempOperation = ""
    for i in 1..<calculateValueTexts.count {
        if calculateValueTexts[i] != "+" && calculateValueTexts[i] != "-" && calculateValueTexts[i] != "*" && calculateValueTexts[i] != "/" {
            switch tempOperation {
            case "+":
                result = result + Double(calculateValueTexts[i])!
            case "-":
                result = result - Double(calculateValueTexts[i])!
            case "*":
                result = result * Double(calculateValueTexts[i])!
            case "/":
                result = result / Double(calculateValueTexts[i])!
            default:
                break
            }
        } else {
            tempOperation = calculateValueTexts[i]
        }
    }
    return result.cleanValue
}

//struct CalCulateKeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalCulateKeyboardView()
//    }
//}
