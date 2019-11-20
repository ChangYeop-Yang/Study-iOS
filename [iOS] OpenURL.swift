guard let url = URL(string: "https://www.naver.com") else { return }

if UIApplication.shared.canOpenURL(url) {
  UIApplication.shared.open(url, options: [:], completionHandler: nil)
} else {
  // Here, UIApplication.shread.open Error Source Code.
}
