//
//  Utils.swift
//   tools class
//
//  Created by xuxihai on 2022/11/21.
//

import Foundation
import Cocoa

class Utils {
    
    static func processHandlers<T>(
        handlers: [(NSEvent) -> T?]
    ) -> ((NSEvent) -> T?) {
        func handleFn(event: NSEvent) -> T? {
            var count = 0
            for handler in handlers {
                count = count + 1
                if let result = handler(event) {
                    NSLog("result====\(result)")
                    return result
                }
            }
            NSLog("=====result=>\(count)")
            return nil
        }
        return handleFn
    }
    
    static func getScreenFromPoint(_ point: NSPoint) -> NSScreen? {
        // find current screen
        for screen in NSScreen.screens {
            if screen.frame.contains(point) {
                return screen
            }
        }
        return NSScreen.main
    }
    
    
    
    static func parseDictLine(dictfile: String, callback: (String)->Void){
        guard let fileURL = Bundle.main.path(forResource: dictfile ,ofType:"txt") else {
            fatalError("File not found:\(dictfile)")
        }
        NSLog("dict file===\(fileURL)")
        guard let reader = LineReader(path: fileURL) else {
            print("cannot open file \(dictfile)")
            return; // cannot open file
        }
        
        for line in reader {
            callback(line)
        }
    }
    
    static func sendLog(str:String){
        NSLog("sendLog str:\(str)")
        let apiurl = "https://www.75cos.com/input/set?word=\(str.URLEncodedString()!)"
        let url = URL(string: apiurl)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                NSLog("[Service] 网络出错:\(error!.localizedDescription)")
                return
            }
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    static func split( str:String, callback:(Int,String)->Void) {
        var currentChunk: String = ""
        for (index, char) in str.enumerated() {
            if char == " " || char=="\n" {
                callback(index, currentChunk)
                currentChunk = ""
            } else {
                currentChunk.append(char)
            }
        }
    }
}
