//
//  NotificationView.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 24.02.2023.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVStack{
                ForEach(0..<30) { _ in
                    NotificationCell()
                      .padding(.vertical,8)
                    
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
