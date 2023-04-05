// Original article here: https://www.fivestars.blog/code/section-title-index-swiftui.html

import SwiftUI

let database: [String: [String]] = [
    "iPhone": [
        "iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5C", "iPhone 5S", "iPhone 6", "iPhone 6 Plus", "iPhone 6S", "iPhone 6S Plus", "iPhone SE", "iPhone 7", "iPhone 7 Plus", "iPhone 8", "iPhone 8 Plus", "iPhone X", "iPhone Xs", "iPhone Xs Max", "iPhone Xʀ"
    ],
    "iPad": [
        "iPad", "iPad 2", "iPad 3", "iPad 4", "iPad 5", "iPad 6", "iPad 7", "iPad Air", "iPad Air 2", "iPad Air 3", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4", "iPad Mini 5", "iPad Pro 9.7-inch", "iPad Pro 10.5-inch", "iPad Pro 11-inch", "iPad Pro 11-inch 2", "iPad Pro 12.9-inch"
    ],
    "iPod": [
        "iPod Touch", "iPod Touch 2", "iPod Touch 3", "iPod Touch 4", "iPod Touch 5", "iPod Touch 6"
    ],
    "Apple TV": [
        "Apple TV 2", "Apple TV 3", "Apple TV 4", "Apple TV 4K"
    ],
    "Apple Watch": [
        "Apple Watch", "Apple Watch Series 1", "Apple Watch Series 2", "Apple Watch Series 3", "Apple Watch Series 4", "Apple Watch Series 5"
    ],
    "HomePod": [
        "HomePod"
    ]
]

struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
    }
}

struct RowView: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
}

struct ContentViewList: View {
    let devices: [String: [String]] = database
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                devicesList
            }
            .listStyle(InsetGroupedListStyle())
            .overlay(sectionIndexTitles(proxy: proxy))
        }
        .navigationBarTitle("Apple Devices")
    }
    
    var devicesList: some View {
        ForEach(devices.sorted(by: { (lhs, rhs) -> Bool in
            lhs.key < rhs.key
        }), id: \.key) { categoryName, devicesArray in
            
            HeaderView(title: categoryName)
            
            ForEach(devicesArray, id: \.self) { name in
                RowView(text: name)
            }
        }
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(proxy: proxy, titles: devices.keys.sorted())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
}

struct SectionIndexTitles: View {
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                SectionIndexTitle(image: sfSymbol(for: title))
                    .background(dragObserver(title: title))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
    }
    
    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .center)
            }
        }
        return Rectangle().fill(Color.clear)
    }
    
    func sfSymbol(for deviceCategory: String) -> Image {
        let systemName: String
        switch deviceCategory {
        case "iPhone": systemName = "iphone"
        case "iPad": systemName = "ipad"
        case "iPod": systemName = "ipod"
        case "Apple TV": systemName = "appletv"
        case "Apple Watch": systemName = "applewatch"
        case "HomePod": systemName = "homepod"
        default: systemName = "xmark"
        }
        return Image(systemName: systemName)
    }
}

struct SectionIndexTitle: View {
    let image: Image
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .foregroundColor(Color.gray.opacity(0.1))
            .frame(width: 40, height: 40)
            .overlay(
                image
                    .foregroundColor(.blue)
            )
    }
}

struct ContentViewList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentViewList()
        }
    }
}
