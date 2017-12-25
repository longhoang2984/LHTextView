# LHTextView
Customize UITextView with bottom line and title floating

To detect user action please using: <br />
    <code>lhTextview.behavior = self</code>

You can use UIStoryBoard to customize your textview or using code as below:
```swift 
lhTextView.titleColor = .purple
lhTextView.activeTitleColor = .blue
lhTextView.lineViewColor = .lightGray
lhTextView.activeLineViewColor = .blue
lhTextView.errorColor = .red
lhTextView.title = "Demo"
lhTextView.placeholder = "Placeholder"
lhTextView.defaultHeight = 30
lhTextView.lineViewHeight = 1
lhTextView.isLTRLanguage = true
lhTextView.errorFont = UIFont.boldSystemFont(ofSize: 13)
lhTextView.titleFont = UIFont.italicSystemFont(ofSize: 13)
lhTextView.placeHolderFont = UIFont.systemFont(ofSize: 13)
```

Show Error:

```swift
func textViewDidChange(_ textView: UITextView) {
   if let int = Int(textView.text) {
      lhTextView.errorMsg = ""
   }else {
      lhTextView.errorMsg = "Error"
   }
}
```

***Note: Please don't use textview.delegate
