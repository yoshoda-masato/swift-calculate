//
//  ViewController.swift
//  MyCalculatorApp
//

//税込ボタン仮実装中
//税％ボタンの後に数字押すとリセットする

import UIKit

extension NSDecimalNumber {//
    var commaString: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }
}

class ViewController: UIViewController{
    
    var plusminus = false //±の切り替え
    var performingMath = false //右辺入力時の制御用
    var operation = 0 //演算子の判定用
    var secondNumber = String() //[previousNumber + "演算子"]
    var percentResult = NSDecimalNumber() //%格納用
    var equalFlag = true //=ボタン押下後のラベル表示結果制御用
    var equalFlag2 = true //=ボタンを連続で押しても何も計算がされないように制御
    var decimalFlag = true //計算結果に対して「.」を押すと「0.」にするためのフラグ
    var percentFormulaFlag = true//trueの時は式ラベル=結果ラベル,falseの時は式ラベルは計算途中のものが現れる
    var operatorCheck = true //演算子２回連続押せないように制御
    var operatorCheck2 = true//
    var plusminusFormulaFlag = false //±の式ラベルを正常化させるため
    var leftNumber = NSDecimalNumber()//演算子の前の数字(左辺の数字)
    var rightNumber = NSDecimalNumber()//入力した数字（右辺の数字）
    let tax:NSDecimalNumber = 1.1
    var taxFlag = true //true=税込計算 false=税抜計算
    var taxFormulaFlag = true //税計算時の式ラベルの表示制御
    var taxResult = NSDecimalNumber() //税計算格納用
    var taxpercentPushFlag = false //％もしくは税ボタンを押すとtrueになる。税と％の式ラベル表示結果制御用１
    var equalPushedFlag = false //=ボタンを押したかどうか判定。税と％の式ラベル表示結果制御用２
    var onlyPercentPushedFlag = false//％ボタンを押したかどうか判定。税と％の式ラベル表示結果制御用３
    var operatorPushFlag = false//演算子押下後〜＝を押すまでtrue。右辺入力時に0+数字入力をしたら式ラベルが消えてしまったため、それを制御するためのもの
    
    @IBOutlet weak var Result: UILabel! //入力した数字と計算結果表示用
    @IBOutlet weak var formula: UILabel! //式を表示
    @IBOutlet weak var taxButtonText: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Result.text = "0"
        
    }
    
    func decimalStyle(priceValue: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        if let priceValue = Double(priceValue) {
            return formatter.string(from: NSNumber(value: priceValue)) ?? "\(priceValue)"
        }
        return priceValue
    }
    
//    func decimalStyle(priceValue: NSDecimalNumber) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = ","
//        formatter.groupingSize = 3
//        if let priceValue = NSDecimalNumber(pointer: priceValue) as Optional {
//            return formatter.string(from: NSDecimalNumber(value: priceValue)) ?? "\(priceValue)"
//        }
//        return priceValue
//    }

    @IBAction func numbers(_ sender: UIButton) {//0~9までの文字
        
        decimalFlag = true

        if performingMath == true {
            if operatorCheck2 == false{
                if taxpercentPushFlag == true{
                    Result.text = String(sender.tag-1)
                    formula.text = Result.text!
                    taxpercentPushFlag = false
                    taxFlag = true
                    taxButtonText.setTitle("税込", for: .normal)
                }else{
                    
                    Result.text = Result.text! + String(sender.tag-1)
                    formula.text = formula.text! + String(sender.tag-1)
                    
                }
                
            }else{//operatorCheck2 = ture
                
                Result.text = "0"

                if Result.text != "0"{ //計算結果に表示されている数字が0でなければ、直前の数字と入力した数字をつなげる
                    if equalFlag == true{//=の前、つまり、計算の途中
                        if taxpercentPushFlag == true{
                            Result.text = String(sender.tag-1)
                            formula.text = Result.text!
                            taxpercentPushFlag = false
                            taxFlag = true
                            taxButtonText.setTitle("税込", for: .normal)
                        }else{
                            
                            Result.text = Result.text! + String(sender.tag-1)
                            formula.text = String(secondNumber) + formula.text! + String(sender.tag-1)
                            
                        }
                        
                    }
                    else { //=ボタン押した後
                        Result.text = String(sender.tag-1)
                        formula.text = String(sender.tag-1)
                        equalFlag = true
//                        taxFlag = true
//                        taxButtonText.setTitle("税込", for: .normal)
                    }
                } else { //計算結果に表示されている数字が0であれば、入力した数字に書き換える
                    Result.text = String(sender.tag-1)
                    formula.text = String(secondNumber) + String(sender.tag-1)
                }
                
            }
            
            performingMath = false
            operatorCheck2 = false
            
        }
        else {//performingMath = false
            
            if Result.text != "0" { //計算結果に表示されている数字が0でなければ、直前の数字と入力した数字をつなげる
                if equalFlag == true{//=ボタンの前
                    if taxpercentPushFlag == true{
                        if equalPushedFlag == true{
                            if onlyPercentPushedFlag == true{//計算結果に対して％を適用してかつs数字を入力した際に表示をリセットさせる
                                Result.text = String(sender.tag-1)
                                formula.text = Result.text!
                                onlyPercentPushedFlag = false
//                                taxFlag = true
//                                taxButtonText.setTitle("税込", for: .normal)
                            }else{
                                Result.text = Result.text! + String(sender.tag-1)
                                formula.text = Result.text!
                            }
                        }else{
                            Result.text = String(sender.tag-1)
                            formula.text = String(secondNumber) + Result.text!
                        }
                        taxpercentPushFlag = false
                        taxFlag = true
                        taxButtonText.setTitle("税込", for: .normal)
                    }else{
                        
                        Result.text = Result.text! + String(sender.tag-1)
                        formula.text = formula.text! + String(sender.tag-1)
                        
                    }
                    
                    
                }
                else{//=ボタンの後
                    if Result.text == "0."{
                        
                        Result.text = Result.text! + String(sender.tag-1)
                        formula.text = formula.text! + String(sender.tag-1)
                        equalFlag = true
                        
                    }else{
                        
                        Result.text = String(sender.tag-1)
                        formula.text = String(sender.tag-1)
                        equalFlag = true
                        taxFlag = true
                        taxButtonText.setTitle("税込", for: .normal)
                        
                    }
                    
                }
                
            } else { //計算結果に表示されている数字が0であれば、入力した数字に書き換える
                Result.text = String(sender.tag-1)
                if operatorPushFlag == true{//右辺入力時
                    formula.text = String(secondNumber) + Result.text!
                }
                else{
                    formula.text = String(sender.tag-1)
                }
            }
            
        }
        
        print(decimalStyle(priceValue: Result.text!))
        print(NSDecimalNumber(string: Result.text).commaString)
//        Result.text = NSDecimalNumber(string: Result.text).commaString

    }
    
    @IBAction func decimalButton(_ sender: UIButton) { //小数点ボタン
        
        if decimalFlag == false{
                   
                   Result.text = "0."
                   formula.text = "0."
                   decimalFlag = true
                   
               }

            if Result.text == "" { //空白だった時
                Result.text = "0."
            }
            else if Result.text == "+" {
                Result.text = "+"
            }
            else if Result.text == "-" {
                Result.text = "-"
            }
            else if Result.text == "×" {
                Result.text = "×"
            }
            else if Result.text == "÷" {
                Result.text = "÷"
            }
            else { //空白じゃなかった時
                if (Result.text?.contains("."))!{
                    Result.text = Result.text! + ""
                    formula.text = formula.text! + ""
                }
                else{
                    
                    Result.text = Result.text! + "."
                    formula.text = formula.text! + "."
                    
                }
        }
    }
    
    @IBAction func switchButton(_ sender: UIButton) {//±ボタン
        
        if Result.text == "0" { //0の時は何も起きない
            Result.text = "0"
        }
            else if Result.text == "+" {
                Result.text = "+"
            }
            else if Result.text == "-" {
                Result.text = "-"
            }
            else if Result.text == "×" {
                Result.text = "×"
            }
            else if Result.text == "÷" {
                Result.text = "÷"
            }
            else if Result.text == nil{
                Result.text = ""
            }
        else { //0以外の時
                if plusminus == false {//±の切り替えフラグがfalseの時。マイナスが表示される
                    if (Result.text?.contains("-"))!{
                        
                        var makeplusResult = String(Result.text!) //変数makeplusResultに上のラベルの文字を代入
                        if let range = makeplusResult.range(of: "-") { //マイナスを取るための処理
                            makeplusResult.replaceSubrange(range, with: "") //makeplusResultのマイナスを除外
                        }
                        Result.text = makeplusResult //上のラベルにマイナスを取った結果を表示させる
                        formula.text = Result.text!
                    }else{
                        
                        Result.text = "-" + Result.text! //上のラベルの数字にマイナスを追加
                        if operatorCheck2 == false{
                            formula.text = secondNumber + Result.text!//右辺入力時の処理
                        }else{
                            formula.text = Result.text! //左辺入力時の処理
                        }
                        if equalFlag == false{//計算結果に対して±ボタンを適用した時
                            
                            formula.text = Result.text!
                            
                        }
                        
                        plusminus = true //±の切り替え。次押した時にはマイナスが取れてプラスの数字になる
                        
                    }
                
            }
            else { //±の切り替えフラグがtrueの時。マイナスが取れる
                var makeplusResult = String(Result.text!) //変数makeplusResultに上のラベルの文字を代入
                if let range = makeplusResult.range(of: "-") { //マイナスを取るための処理
                    makeplusResult.replaceSubrange(range, with: "") //makeplusResultのマイナスを除外
                }
                Result.text = makeplusResult //上のラベルにマイナスを取った結果を表示させる
                if operatorCheck2 == false{
                    formula.text = secondNumber + Result.text!
                }else{
                    formula.text = Result.text!
                }
                plusminus = false //±の切り替え。次押した時にはマイナスになる
            }
        }
    }


    @IBAction func percentButton(_ sender: UIButton) { //%ボタン
        if Result.text == "0" { //0の時は何も起きない
            Result.text = "0"
        }
        else if Result.text == "+" {
            Result.text = "+"
        }
        else if Result.text == "-" {
            Result.text = "-"
        }
        else if Result.text == "×" {
            Result.text = "×"
        }
        else if Result.text == "÷" {
            Result.text = "÷"
        }
        else if Result.text == nil{
            Result.text = ""
        }
        else if Result.text != "0"{//0以外の時
            taxpercentPushFlag = true
            onlyPercentPushedFlag = true
            if equalFlag == true{ //=ボタンを押す前
                if performingMath == true {
                    formula.text = String(secondNumber) + percentResult.stringValue //
                }
                else {
                    if percentFormulaFlag == true{
                        
                        percentResult = NSDecimalNumber(string: Result.text!).dividing(by: 100) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = percentResult.stringValue//上のラベルにその結果を代入
                        formula.text = percentResult.stringValue
                        
                    }
                    else{
                        
                        percentResult = NSDecimalNumber(string: Result.text!).dividing(by: 100) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = percentResult.stringValue//上のラベルにその結果を代入
                        formula.text = String(secondNumber) + percentResult.stringValue //
                        
                    }
                    
                }
                
            }
            else { //=ボタンを押した後。つまり計算結果に対して%を適用した際,eF = false
                if performingMath == true{
                    
                   percentResult = NSDecimalNumber(string: Result.text!).dividing(by: 100) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                    Result.text = percentResult.stringValue//上のラベルにその結果を代入
                    formula.text = String(secondNumber) + percentResult.stringValue //
                    
                }
                else{//pM = false
                    
                    if percentFormulaFlag == false{
                        
                        percentResult = NSDecimalNumber(string: Result.text!).dividing(by: 100) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = percentResult.stringValue//上のラベルにその結果を代入
                        formula.text = percentResult.stringValue
                        
                    }
                    else{ //pF = true 計算結果に直接%を当てるとこの結果になる。つまり、式ラベルの表示がおかしい→一応解決。上と内容一緒だからここの条件分岐いらないのでは？
                        
                        percentResult = NSDecimalNumber(string: Result.text!).dividing(by: 100) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = percentResult.stringValue//上のラベルにその結果を代入
                        formula.text = Result.text! //
                        
                    }
                    
                }
                
                equalFlag = true
            }
        }
        
        plusminus = false //±の切り替え。次押した時にはマイナスになる
    }
    
    
    @IBAction func calculateButton(_ sender: UIButton) { //演算子の入力
             //演算子押す前の数字をpreviousNumberに代入
        if operatorCheck2 == false{
            
        }else{
            
            if performingMath == false {
                            if operatorCheck == true{
                                leftNumber = NSDecimalNumber(string: Result.text)
                                operatorCheck = false
                                taxpercentPushFlag = false
                                taxButtonText.setTitle("税込", for: .normal)
                                
                                if sender.tag == 14 { //÷を押した時
                                    Result.text = "÷" //上のラベルに表示
                                    formula.text = leftNumber.stringValue + Result.text! //式のラベルに表示
                                }
                                if sender.tag == 15 { //×を押した時
                                    Result.text = "×"
                                    formula.text = leftNumber.stringValue + "×"
                                    
                                }
                                if sender.tag == 16 { //-を押した時
                                    Result.text = "-"
                                    formula.text = leftNumber.stringValue + "-"
                                }
                                if sender.tag == 17 { //+を押した時
                                    Result.text = "+"
                                    formula.text = leftNumber.stringValue + "+"
                                
                            }
                                
                                 operation = sender.tag
                                operatorPushFlag = true
                            
                            }else{//operatorCheck = false
                                if operatorCheck2 == false{
                                    
                                    

                                }else{//operatorCheck2 = true
                                    
                                    Result.text = ""
                                    formula.text = ""
                                    
                                }
                            }
                            
            }else{//pM = true 演算子を押した後にもう一度演算子を押すと演算子が書き換わる
                
                if sender.tag == 14 { //÷を押した時
                        Result.text = "÷" //上のラベルに表示
                        formula.text = leftNumber.stringValue + Result.text! //式のラベルに表示
                    }
                    if sender.tag == 15 { //×を押した時
                        Result.text = "×"
                        formula.text = leftNumber.stringValue + "×"
                        
                    }
                    if sender.tag == 16 { //-を押した時
                        Result.text = "-"
                        formula.text = leftNumber.stringValue + "-"
                    }
                    if sender.tag == 17 { //+を押した時
                        Result.text = "+"
                        formula.text = leftNumber.stringValue + "+"
                    
                }
                operation = sender.tag
                
            }
                    
                        performingMath = true
                        plusminus = false //±の切り替え。次押した時にはマイナスになる
                        percentFormulaFlag = false
                        taxFormulaFlag = false
                        taxFlag = true
                        secondNumber = formula.text! //変数secondNumberに[previousNumber + "演算子"]を代入
                        equalFlag = true
                        equalFlag2 = true
                        plusminusFormulaFlag = true
                        decimalFlag = true
                        equalPushedFlag = false
            
        }
            
    }
    
    
    @IBAction func taxButton(_ sender: Any) {
        
        if Result.text == "0" { //0の時は何も起きない
            Result.text = "0"
        }
        else if Result.text == "+" {
            Result.text = "+"
        }
        else if Result.text == "-" {
            Result.text = "-"
        }
        else if Result.text == "×" {
            Result.text = "×"
        }
        else if Result.text == "÷" {
            Result.text = "÷"
        }
        else if Result.text == nil{
            Result.text = ""
        }else{
            taxpercentPushFlag = true
            if equalFlag == true{//＝の前
                if taxFlag == true{//税込表示
                    taxFlag = false
                    (sender as AnyObject).setTitle("税抜", for: .normal)
                    if taxFormulaFlag == true{
                        
                        taxResult = NSDecimalNumber(string: Result.text!).multiplying(by: tax) //
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = Result.text!
                        
                    }
                    else{
                        
                       taxResult = NSDecimalNumber(string: Result.text!).multiplying(by: tax) //
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = String(secondNumber) + Result.text! //
                        
                    }
                }else{//税抜表示
                    taxFlag = true
                    (sender as AnyObject).setTitle("税込", for: .normal)
                    if taxFormulaFlag == true{
                        
                        taxResult = NSDecimalNumber(string: Result.text!).dividing(by: tax) //
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = Result.text!
                        
                    }
                    else{
                        
                       taxResult = NSDecimalNumber(string: Result.text!).dividing(by: tax)//
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = String(secondNumber) + Result.text! //
                        
                    }
                    
                }
                
            }else{//＝の後
                if taxFlag == true{//税込表示
                    taxFlag = false
                    (sender as AnyObject).setTitle("税抜", for: .normal)
                    if performingMath == true{
                        
                       taxResult = NSDecimalNumber(string: Result.text!).multiplying(by: tax) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = String(secondNumber) + Result.text!
                        
                    }
                    else{//pM = false
                        
                        if taxFormulaFlag == false{
                            
                            taxResult = NSDecimalNumber(string: Result.text!).multiplying(by: tax) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                            Result.text = taxResult.stringValue//上のラベルにその結果を代入
                            formula.text = Result.text!
                            
                        }
                        else{ //pF = true 計算結果に直接%を当てるとこの結果になる。つまり、式ラベルの表示がおかしい→一応解決。上と内容一緒だからここの条件分岐いらないのでは？
                            
                            taxResult = NSDecimalNumber(string: Result.text!).multiplying(by: tax) //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                            Result.text = taxResult.stringValue//上のラベルにその結果を代入
                            formula.text = Result.text!
                            
                        }
                        
                    }
                    
                    
                }else{//税抜表示
                    taxFlag = true
                    (sender as AnyObject).setTitle("税込", for: .normal)
                    if performingMath == true{
                        
                       taxResult = NSDecimalNumber(string: Result.text!).dividing(by: tax)// //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                        Result.text = taxResult.stringValue//上のラベルにその結果を代入
                        formula.text = String(secondNumber) + Result.text!
                        
                    }
                    else{//pM = false
                        
                        if taxFormulaFlag == false{
                            
                            taxResult = NSDecimalNumber(string: Result.text!).dividing(by: tax)// //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                            Result.text = taxResult.stringValue//上のラベルにその結果を代入
                            formula.text = Result.text!
                            
                        }
                        else{ //pF = true 計算結果に直接%を当てるとこの結果になる。つまり、式ラベルの表示がおかしい→一応解決。上と内容一緒だからここの条件分岐いらないのでは？
                            
                            taxResult = NSDecimalNumber(string: Result.text!).dividing(by: tax)// //変数percentResultに上のラベルの数字を100で割った時の結果を代入
                            Result.text = taxResult.stringValue//上のラベルにその結果を代入
                            formula.text = Result.text!
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func clearButton(_ sender: UIButton) { //Cボタンを押した時
        Result.text = "0"
        formula.text = "0"
        operation = 0
        performingMath = false
        plusminus = false //±の切り替え。次押した時にはマイナスになる
        equalFlag = true
        percentFormulaFlag = true
        taxFormulaFlag = true
        operatorCheck = true
        decimalFlag = true
        equalFlag2 = true
        plusminusFormulaFlag = false
        leftNumber = 0
        rightNumber = 0
        operatorCheck2 = true
        taxFlag = true
        taxpercentPushFlag = false
        secondNumber = ""
        equalPushedFlag = false
        onlyPercentPushedFlag = false
        operatorPushFlag = false
        taxButtonText.setTitle("税込", for: .normal)
    }
    

    @IBAction func anserButton(_ sender: UIButton) { //=ボタンを押した時

        if equalFlag2 == false{
            
            Result.text = Result.text! + ""
            formula.text = formula.text! + ""
            
        }else{
            
        if Result.text == "+"||Result.text == "-"||Result.text == "÷"||Result.text == "×"{
            
            Result.text = Result.text! + ""
            formula.text = formula.text! + ""
            
        }
        else{
            
            rightNumber = NSDecimalNumber(string: Result.text!)//
            if operation == 14 { //割り算
                Result.text = leftNumber.dividing(by: rightNumber).stringValue//decimalをstringに変換
                formula.text = leftNumber.stringValue + "÷" + rightNumber.stringValue + "=" + Result.text!
            }
            if operation == 15 { //掛け算
                Result.text = leftNumber.multiplying(by: rightNumber).stringValue
                formula.text = leftNumber.stringValue + "×" + rightNumber.stringValue + "=" + Result.text!
             }
            if operation == 16 { //引き算
                 Result.text = leftNumber.subtracting(rightNumber).stringValue
                formula.text = leftNumber.stringValue + "-" + rightNumber.stringValue + "=" + Result.text!
             }
            if operation == 17 { //足し算
                 Result.text = leftNumber.adding(rightNumber).stringValue
                formula.text = leftNumber.stringValue + "+" + rightNumber.stringValue + "=" + Result.text!
             }
            
            plusminus = false //±の切り替え。次押した時にはマイナスになる
            equalFlag = false
            equalFlag2 = false
            performingMath = false
            percentFormulaFlag = true
            taxFormulaFlag = true
            operatorCheck = true
            decimalFlag = false
            plusminusFormulaFlag = false
            operatorCheck2 = true
            operation = 0
            taxFlag = true
            taxpercentPushFlag = false
            equalPushedFlag = true
            onlyPercentPushedFlag = false
            operatorPushFlag = false
            taxButtonText.setTitle("税込", for: .normal)
            
          }
        }
    }
    
    @objc func changetaxButtonText(){
        taxButtonText.setTitle("税込", for: .normal)
    }
}

