//
//  CalculateKeyboardView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/30.
//

import Foundation
import SwiftUI

struct CalCulateKeyboardView: View {
    
    @Binding var inputValue: String
    @Binding var isShowing: Bool
    @Binding var calculateValueText: String
    
    init(_ inputValue: Binding<String>, _ isShowing: Binding<Bool>, _ calculateValueText: Binding<String>) {
        self._inputValue = inputValue
        self._isShowing = isShowing
        self._calculateValueText = calculateValueText
//        sunghun = calculateValueText.split(separator: " ").map {String($0)}
    }
    
    var body: some View {
        VStack (alignment: .trailing){
            Image(systemName: "keyboard.chevron.compact.down")
                .frame(width: 100, height: 30)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
            HStack{
                Text("7")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "7"
                        }
                        calculateValueText += "7"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("8")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "8"
                        }
                        calculateValueText += "8"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("9")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "9"
                        }
                        calculateValueText += "9"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText != "" && calculateValueText.last != " " {
                            calculateValueText += " + "
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
            }
            HStack{
                Text("4")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "4"
                        }
                        calculateValueText += "4"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("5")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "5"
                        }
                        calculateValueText += "5"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("6")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "6"
                        }
                        calculateValueText += "6"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Image(systemName: "minus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText != "" && calculateValueText.last != " " {
                            print("minus ???")
                            calculateValueText += " - "
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
            }
            HStack{
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "1"
                        }
                        calculateValueText += "1"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "2"
                        }
                        calculateValueText += "2"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Text("3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText == "" {
                            inputValue += "3"
                        }
                        calculateValueText += "3"
                        inputValue = String(describing: calculate(calculateValueText))
                    }
                Image(systemName: "multiply")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        if calculateValueText != "" && calculateValueText.last != " " {
                            calculateValueText += " * "
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
            }
            HStack{
                Text(".")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onTapGesture {
                        print("calculateValueText \(calculateValueText)")
                        if calculateValueText != "" && calculateValueText.last != " " && calculateValueText.last != "."{
                            calculateValueText += "."
//                            inputValue = String(describing: calculateValueText)
                        }
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
                        if calculateValueText != "" && calculateValueText.last != " " {
                            calculateValueText += " / "
                            inputValue = String(describing: calculate(calculateValueText))
                        }
                    }
            }
        }
        .background(Color.white)
    }
}

enum Calculate {
    case plus
    case minus
    case multiply
    case divide
}

func calculate(_ calculateValueText: String) -> String {
//    let formatter = NumberFormatter()
//    formatter.minimumFractionDigits = 0
//    formatter.maximumFractionDigits = 4
//    formatter.numberStyle = .decimal
//    return formatter.string(from: result as NSNumber) ?? "n/a"
    
    let calculateValueTexts = calculateValueText.split(separator: " ").map {String($0)}
    print("test = \(calculateValueTexts)" )
    var result = Double(calculateValueTexts[0])!
    var tempOperation = ""
    for i in 1..<calculateValueTexts.count {
        print("i = \(i)")
        if calculateValueTexts[i] != "+" && calculateValueTexts[i] != "-" && calculateValueTexts[i] != "*" && calculateValueTexts[i] != "/" {
            print("if tempOperation \(tempOperation)")
            print("test[i] \(calculateValueTexts[i])")
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
            print("else tempOperation \(tempOperation)")
        }
    }

    return result.cleanValue

}

//struct CalCulateKeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalCulateKeyboardView()
//    }
//}
