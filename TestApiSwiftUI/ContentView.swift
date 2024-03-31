//
//  ContentView.swift
//  TestApiSwiftUI
//
//  Created by Sudeepa Pal on 30/03/24.
//

import SwiftUI
import Charts
struct ContentView: View {
  //  @StateObject private var viewModel = WebLinksViewModel()
    @State private var webLinksArray: [String] = []
    @State private var topLinksArray2: [String] = []
    @State private var tappedButton: Int? = nil
    
    @State private var greetingMessage: String = ""

    
    
    var body: some View {
        ZStack {
           // Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Color.blue
                .ignoresSafeArea(.all)
            
             
            
            VStack {
                
                VStack (alignment: .leading) {
                    
                    HStack {
                        
                        Text("Dashboard")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                        Button{
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 36,height: 36)
                                .foregroundStyle(Color.blue)
                                .overlay{
                                    ///Image("gear")
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    .padding()
                    .frame(height: 100)
                    
                    
                    //VStack {
                        
                        
                   // }
                    
                } .background(Color.blue)
                VStack (alignment: .center)  {
                    Text(greetingMessage)
                        .font(.system(size: 16, weight: .thin))
                    Text("Sudeepa Pal 👋🏽")
                        .font(.system(size: 24, weight: .semibold))
                    
//                    Text(greetingMessage)
//                        .font(.system(size: 20))
//                        .padding()
                    
                    HStack (alignment: .center, spacing : 10) {
                        Button(action: {
                            self.tappedButton = 1
                            //print(webLinksArray)
                        }) {
                            Text("Recent Links")
                                .padding()
                                .background(tappedButton == 1 ? Color.blue : Color.white)
                                .foregroundColor(tappedButton == 1 ? .white : .gray)
                                .cornerRadius(10)
                        }
                        
                        
                        Button(action: {
                            print("Button tapped!")
                            self.tappedButton = 2
                            //print(webLinksArray)
                        }) {
                            Text("Top Links")
                                .padding()
                                .background(tappedButton == 2 ? Color.blue : Color.white)
                                .foregroundColor(tappedButton == 2 ? .white : .gray)
                                .cornerRadius(10)
                        }
                        
                        
                    } // Hstack
                    
                    VStack  {
                        if tappedButton == 1 {
                            List(webLinksArray, id: \.self) { url in
                                Text(url)
                                    .foregroundColor(.blue)
                            }
                        } else if tappedButton == 2 {
                            List(topLinksArray2, id: \.self) { url in
                                Text(url)
                                    .foregroundColor(.blue)
                            }
                        }
                    } .frame(height: 300)
                    
                    
                    
                }.background(Color.white)
                // main vstack
            //} // Scroll view
                Spacer()
                VStack {
                    Spacer()
                    TabBarView1()
                    
                }
                
            }.background(Color.white)
                
                
            // upper vstack
            
            
            .onAppear {
                fetchDataFromAPI()
                fetchDataFromApi2()
                updateGreeting()
            }
        }
        //.frame(height: 400)
        // main Zstack
        
        }// main view
    
    
    
    
   // Functions : -
    func fetchDataFromAPI() {
        // API endpoint URL
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else {
            print("Invalid URL")
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // Extras
            print("Status Code: \(httpResponse.statusCode)")
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Parse JSON data
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ,
                   let responseData = jsonData["data"] as? [String: Any],
                   let recentLinks = responseData["recent_links"] as? [[String: Any]]
                {
                   // for top Links
                    
                    print(jsonData)
                    print("Recent Links:")
                    for link in recentLinks {
                        if let title = link["app"] as? String,
                           let webLink = link["web_link"] as? String {
                            webLinksArray.append(webLink)
                            print("Title: \(title)")
                            print("Web Link: \(webLink)")
                            print("----------")
                        }
                    }
                    
                    
                    
                    
                    
                    print("Recent Links: \(webLinksArray)")
                } else {
                    print("Recent links not found in JSON")
                }// json parsing
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            greetingMessage = "Good Morning"
        case 12..<17:
            greetingMessage = "Good Afternoon"
        case 17..<21:
            greetingMessage = "Good Evening"
        default:
            greetingMessage = "Good Night"
        }
    }
    
    
    func fetchDataFromApi2() {
        // API endpoint URL
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else {
            print("Invalid URL")
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // Extras
            print("Status Code: \(httpResponse.statusCode)")
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Parse JSON data
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ,
                   let responseData = jsonData["data"] as? [String: Any],
                   let recentLinks = responseData["top_links"] as? [[String: Any]]
                {
                   // for top Links
                    
                    print(jsonData)
                    print("Toppp Links:")
                    for link in recentLinks {
                        if let title = link["app"] as? String,
                           let webLink = link["web_link"] as? String {
                            topLinksArray2.append(webLink)
                            print("Title: \(title)")
                            print("Web Link: \(webLink)")
                            print("----------")
                        }
                    } 
                    print("Recent Links: \(topLinksArray2)")
                } else {
                    print("Recent links not found in JSON")
                }// json parsing
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home, game, plus, apps, movie
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "link"
        case .game:
            return "book.fill"
        case .plus:
            return "plus"
        case .apps:
            return "speaker.fill"
        case .movie:
            return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .game:
            return "Games"
        case .plus:
            return "Plus"
        case .apps:
            return "Apps"
        case .movie:
            return "Movies"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .blue
        case .game:
            return .blue
        case .plus:
            return .blue
        case .apps:
            return .blue
        case .movie:
            return .blue
        }
    }
}


#Preview {
    ContentView()
}
