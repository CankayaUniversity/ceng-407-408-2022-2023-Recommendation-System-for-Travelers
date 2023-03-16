//
//  SearchView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State var inSearchMode = false
    @ObservedObject var viewModel = SearchViewModel()
    var body: some View {
  
        
        ScrollView(showsIndicators: false){
            //Search Bar
            SearchBar(text: $searchText, isEditing: $inSearchMode)
                .padding()
            //Grid View//user list view
            ZStack{
                if inSearchMode{
                    UserListView(viewModel: viewModel, searchText: $searchText)
                }else{
                    PostGridView(config: .explore)
                }
            }
         
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
