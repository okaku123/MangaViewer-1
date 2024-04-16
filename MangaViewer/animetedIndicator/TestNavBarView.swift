//
//  TestNavBarView.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/27.
//

import SwiftUI

struct TestNavBarView: View {
    let  testName = "(成年コミック) [師走の翁] 円光おじさん [DL版].zip"
    @State var showMenuBtn = false
    let sheetManager: PartialSheetManager = PartialSheetManager()
    var body: some View {
    
        TestDetailsView( name : testName  , showMenuBtn : $showMenuBtn )
            .environmentObject(sheetManager)
        
    }
}

struct TestNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        TestNavBarView()
    }
}
