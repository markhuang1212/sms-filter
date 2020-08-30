//
//  ContentView.swift
//  SMS Filter
//
//  Created by HUANGMENG on 27/8/2020.
//

import SwiftUI


class FilteredWords: ObservableObject {
    
    @Published var words: [String]
    
    init() {
        guard let data = UserDefaults(suiteName: suiteName)?.data(forKey: "words") else {
            words = [String]()
            return
        }
        
        guard let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            words = [String]()
            return
        }
        
        words = decoded
    }
}

struct ContentView: View {
    
    @AppStorage("filteredWords", store: UserDefaults(suiteName: suiteName)) var data:Data = try! JSONEncoder().encode(["退订","TD","td"])
    
    @State var isShowingSheet = false
    @State var newWord: String = ""
    
    func test() {
//        let filter = Me
    }
    
    var body: some View {
        
        var words = try! JSONDecoder().decode([String].self, from: data)
        
        NavigationView {
            List {
                ForEach(words, id: \.self){ word in
                    Text(word)
                        
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        words.remove(at: index)
                    }
                    data = try! JSONEncoder().encode(words)
                })
                    
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("SMS Filter")
            .navigationBarItems(leading: EditButton())
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button("Add Filter Item") {
                            isShowingSheet.toggle()
                        }
                        Spacer()
                    }
                }
            })
            .sheet(isPresented: $isShowingSheet, content: {
                NavigationView {
                    Form {
                        Section{
                            TextField("Word to Filter", text: $newWord)
                        }
                        Section{
                            Button("Add"){
                                words.append(newWord)
                                data = try! JSONEncoder().encode(words)
                                isShowingSheet.toggle()
                                newWord = ""
                            }
                            .disabled(newWord.isEmpty)
                            Button("Cancel"){
                                isShowingSheet.toggle()
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .navigationTitle("New Filter")
                    .navigationBarTitleDisplayMode(.inline)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
