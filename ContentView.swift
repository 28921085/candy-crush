import SwiftUI

struct ContentView: View {
    @State private var m:Int=9
    @State private var n:Int=9
    var body: some View {
        Square_mn(m:$m,n:$n)
    }
}
