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
    @State var operatorArr = [String]()
    @Binding var inputValue: String
    @Binding var calculateValueText: String
    
    init(_ inputValue: Binding<String>, _ calculateValueText: Binding<String>) {
        self._inputValue = inputValue
        self._calculateValueText = calculateValueText
    }
    
    // 숫자 입력
    fileprivate func onNumberTapGesture(_ inputNumber: String) {
        inputValue += inputNumber
        calculateValueText += inputNumber
        inputValue = String(describing: calculate(calculateValueText))
    }
    
    // 연산자 입력
    fileprivate func onOperatorTapGesture(_ operatorValue: Operator) {
        if operatorValue == Operator.dot {
            if calculateValueText.last != " " && operatorArr.last != "." {
                if calculateValueText != "" {
                    calculateValueText += "."
                } else {
                    calculateValueText += "0."
                }
                inputValue = String(describing: calculate(calculateValueText))
                operatorArr.append(operatorValue.rawValue)
            }
        }
        else {
            if calculateValueText != "" {
                if calculateValueText.last == "." {
                    calculateValueText += "0"
                }
                if calculateValueText.last == " " {
                    calculateValueText.removeLast(3)
                    calculateValueText += " \(operatorValue.rawValue) "
                    inputValue = String(describing: calculate(calculateValueText))
                    operatorArr.removeLast()
                    operatorArr.append(operatorValue.rawValue)
                } else {
                    calculateValueText += " \(operatorValue.rawValue) "
                    inputValue = String(describing: calculate(calculateValueText))
                    operatorArr.append(operatorValue.rawValue)
                }
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
                        onOperatorTapGesture(Operator.dot)
                    }
                Text("0")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if (calculateValueText.last != "0" || calculateValueText.count != 1){
                            calculateValueText += "0"
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
                Image(systemName: "delete.left")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText.last == " " {
                            calculateValueText.removeLast(3)
                            inputValue = String(describing: calculate(calculateValueText))
                            operatorArr.removeLast()
                        } else {
                            if calculateValueText.last == "." {
                                operatorArr.removeLast()
                            }
                            if calculateValueText.count == 1 {
                                calculateValueText.removeLast()
                                inputValue = String(describing: calculate("0"))
                            } else if calculateValueText != "" {
                                calculateValueText.removeLast()
                                inputValue = String(describing: calculate(calculateValueText))
                            }
                        }
                    }
                    .onLongPressGesture {
                        calculateValueText = ""
                        inputValue = "0"
                        operatorArr = []
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
