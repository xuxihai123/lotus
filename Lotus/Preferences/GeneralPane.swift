//
//  GeneralPane.swift
//  Lotus
//
//  Created by xuxihai on 2022/11/26.
//

import Foundation
import SwiftUI
import Preferences
import Defaults

struct GeneralPane: View {

    @Default(.codeStrategy) private var codeStrategy
    @Default(.candidateCount) private var candidateCount
    @Default(.wubiAutoCommit) private var wubiAutoCommit
    @Default(.wubiCodeTip) private var wubiCodeTip
    @Default(.showCodeInWindow) private var showCodeInWindow
    @Default(.candidatesDirection) var candidatesDirection

    var body: some View {
        Preferences.Container(contentWidth: 450.0) {
            Preferences.Section(title: "") {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Picker("编码方案", selection: $codeStrategy) {
                            Text("五笔").tag(CodingStrategy.wubi)
                            Text("拼音").tag(CodingStrategy.pinyin)
                            Text("五笔拼音混合").tag(CodingStrategy.wubiPinyin)
                        }
                        .frame(width: 180)
                        Spacer(minLength: 50)
                    }
                    HStack {
                        Toggle("满4码唯一候选词直接上屏", isOn: $wubiAutoCommit)
                        Spacer(minLength: 50)
                        Toggle("提示五笔编码", isOn: $wubiCodeTip)
                        Spacer(minLength: 50)
                    }
                    Text("候选框")
                    HStack {
                        Picker("候选词排列", selection: $candidatesDirection) {
                            Text("横向").tag(CandidatesDirection.horizontal)
                            Text("竖向").tag(CandidatesDirection.vertical)
                        }
                        Spacer(minLength: 50)
                        Picker("候选词数量", selection: $candidateCount) {
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                            Text("6").tag(6)
                            Text("7").tag(7)
                            Text("8").tag(8)
                            Text("9").tag(9)
                        }
                    }
                    HStack {
                        Toggle("候选框显示输入码", isOn: $showCodeInWindow)
                    }
                    Spacer(minLength: 20)
                }
            }
        }
    }
}

struct GeneralPane_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPane()
    }
}
