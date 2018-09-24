//
//  ViewController.swift
//  BestYakuGenerator
//
//  Created by Yujiro on 2018/06/25.
//  Copyright © 2018年 Yujiro Nakanishi. All rights reserved.
//

import UIKit

extension String {
    func numberOfOccurrences(of word: String) -> Int {
        var count = 0
        var nextRange = self.startIndex..<self.endIndex
        while let range = self.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<self.endIndex
        }
        return count
    }
}

var KDB_array = ["K", "D", "B"]
var BDK_array = ["B", "D", "K"]
let dotDragon = "SP", redDragon = "RD", greenDragon = "GD"
let flower = "FL"
let flowerDouble = "[FL][FL]"

let north = "[#N]", south = "[#S]", east = "[#E]", west = "[#W]"
let wind = [north, east, west, south]
let news = north + east + west + south
let searchTile = 0
let numSearchTile = 1

class ViewController: UIViewController {

    var textFieldArray = [String]()
    var mytileArray = [[String]]()
    var YakuList : [String] = []
    var filteredYakuList = [String]()
    
    @IBOutlet weak var yakuTileTextField: UITextField!
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let text = (yakuTileTextField.text!).uppercased()
        mytileArray = []
        textFieldArray = text.components(separatedBy: " ")
        print("textFieldArray : \(textFieldArray)")
        for searchStr in textFieldArray {
            mytileArray.append(searchStr.components(separatedBy: "_"))
        }
        
        // ------ actual filtering ------
        var origYakuList = YakuList
        //var origYakuList = ["K1K1", "SPSP", "K1SP"]
        
        //print("origYakuList : \(origYakuList)")
        
        for searchSetArr in mytileArray {

            var tempList = [String]()
            
            //print(searchSetArr)
            if searchSetArr[numSearchTile].contains("!"){
                //print("this search option is exact")
                let n = Int(searchSetArr[numSearchTile].prefix(1))!
                
                for yaku in origYakuList {
                    if yaku.numberOfOccurrences(of: searchSetArr[searchTile]) == n {
                        tempList.append(yaku)
                    }
                }
            } else {
                //print("this search option is more than or equal to")
                let n = Int(searchSetArr[numSearchTile])!
                
                for yaku in origYakuList {
                    if yaku.numberOfOccurrences(of: searchSetArr[searchTile]) >= n {
                        tempList.append(yaku)
                    }
                }
            }
            
            origYakuList = tempList // renew origYakuList
            
        }
        
        filteredYakuList = origYakuList
        
        if !filteredYakuList.isEmpty {
            for yaku in filteredYakuList {
                print(yaku)
            }
        } else {
            print("No matching result found")
        }
        
        print(String(repeating: "-*- ", count: 15))
        
        let mySegue = segue.destination as! TableViewController
        mySegue.YakuList = filteredYakuList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _2018(list: &YakuList)
        _2468(list: &YakuList)
        _anyLikeNumbers(list: &YakuList)
        _additionHands(list: &YakuList)
        _quints(list: &YakuList)
        _consecutiveRun(list: &YakuList)
        _13579(list: &YakuList)
        _winds_dragons(list: &YakuList)
        _369(list: &YakuList)
        _singlesAndPairs(list: &YakuList)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shiftArray(arrayToShift arr : inout [String], shiftIndex idx: Int) {
        var newArr = arr[idx..<arr.count]
        newArr += arr[0..<idx]
        arr = Array(newArr)
    }
    
    func converter(tile: String) -> String {
        guard tile == "KD" || tile == "BD"
            || tile == "DD" || tile == "FL" else { return tile}
        
        switch tile {
        case "KD":
            return redDragon
        case "BD":
            return greenDragon
        case "DD":
            return dotDragon
        case "FL":
            return flower
        default:
            return ""
        }
    }
    
    // ３種類の牌（数字やドラゴンなど）を受け取る。
    // 牌に属性を割り当てたあと、属性の配列であるrefArrをシフトさせて繰り返す。
    func type1Combo(tiles: [String], list: inout [String], refArr ref: inout [String]) {
        
        for _ in 0..<ref.count {
            var yaku = String()
            
            for letter in tiles[0] {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[0] + String(letter)))
                } else {
                    yaku += " "
                }
            }
            yaku += " "
            
            for letter in tiles[1] {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[1] + String(letter)))
                } else {
                    yaku += " "
                }
            }
            yaku += " "
            
            for letter in tiles[2] {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[2] + String(letter)))
                } else {
                    yaku += " "
                }
            }
            
            list.append(yaku)
            
            // 配列をシフト
            shiftArray(arrayToShift: &ref, shiftIndex: 1)
        }
    }
    
    // type1Comboの配列シフトが無いバージョン
    func type2Combo(tiles: [String], list: inout [String], refArr ref: inout [String]) {
        var yaku = String()
        
        for letter in tiles[0] {
            if letter == "F" {
                yaku += bracket(tile: flower)
            } else if letter != " " {
                yaku += bracket(tile: converter(tile: ref[0] + String(letter)))
            } else {
                yaku += " "
            }
        }
        yaku += " "
        
        for letter in tiles[1] {
            if letter == "F" {
                yaku += bracket(tile: flower)
            } else if letter != " " {
                yaku += bracket(tile: converter(tile: ref[1] + String(letter)))
            } else {
                yaku += " "
            }
        }
        yaku += " "
        
        for letter in tiles[2] {
            if letter == "F" {
                yaku += bracket(tile: flower)
            } else if letter != " " {
                yaku += bracket(tile: converter(tile: ref[2] + String(letter)))
            } else {
                yaku += " "
            }
        }
        
        list.append(yaku)
    }
    
    // １つの牌を受け取ったあと、３種類の属性を割り当てる。
    func type3Combo(tiles: String, list: inout [String], refArr ref: [String]) {
        for i in 0..<ref.count {
            var yaku = String()
            for letter in tiles {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter == "N" || letter == "E" || letter == "W" || letter == "S" {
                    switch letter {
                    case "N": yaku += north
                    case "E": yaku += east
                    case "W": yaku += west
                    case "S": yaku += south
                    default : yaku += ""
                    }
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[i] + String(letter)))
                } else {
                    yaku += " "
                }
            }
            list.append(yaku)
        }
    }
    
    // ３種類の属性のうち、２種類を受け取った牌に割り当てる。
    // 割り当てたあと、属性配列をシフトさせて繰りかえす。
    func type4Combo(tiles: [String], list: inout [String], refArr ref: inout [String]) {
        
        for _ in 0..<ref.count {
            var yaku = String()
            for letter in tiles[0] {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[0] + String(letter)))
                } else { yaku += " " }
            }
            yaku += " "
            
            for letter in tiles[1] {
                if letter == "F" {
                    yaku += bracket(tile: flower)
                } else if letter != " " {
                    yaku += bracket(tile: converter(tile: ref[1] + String(letter)))
                } else { yaku += " " }
            }
        
            list.append(yaku)
            shiftArray(arrayToShift: &ref, shiftIndex: 1)
        }
    }
    
    func bracket( tile: String) -> String {
        guard tile != " " else { return " "}
        return "[" + tile + "]"

    }
    
    func bracketForYaku( str: String) -> String {
        var tmp = String()
        var result = String()
        var myInt = 0
        for letter in str {
            if myInt % 2 != 0 {
                tmp += String(letter)
                result += bracket(tile: tmp)
            } else {
                tmp = String(letter)
            }
            myInt += 1
        }
        
        return(result)
    }
    
//    func bracketToEach( yaku: String) -> String {
//        var result = String()
//
//        for letter in yaku {
//            result += bracket(tile: String(letter))
//        }
//
//        return result
//    }
    
    func _2018(list: inout [String]){
        // 222 000 1111 8888 (Any 3 Suits)
        _22200011118888(list: &list)
        
        // FF 2018 1111 1111 (Any 3 Suits, Kongs 1/2/8)
        _FF201811111111(list: &list)
        
        // FFFF 2222 0000 18 (Any 1 Suit)
        _FFFF2222000018(list: &list)
        
        // 22 000 NEWS 111 88 (Any 1 Suit)
        _22000NEWS11188(list: &list)
    }
    
    func _22200011118888(list: inout [String]) {
        var tempArray = [String]()
        type1Combo(tiles: ["222","1111","8888"], list: &tempArray, refArr: &KDB_array)
        type1Combo(tiles: ["222","1111","8888"], list: &tempArray, refArr: &BDK_array)
        for yaku in tempArray {
            list.append( yaku + " " + String(repeating: bracket(tile: dotDragon), count: 3))
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF201811111111(list: inout [String]) {
        list.append( "[FL][FL] [K2][SP][K1][K8] [D1][D1][D1][D1] [B1][B1][B1][B1]")
        list.append( "[FL][FL] [K2][SP][K1][K8] [D2][D2][D2][D2] [B2][B2][B2][B2]")
        list.append( "[FL][FL] [K2][SP][K1][K8] [D8][D8][D8][D8] [B8][B8][B8][B8]")
        list.append( "[FL][FL] [D2][SP][D1][D8] [K1][K1][K1][K1] [B1][B1][B1][B1]")
        list.append( "[FL][FL] [D2][SP][D1][D8] [K2][K2][K2][K2] [B2][B2][B2][B2]")
        list.append( "[FL][FL] [D2][SP][D1][D8] [K8][K8][K8][K8] [B8][B8][B8][B8]")
        list.append( "[FL][FL] [B2][SP][B1][B8] [D1][D1][D1][D1] [K1][K1][K1][K1]")
        list.append( "[FL][FL] [B2][SP][B1][B8] [D2][D2][D2][D2] [K2][K2][K2][K2]")
        list.append( "[FL][FL] [B2][SP][B1][B8] [D8][D8][D8][D8] [K8][K8][K8][K8]")
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF2222000018(list: inout [String]) {
        var temp = [String]()
        type3Combo(tiles: "FFFF 2222 18", list: &temp, refArr: KDB_array)
        for yaku in temp {
            let yaku1 = String(repeating: bracket(tile: dotDragon), count: 4)
            list.append(yaku + " " + yaku1)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }

    func _22000NEWS11188(list: inout [String]) {
        var temp = [String]()
        type3Combo(tiles: "22 000 111 88", list: &temp, refArr: KDB_array)
        for yaku in temp {
            list.append(yaku + " " + news)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _2468(list: inout [String]) {
        // FFF 22 44 666 8888 (Any 1 Suit)
        _FFF22446668888(list: &list)
        
        // 2222 44 6666 88 88 (Any 3 Suits)
        _22224466668888(list: &list)
        
        // 22 44 666 888 DDDD (Any 3 Suits)
        _2244666888DDDD(list: &list)
        
        // 2222 4444 6666 88 (Any 1 Suit)
        _22224444666688(list: &list)
        
        // 222 444 6666 8888 (Any 2 Suits)
        _22244466668888(list: &list)
        
        // 222 444 666 888 DD (Any 1 Suit)
        _222444666888DD(list: &list)
    }
    
    func _FFF22446668888(list: inout [String]) {
        type3Combo(tiles: "FFF 22 44 666 8888", list: &list, refArr: KDB_array)
        list.append( String(repeating: "*** ", count: 15))
    }
    
    func _22224466668888(list: inout [String]) {
        type1Combo(tiles: ["2222 44 6666","88","88"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["2222 44 6666","88","88"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _2244666888DDDD(list: inout [String]) {
        type1Combo(tiles: ["22 44","666 888", "DDDD"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["22 44","666 888", "DDDD"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _22224444666688(list: inout [String]) {
        type3Combo(tiles: "2222 4444 6666 88", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _22244466668888(list: inout [String]) {
        type4Combo(tiles: ["222 444", "6666 8888"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["222 444", "6666 8888"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _222444666888DD(list: inout [String]) {
        type3Combo(tiles: "222 444 666 888 DD", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _anyLikeNumbers(list: inout [String]) {
        // FF 1111 DDDD 1111 (Any 3 Suits)
        _FF1111DDDD1111(list: &list)
        
        // FFF 1111 FFF 1111 (Any 2 Suits)
        _FFF1111FFF1111(list: &list)
        
        // 11 DD 111 DDD 1111 (Any 3 Suits)
        _11DD111DDD1111(list: &list)
    }
    
    func _FF1111DDDD1111(list: inout [String]) {
        var temp = [String]()
        
        for i in 1...9 {
            let tileNum = String(repeating: String(i), count: 4)
            type1Combo(tiles: [tileNum, "DDDD", tileNum], list: &temp, refArr: &KDB_array)
            // type1Combo(tiles: [tileNum, "DDDD", tileNum], list: &temp, refArr: &BDK_array)
        }
        
        for yaku in temp {
            list.append( flowerDouble + " " + yaku)
        }
        
        list.append( String(repeating: "-*- ", count: 15))
    }

    func _FFF1111FFF1111(list: inout [String]) {
        for i in 1...9 {
            let tileNum = String(repeating: String(i), count: 4)
            let yaku = "FFF " + tileNum
            type4Combo(tiles: [yaku, yaku], list: &list, refArr: &KDB_array)
            type4Combo(tiles: [yaku, yaku], list: &list, refArr: &BDK_array)
        }
        
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11DD111DDD1111(list: inout [String]) {
        for i in 1...9 {
            let tileNum_2 = String(repeating: String(i), count: 2)
            let tileNum_3 = String(repeating: String(i), count: 3)
            let tileNum_4 = String(repeating: String(i), count: 4)
            let yaku1 = tileNum_2 + " DD"
            let yaku2 = tileNum_3 + " DDD"
            
            type1Combo(tiles: [yaku1, yaku2, tileNum_4], list: &list, refArr: &KDB_array)
            type1Combo(tiles: [yaku1, yaku2, tileNum_4], list: &list, refArr: &BDK_array)
        }
        
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _additionHands(list: inout [String]) {
        _FFFF3333999912_type1(list: &list)
        _FFFF3333999912_type2(list: &list)
        _FFFF4444888812_type1(list: &list)
        _FFFF4444888812_type2(list: &list)
        _FFFF5555777712_type1(list: &list)
        _FFFF5555777712_type2(list: &list)
    }
    
    func _FFFF3333999912_type1(list: inout [String]) {
        type1Combo(tiles: ["3333", "9999", "12 FFFF"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["3333", "9999", "12 FFFF"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF3333999912_type2(list: inout [String]) {
        type3Combo(tiles: "3333 9999 12 FFFF", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF4444888812_type1(list: inout [String]) {
        type1Combo(tiles: ["4444", "8888", "12 FFFF"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["4444", "8888", "12 FFFF"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF4444888812_type2(list: inout [String]) {
        type3Combo(tiles: "4444 8888 12 FFFF", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF5555777712_type1(list: inout [String]) {
        type1Combo(tiles: ["5555", "7777", "12 FFFF"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["5555", "7777", "12 FFFF"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFF5555777712_type2(list: inout [String]) {
        type3Combo(tiles: "5555 7777 12 FFFF", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }

    func _quints(list: inout [String]) {
        _NNNNNDDDD11111(list: &list) // Quint Any Wind & Any No. in Any Suit. Long Any Dragon
        _FF333336699999(list: &list) // Any 1 Suit
        _11231111111111(list: &list) // Any 3 Consec #'s
        _11111223344444(list: &list) // Any 1 Suit, 3 Consec #'s
    }
    
    func _NNNNNDDDD11111(list: inout [String]) {
        for i in 1...9 {
            for myWind in wind {
                var temp = [String]()
                let tileNum = String(repeating: String(i), count: 5)
                let tileWind = String(repeating: myWind, count: 5)
                type4Combo(tiles: ["DDDD", tileNum], list: &temp, refArr: &KDB_array)
                type4Combo(tiles: ["DDDD", tileNum], list: &temp, refArr: &BDK_array)
                for yaku in temp {
                    list.append(tileWind + " " + yaku)
                }
            }
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF333336699999(list: inout [String]) {
        type3Combo(tiles: "FF 33333 66 99999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11231111111111(list: inout [String]) {
        for i in 1...7 {
            let quatro = String(i) + String(i) + String(i+1) + String(i+2)
            let quint = String(repeating: String(i), count: 5)
            type1Combo(tiles: [quatro, quint, quint], list: &list, refArr: &KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11111223344444(list: inout [String]) {
        for i in 1...6 {
            let quint1 = String(repeating: String(i), count: 5)
            let quint2 = String(repeating: String(i+3), count: 5)
            let pair1 = String(repeating: String(i+1), count: 2)
            let pair2 = String(repeating: String(i+2), count: 2)
            let yaku = quint1 + " " + pair1 + " " + pair2 + " " + quint2
            type3Combo(tiles: yaku, list: &list, refArr: KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _consecutiveRun(list: inout [String]) {
        _11223334445555(list: &list) // Any 1 Suit
        _11122233334444(list: &list) // Any 2 Suits, Any 4 Consec. #'s
        _FF11112222DDDD(list: &list) // Any 1 Suit, Any 2 Consec. #'s
        _11223344445555(list: &list) // Any 3 Suits, Any 5 Consec. #'s
        _FF111122223333(list: &list) // Any Run
        _11112223333DDD(list: &list) // Any 2 Suits, Any 3 Consec. #'s, Pung & Dragon Match
        _FF111222111222(list: &list) // Any 2 Suits, Any 2 Consec. #'s
    }
    
    func _11223334445555(list: inout [String]) {
        type3Combo(tiles: "11 22 333 444 5555", list: &list, refArr: KDB_array)
        type3Combo(tiles: "55 66 777 888 9999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11122233334444(list: inout [String]) {
        for i in 1...6 {
            let trio1 = String(repeating: String(i), count: 3)
            let trio2 = String(repeating: String(i+1), count: 3)
            let quatro1 = String(repeating: String(i+2), count: 4)
            let quatro2 = String(repeating: String(i+3), count: 4)
            let yaku1 = trio1 + " " + trio2
            let yaku2 = quatro1 + " " + quatro2
            type4Combo(tiles: [yaku1, yaku2], list: &list, refArr: &KDB_array)
            type4Combo(tiles: [yaku1, yaku2], list: &list, refArr: &BDK_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF11112222DDDD(list: inout [String]) {
        for i in 1...8 {
            let quatro1 = String(repeating: String(i), count: 4)
            let quatro2 = String(repeating: String(i+1), count: 4)
            let yaku = "FF " + quatro1 + " " + quatro2 + " DDDD"
            type3Combo(tiles: yaku, list: &list, refArr: KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11223344445555(list: inout [String]) {
        for i in 1...5 {
            let pair1 = String(repeating: String(i), count: 2)
            let pair2 = String(repeating: String(i+1), count: 2)
            let pair3 = String(repeating: String(i+2), count: 2)
            let quatro1 = String(repeating: String(i+3), count: 4)
            let quatro2 = String(repeating: String(i+4), count: 4)
            let partialYaku = pair1 + pair2 + pair3
            
            type1Combo(tiles: [partialYaku, quatro1, quatro2], list: &list, refArr: &KDB_array)
            type1Combo(tiles: [partialYaku, quatro1, quatro2], list: &list, refArr: &BDK_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF111122223333(list: inout [String]) {
        for i in 1...7 {
            let quatro1 = String(repeating: String(i), count: 4)
            let quatro2 = String(repeating: String(i+1), count: 4)
            let quatro3 = String(repeating: String(i+2), count: 4)
            let yaku = "FF " + quatro1 + " " + quatro2 + " " + quatro3
            type3Combo(tiles: yaku, list: &list, refArr: KDB_array)
            type1Combo(tiles: ["FF " + quatro1, quatro2, quatro3], list: &list, refArr: &KDB_array)
            type1Combo(tiles: ["FF " + quatro1, quatro2, quatro3], list: &list, refArr: &BDK_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }

    func _11112223333DDD(list: inout [String]) {
        for i in 1...7 {
            let quatro1 = String(repeating: String(i), count: 4)
            let quatro2 = String(repeating: String(i+2), count: 4)
            let trio = String(repeating: String(i+1), count: 3)
            let partialYaku1 = quatro1 + " " + quatro2
            let partialYaku2 = trio + " DDD"
            
            type4Combo(tiles: [partialYaku1, partialYaku2], list: &list, refArr: &KDB_array)
            type4Combo(tiles: [partialYaku1, partialYaku2], list: &list, refArr: &BDK_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF111222111222(list: inout [String]) {
        for i in 1...8 {
            let trio1 = String(repeating: String(i), count: 3)
            let trio2 = String(repeating: String(i+1), count: 3)
            let trioCons = trio1 + " " + trio2
            
            type4Combo(tiles: ["FF " + trioCons, trioCons], list: &list, refArr: &KDB_array)
            type4Combo(tiles: ["FF " + trioCons, trioCons], list: &list, refArr: &BDK_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _13579(list: inout [String]) {
        _11335557779999(list: &list) // Any 1 Suit
        _11133333335555(list: &list) // Any 2 Suits
        _55577777779999(list: &list) // Any 2 Suits
        _FF111133335555(list: &list) // Any 1 Suit
        _FF555577779999(list: &list) // Any 1 Suit
        _11113335555DDD(list: &list) // Any 2 Suits
        _55557779999DDD(list: &list) // Any 2 Suits
        _FFF1111FFF5555(list: &list) // Any 1 Suits
        _FFF5555FFF9999(list: &list) // Any 1 Suits
        _11335577779999(list: &list) // Any 3 Suits
        _FF111333555DDD(list: &list) // Any 1 Suits
    }
    
    func _11335557779999(list: inout [String]) {
        type3Combo(tiles: "11 33 555 777 9999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11133333335555(list: inout [String]) {
        type4Combo(tiles: ["111 333", "3333 5555"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["111 333", "3333 5555"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _55577777779999(list: inout [String]) {
        type4Combo(tiles: ["555 777", "7777 9999"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["555 777", "7777 9999"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF111133335555(list: inout [String]) {
        type3Combo(tiles: "FF 1111 3333 5555", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF555577779999(list: inout [String]) {
        type3Combo(tiles: "FF 5555 7777 9999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
 
    func _11113335555DDD(list: inout [String]) {
        type4Combo(tiles: ["1111 5555", "333 DDD"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["1111 5555", "333 DDD"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _55557779999DDD(list: inout [String]) {
        type4Combo(tiles: ["5555 9999", "777 DDD"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["5555 9999", "777 DDD"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFF1111FFF5555(list: inout [String]) {
        type3Combo(tiles: "FFF 1111 FFF 5555", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFF5555FFF9999(list: inout [String]) {
        type3Combo(tiles: "FFF 5555 FFF 9999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _11335577779999(list: inout [String]) {
        type1Combo(tiles: ["11 33 55", "7777", "9999"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["11 33 55", "7777", "9999"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF111333555DDD(list: inout [String]) {
        type3Combo(tiles: "FF 111 333 555 DDD", list: &list, refArr: KDB_array)
        type3Combo(tiles: "FF 555 777 999 DDD", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _winds_dragons(list: inout [String]) {
        _FFFFNNNNDDSSSS(list: &list)
        _FFFFEEEEDDWWWW(list: &list)
        _NNNNEEEEWWWWSS(list: &list)
        _FFDDDDNEWSDDDD(list: &list)
        _NNNN111111SSSS(list: &list)
        _EEEE222222WWWW(list: &list)
        _FFNNNEEEWWWSSS(list: &list)
    }
    
    func _FFFFNNNNDDSSSS(list: inout [String]) {
        type3Combo(tiles: "FFFF NNNN DD SSSS", list: &list, refArr: ["K"])
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFFFEEEEDDWWWW(list: inout [String]) {
        type3Combo(tiles: "FFFF EEEE DD WWWW", list: &list, refArr: ["B"])
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _NNNNEEEEWWWWSS(list: inout [String]) {
        type3Combo(tiles: "NNNN EEEE WWWW SS", list: &list, refArr: ["K"])
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFDDDDNEWSDDDD(list: inout [String]) {
        var temp = [String]()
        type4Combo(tiles: ["FF DDDD", "DDDD"], list: &temp, refArr: &KDB_array)
        for yaku in temp {
            list.append(yaku + " " + news)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _NNNN111111SSSS(list: inout [String]) {
        let partialYaku = String(repeating: north, count: 4) + " " +
                          String(repeating: south, count: 4)
        var temp = [String]()
        
        for i in 1...9 where i % 2 == 1 {
            let pair = String(repeating: String(i), count: 2)
            type2Combo(tiles: [pair,pair,pair], list: &temp, refArr: &KDB_array)
        }
        
        for yaku in temp {
            list.append( partialYaku + " " + yaku)
        }
        
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _EEEE222222WWWW(list: inout [String]) {
        let partialYaku = String(repeating: east, count: 4) + " " +
                          String(repeating: west, count: 4)
        var temp = [String]()
        
        for i in 2...8 where i % 2 == 0 {
            let pair = String(repeating: String(i), count: 2)
            type2Combo(tiles: [pair,pair,pair], list: &temp, refArr: &KDB_array)
        }
        
        for yaku in temp {
            list.append( partialYaku + " " + yaku)
        }
        
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FFNNNEEEWWWSSS(list: inout [String]) {
        type3Combo(tiles: "FF NNN EEE WWW SSS", list: &list, refArr: ["K"])
        list.append( String(repeating: "-*- ", count: 15))
    }

    func _369(list: inout [String]) {
        _FFF3366699DDDD(list: &list)
        _33366666669999(list: &list)
        _33669933333333(list: &list)
        _FF333366669999_type1(list: &list)
        _FF333366669999_type2(list: &list)
        _33336669999DDD(list: &list)
        _33369993336999(list: &list)
    }
    
    func _FFF3366699DDDD(list: inout [String]) {
        type3Combo(tiles: "FFF 33 666 99 DDDD", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _33366666669999(list: inout [String]) {
        type4Combo(tiles: ["333 666", "6666 9999"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["333 666", "6666 9999"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _33669933333333(list: inout [String]) {
        for i in 3...9 where i%3 == 0 {
            let quatro = String(repeating: String(i), count: 4)
            type1Combo(tiles: ["33 66 99", quatro, quatro], list: &list, refArr: &KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF333366669999_type1(list: inout [String]) {
        type3Combo(tiles: "FF 3333 6666 9999", list: &list, refArr: KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF333366669999_type2(list: inout [String]) {
        type1Combo(tiles: ["FF 3333", "6666", "9999"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["FF 3333", "6666", "9999"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _33336669999DDD(list: inout [String]) {
        type4Combo(tiles: ["3333 9999", "666 DDD"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["3333 9999", "666 DDD"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _33369993336999(list: inout [String]) {
        type4Combo(tiles: ["333 6 999", "333 6 999"], list: &list, refArr: &KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _singlesAndPairs(list: inout [String]) {
        _NNEEWWSS112233(list: &list)
        _FF224466882222(list: &list)
        _FF113355557799(list: &list)
        _FF1122334455DD(list: &list)
        _FF336699336699(list: &list)
        _99899887998877(list: &list)
        _FF2018DD2018DD(list: &list)
    }
    
    func _NNEEWWSS112233(list: inout [String]) {
        for i in 1...7 {
            let pair1 = String(repeating: String(i), count: 2)
            let pair2 = String(repeating: String(i+1), count: 2)
            let pair3 = String(repeating: String(i+2), count: 2)
            let partialYaku = pair1 + " " + pair2 + " " + pair3
            type3Combo(tiles: "NN EE WW SS " + partialYaku, list: &list, refArr: KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF224466882222(list: inout [String]) {
        for i in 2...8 where i%2 == 0 {
            let pair = String(repeating: String(i), count: 2)
            type1Combo(tiles: ["FF 22 44 66 88",pair,pair], list: &list, refArr: &KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF113355557799(list: inout [String]) {
        type4Combo(tiles: ["FF 11 33 55", "55 77 99"], list: &list, refArr: &KDB_array)
        type4Combo(tiles: ["FF 11 33 55", "55 77 99"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF1122334455DD(list: inout [String]) {
        for i in 1...5 {
            let pair1 = String(repeating: String(i), count: 2)
            let pair2 = String(repeating: String(i+1), count: 2)
            let pair3 = String(repeating: String(i+2), count: 2)
            let pair4 = String(repeating: String(i+3), count: 2)
            let pair5 = String(repeating: String(i+4), count: 2)
            let yaku = "FF "+pair1+" "+pair2+" "+pair3+" "+pair4+" "+pair5+" DD"
            type3Combo(tiles: yaku, list: &list, refArr: KDB_array)
        }
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF336699336699(list: inout [String]) {
        type4Combo(tiles: ["FF 33 66 99", "33 66 99"], list: &list, refArr: &KDB_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _99899887998877(list: inout [String]) {
        type1Combo(tiles: ["998", "99887", "998877"], list: &list, refArr: &KDB_array)
        type1Combo(tiles: ["998", "99887", "998877"], list: &list, refArr: &BDK_array)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
    func _FF2018DD2018DD(list: inout [String]) {
        let yaku = flowerDouble+" [K2][SP][K1][K8] [RD][RD] "+" [B2][SP][B1][B8] [GD][GD]"
        list.append( yaku)
        list.append( String(repeating: "-*- ", count: 15))
    }
    
}


