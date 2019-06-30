//
//  ContentView.swift
//  SwiftUISample
//
//  Created by 酒井邦也 on 2019/07/01.
//  Copyright © 2019 酒井邦也. All rights reserved.
//

import SwiftUI
import Combine

struct Status {
    private (set) var value = "初期値"
}

class StatusModel: BindableObject {
    
    let didChange = PassthroughSubject<Status, Never>()
    
    private (set) var state = Status()
    
    func dispatch(a: String) {
        self.state = Status(value: a)
        didChange.send(self.state)
    }
}

class ViewModel: BindableObject {
    
    let didChange = PassthroughSubject<ViewModel, Never>()
    
    var value = "初期値" {
        didSet {
            didChange.send(self)
        }
    }
}


struct ContentView : View {
    @EnvironmentObject var statusModel: StatusModel
    @ObjectBinding(initialValue: ViewModel()) var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TopLeftView(viewModel: viewModel).padding()
                    TopRightView().padding()
                    }.padding()
                HStack {
                    BottomLeftView(viewModel: viewModel).padding()
                    BottomRightView(viewModel: viewModel).padding()
                    }.padding()
            }
        }
    }
}

struct ModalFirstView: View {
    @EnvironmentObject var statusModel: StatusModel
    var body: some View {
        VStack {
            Text("Modal First \n" + self.statusModel.state.value).multilineTextAlignment(.center).padding().lineLimit(10)
            Button(action: {
                self.statusModel.dispatch(a: "さようなら")
            }) {
                Text("さようならボタン")
            }
        }
    }
}

struct ModalSecondView: View {
    @EnvironmentObject var statusModel: StatusModel
    var body: some View {
        VStack {
            Text("Modal Second \n" + self.statusModel.state.value).multilineTextAlignment(.center).padding().lineLimit(10)
            Button(action: {
                self.statusModel.dispatch(a: "おはようございます")
            }) {
                Text("おはようございますボタン")
            }
        }
    }
}

struct TopLeftView: View {
    @ObjectBinding var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Top Left \n" + self.viewModel.value).multilineTextAlignment(.center).padding().lineLimit(10)
            Button(action: {
                self.viewModel.value = "変更しました"
            }) {
                Text("右上以外変更ボタン")
            }
        }
        
    }
}

struct TopRightView: View {
    @EnvironmentObject var statusModel: StatusModel
    
    var body: some View {
        VStack {
            Text("Top Right \n" + self.statusModel.state.value).multilineTextAlignment(.center).lineLimit(10).padding()
            Button(action: {
                self.statusModel.dispatch(a: "こんにちは")
            }) {
                Text("こんにちはボタン")
            }
        }
        
    }
}

struct BottomLeftView: View {
    @EnvironmentObject var statusModel: StatusModel
    @ObjectBinding var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Bottom Left \n" + self.viewModel.value).multilineTextAlignment(.center).lineLimit(10).padding()
            PresentationButton(destination: ModalFirstView().environmentObject(statusModel)) {
                Text("モーダル1")
            }
        }
    }
}

struct BottomRightView: View {
    @EnvironmentObject var statusModel: StatusModel
    @ObjectBinding var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Bottom Right \n" + self.viewModel.value).multilineTextAlignment(.center).lineLimit(10).padding()
            PresentationButton(destination: ModalSecondView().environmentObject(statusModel)) {
                Text("モーダル2")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(StatusModel())
    }
}

struct TopLeftView_Previews: PreviewProvider {
    static var previews: some View {
        TopLeftView(viewModel: ViewModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

struct TopRightView_Previews: PreviewProvider {
    static var previews: some View {
        TopRightView().environmentObject(StatusModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

struct BottomLeftView_Previews: PreviewProvider {
    static var previews: some View {
        BottomLeftView(viewModel: ViewModel()).environmentObject(StatusModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

struct BottomRightView_Previews: PreviewProvider {
    static var previews: some View {
        BottomRightView(viewModel: ViewModel()).environmentObject(StatusModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

struct ModalFirstView_Previews: PreviewProvider {
    static var previews: some View {
        ModalFirstView().environmentObject(StatusModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

struct ModalSecondView_Previews: PreviewProvider {
    static var previews: some View {
        ModalSecondView().environmentObject(StatusModel()).previewLayout(.fixed(width: 200, height: 120))
    }
}

#endif
