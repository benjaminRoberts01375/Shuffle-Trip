// Jan 15, 2023
// Ben Roberts


import SwiftUI

struct TripPlanner: View {
    @State var searchText: String = ""
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                RegionSelector(region: MapDetails.region2)
                    .edgesIgnoringSafeArea(.all)
                Color.clear
                    .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                    .background(BlurView(style: .systemUltraThinMaterial))
                    .ignoresSafeArea()
                    .padding(.bottom, geometry.size.height - geometry.safeAreaInsets.top/2)
                //                Text("Top safe area height: \(geometry.safeAreaInsets.top)")
                Spacer()
                BottomDrawer(height: 180, snapPoints: [180, 500, geometry.size.height], content:
                                VStack {
                    HStack {
                        
                        TextField("Search", text: $searchText)
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled(true)
                            .textContentType(.init(rawValue: ""))
                            .textContentType(.none)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .background(.gray)
                                    .opacity(0.1)
                            )
                            .cornerRadius(10)
                    }
                }
                    .padding([.leading, .bottom, .trailing], 10)
                )
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Circle()
                            .frame(width: 40)
                            .foregroundColor(.orange)
                            .shadow(radius: 5)
                            .padding(10)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct TripPlanner_Previews: PreviewProvider {
    static var previews: some View {
        TripPlanner()
    }
}


//                .searchable(text: $searchText)
