extension Double {
    var fahrenheitToCelsius: String {
        return "\(String(format: "%.1f", self - 273.15))Cº"
    }
    var metersToKilometrs: String {
        return "\(String(format: "%.1f", self/1000))км"
    }
}
