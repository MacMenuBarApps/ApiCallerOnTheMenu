import SwiftUI
import LaunchAtLogin

@main
struct MenuBarView: App {
    
    let pasteboard = NSPasteboard.general
    @State private var urlText: String = "https://httpbin.org/get"
    @State private var responseText: String = "response will be here"
    let urlRepo = URL(string: "https://github.com/liebki/ApiCallerOnTheMenu")!
    
    var body: some Scene {
        
        MenuBarExtra("", systemImage: "cloud.circle") {
  
            VStack {
                ControlGroup() {
                    Button("ACOTM V1.0") {
                        NSWorkspace.shared.open(urlRepo)
                    }
                    
                    LaunchAtLogin.Toggle {
                                Text("Launch on login")
                            }
                    
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    
                }
                
                VStack {
                    HStack {
                        
                        TextField("", text: $urlText).textFieldStyle(.roundedBorder)
                        
                        Button {
                            let url = URL(string: urlText)!
                            
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                if let data = data {
                                    responseText = String(data: data, encoding: .utf8) ?? ""
                                } else if let error = error {
                                    print("HTTP Request Failed \(error)")
                                }
                            }
                            
                            task.resume()
                        } label: {
                            Image(systemName: "play.circle")
                        }.help("Execute url and save response!")
                    }
                    
                    HStack {
                        TextField("", text: $responseText).textFieldStyle(.roundedBorder)
                        
                        Button() {
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(responseText, forType: .string)
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }.help("Copying content of execution to clipboard!")
                    }
                }
                
            }.padding()
            
        }.menuBarExtraStyle(.window)
        
    }
}
