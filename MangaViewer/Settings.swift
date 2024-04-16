import SwiftUI



struct _SettingsView: View {
    

    @AppStorage("isAnima") var isAnima: Bool = true
    @AppStorage("isScale") var isScale: Bool = true
    @AppStorage("isOpacity") var isOpacity: Bool = true
    @AppStorage("isRotation") var isRotation: Bool = true
    @AppStorage("isLoop") var isLoop: Bool = false
    @AppStorage("isRightToLeft") var isRightToLeft: Bool = false
    @AppStorage("isTopToBottom") var isTopToBottom: Bool = false
    
    @AppStorage("serverUrl") var _serverUrl = "http://192.168.1.3:3001"
    
    
    @State private var selectedStrength = "Mild"
    let strengths = ["Mild", "Medium", "Mature"]
    
    @State var portNumber = "3001"
   
    
//    @State var ipNumber0 = "0"
//    @State var ipNumber1 = "1"
    
    @AppStorage("ipNumber0") var ipNumber0 = "0"
    @AppStorage("ipNumber1") var ipNumber1 = "1"
    
    var ipNumber0s = ["0","1","2","3","4","5","6","7","8","9"]
    var ipNumber1s = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    @EnvironmentObject var jobConnectionManager : JobConnectionManager
    
    @State var currentUrl = serverUrl
    
    var body: some View {
//        NavigationView {
            VStack{
            Form {
                Section(header: Text("当前服务IP地址和端口")) {
                    if #available(iOS 15.0, *) {
                        Text("\(currentUrl)")
                            .foregroundColor(Color(uiColor: .link))
                    } else {
                        Text("\(currentUrl)")
                            .foregroundColor(Color.blue )
                    }
                }
                Section(header: Text("设置服务IP地址和端口")) {
                    GeometryReader{ geo in
                        VStack{
                        HStack(alignment: .center, spacing: 5 ){
                            let width = ( geo.size.width - 60 ) / 5
                        Text("192")
                            .frame(width:width , height: 32)
                            .background( Color(.systemGroupedBackground) )
                            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        TextDot()
                        Text("168")
                            .frame(width:width , height: 32)
                            .background( Color(.systemGroupedBackground) )
                            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        TextDot()
                            
//                        Picker("Strength", selection: $ipNumber0 ) {
//                            ForEach( ipNumber0s , id: \.self) {
//                                                   Text("\($0)")
//                                                    .font(.body)
//                                               }
//                                           }
//                        .pickerStyle(WheelPickerStyle())
//                        .labelsHidden()
//                        .frame(width: width , height: 100 )
//                        .clipped()
                            
                            TextField("0", text: $ipNumber0 )
                                
                                .multilineTextAlignment(.center)
                                .frame(width:width , height: 32)
                                .background( Color(.systemGroupedBackground) )
                                .keyboardType(.numberPad)
                                .onReceive(ipNumber0.publisher.collect()) {
                                       self.ipNumber0 = String($0.prefix(1))
                                   }
                              
                            
                        TextDot()
                            
                            
                            TextField("0", text: $ipNumber1 )
                                
                                .multilineTextAlignment(.center)
                                .frame(width:width , height: 32)
                                .background( Color(.systemGroupedBackground) )
                                .keyboardType(.numberPad)
                                
                               
                            
//                        Picker("Strength", selection: $ipNumber1  ) {
//                            ForEach( ipNumber1s , id: \.self) {
//                                                    Text("\($0)")
//                                                        .font(.body)
//                                                }
//                                            }
//                        .pickerStyle(WheelPickerStyle())
//                        .labelsHidden()
//                        .frame(width: width , height: 100 )
//                        .clipped()
                            
                         TextColon()
                            
                        TextField("3000", text: $portNumber )
                            .multilineTextAlignment(.center)
                            .frame(width:width , height: 32)
                            .background( Color(.systemGroupedBackground) )
                            .keyboardType(.numberPad)
                            .onReceive(portNumber.publisher.collect()) {
                                self.portNumber = String($0.prefix(4))
                            }
                        }
                            
                        Divider()
                                
                        
                                HStack(alignment: .firstTextBaseline){
                                    Text("设定为新地址")
                                    Spacer()
                                }
                                .onTapGesture {
                                    _serverUrl = "http://192.168.\(ipNumber0).\(ipNumber1):\(portNumber)"
                                    serverUrl = _serverUrl
                                    currentUrl  = _serverUrl
                                    print(serverUrl)
                                    print("http://192.168.\(ipNumber0).\(ipNumber1):\(portNumber)")
                                }
                            
                          
                      
                        Divider()
                            
                     
                            HStack(alignment: .firstTextBaseline){
                                Text("将设置也传输到遥控的设备")
                                Spacer()
                            }.onTapGesture {
                                if(jobConnectionManager.connected){
                                    print("\(serverUrl)>>\(jobConnectionManager.employees.first?.displayName)")
                                    jobConnectionManager.send(serverUrl)
                                        
                                }
                            }
                            
                        
                        .padding(.bottom )
                             
                            
                        }
                       
                        
                    }
                    .frame(minHeight: 180)
                
                }
                
                
                Section(header: Text("页面特效")) {
                    Toggle(isOn: $isAnima) {
                        Text("页面切换动画")
                    }
                    Toggle(isOn: $isScale) {
                        Text("页面切换时候缩放")
                    }
                    Toggle(isOn: $isOpacity) {
                        Text("页面切换时半透明")
                    }
                    Toggle(isOn: $isRotation) {
                        Text("页面切换时候旋转")
                    }
                    Toggle(isOn: $isLoop) {
                        Text("页面无限循环")
                    }
                }
                
                Section(header: Text("阅读方向")) {
                    Toggle(isOn: $isRightToLeft) {
                        Text("从右往左阅读")
                    }
                    .onChange(of: isRightToLeft ) { value in
                        DispatchQueue.main.async {
                            if isRightToLeft && isTopToBottom {
                                isTopToBottom.toggle()
                            }
                        }
                       
                    }
                    
                    Toggle(isOn: $isTopToBottom) {
                        Text("从上往下阅读")
                    }
                    .onChange(of: isTopToBottom ) { value in
                        DispatchQueue.main.async {
                            if isRightToLeft && isTopToBottom {
                                isRightToLeft.toggle()
                            }
                        }
                       
                    }
                    
                    
                }
      
                Section(header: Text("存储设置") ) {
                    Button(action: {
                   
                    }) {
                        Text("清空页面阅读位置记录")
                    }
                    Button(action: {
                      
                    }) {
                        Text("清空图片缓存")
                    }
                }
            }
            .dismissKeyboardOnTap()
                }
            .onAppear{
                currentUrl = serverUrl
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("设置"), displayMode: .large)
//            }
        .if(isIpad){ v in
                v.navigationViewStyle(StackNavigationViewStyle())
            }
       
    }
}

struct SettingsView: View {

    @State var titleBook = ""
    @State var author = ""
    @State var isExchange: Bool = true
    @State var description = "This book is about .."
    @State var price = ""

    @State private var categoryIndex = 0
    var categorySelection = ["Action", "classic","Comic Book","Fantasy","Historical","Literary Fiction","Biographies","Essays"]


    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("General")) {
                    TextField("Title", text: $titleBook)
                    TextField("Author", text: $author)
                    Toggle(isOn: $isExchange) {
                        Text("I'm interested in an exhange")
                    }
                }

                Section() {
                    Picker(selection: $categoryIndex, label: Text("Categorie")) {
                        ForEach(0 ..< categorySelection.count) {
                            Text(self.categorySelection[$0])
                        }
                    }
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                }

                Section(header: Text("Price")) {
                    TextField("$0.00", text: $price)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button(action: {
                        print("submitted ..")
                    }) {
                        Text("Publish now")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        _SettingsView()
    }
}

