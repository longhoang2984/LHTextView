//
//  LHTextView.swift
//  LHTextView
//
//  Created by Hoàng Cửu Long on 12/25/17.
//  Copyright © 2017 Long Hoàng. All rights reserved.
//

import UIKit
import Foundation

@objc protocol LHTextViewDelegate : class, UIScrollViewDelegate {
    @objc @available(iOS 2.0, *)
    optional func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    
    @objc @available(iOS 2.0, *)
    optional func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidBeginEditing(_ textView: UITextView)
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidEndEditing(_ textView: UITextView)
    
    
    @objc @available(iOS 2.0, *)
    optional  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidChange(_ textView: UITextView)
    
    
    @objc @available(iOS 2.0, *)
    optional func textViewDidChangeSelection(_ textView: UITextView)
    
    
    @objc @available(iOS 10.0, *)
    optional func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    
    @objc @available(iOS 10.0, *)
    optional func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    
    
    @objc @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    optional func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    
    @objc @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    optional func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool
}

@IBDesignable
class LHTextView: UITextView, UITextViewDelegate {
    
    fileprivate var height: NSLayoutConstraint!
    fileprivate var topOfContainerView: CGFloat = 20
    weak open var behavior: LHTextViewDelegate?
    
    @IBInspectable var defaultHeight: CGFloat = 30 {
        didSet {
            self.height.constant = defaultHeight + topOfContainerView
            resizeTextView()
            resizeLineView()
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = 1 {
        didSet {
            resizeLineView()
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            //            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var titleColor: UIColor = .lightGray {
        didSet {
//            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var activeTitleColor: UIColor = .black {
        didSet {
//            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = .lightGray {
        didSet {
            //            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var errorColor: UIColor = .red {
        didSet {
            //            self.resizePlaceholder()
        }
    }
    
    @IBInspectable var lineViewColor: UIColor = .lightGray {
        didSet {
            
        }
    }
    
    @IBInspectable var activeLineViewColor: UIColor = .black {
        didSet {
            
        }
    }
    
    @IBInspectable var placeHolderFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            
        }
    }
    
    @IBInspectable var titleFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            
        }
    }
    
    @IBInspectable var errorFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            
        }
    }
    
    var errorMsg: String = "" {
        didSet {
            if errorMsg.isEmpty {
                let isRsp = self.isFirstResponder
                if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                    if self.text.count.hashValue > 0 {
                        placeholderLabel.frame.origin.y = self.textContainerInset.top - self.topOfContainerView
                        isRsp ? self.setActiveTitle(placeholderLabel) : self.setTitle(placeholderLabel)
                    }else {
                        placeholderLabel.frame.origin.y = self.textContainerInset.top
                        self.setPlaceHolder(placeholderLabel)
                    }
                }
            }else {
                if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                    placeholderLabel.frame.origin.y = self.textContainerInset.top - self.topOfContainerView
                    placeholderLabel.textColor = self.errorColor
                    placeholderLabel.text = errorMsg
                    placeholderLabel.font = errorFont
                }
            }
        }
    }
    
    fileprivate var lineView: UIView = UIView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setUpLHTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpLHTextView()
    }
    
    fileprivate func setUpLHTextView() {
        self.delegate = self
        self.textContainerInset.top = self.topOfContainerView
        self.textContainerInset.bottom = 5
        self.translatesAutoresizingMaskIntoConstraints = false
        height = self.heightAnchor.constraint(equalToConstant: defaultHeight + topOfContainerView)
        height.isActive = true
        resizeTextView()
        
//        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        lineView.backgroundColor = .lightGray
        lineView.layer.zPosition = 1
        resizeLineView()
    }
    
    fileprivate func resizeTextView() {
        self.frame.size.height = self.frame.height + self.topOfContainerView
    }
    
    fileprivate func resizeLineView() {
        let labelX = self.textContainer.lineFragmentPadding
        let labelWidth = self.frame.width - (labelX)
        lineView.frame = CGRect(x: labelX,y: height.constant - lineHeight, width: labelWidth,height: lineHeight)
        originalBorderFrame  = CGRect(x: labelX,y: frame.height-lineView.frame.height,width: labelWidth,height: lineHeight)
    }
    
    var originalBorderFrame: CGRect = .zero
    var originalInsetBottom: CGFloat = 0
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override var frame: CGRect {
        didSet {
            let labelX = self.textContainer.lineFragmentPadding
            let labelWidth = self.frame.width - (labelX)
            lineView.frame = CGRect(x: labelX,y: frame.height+contentOffset.y-lineHeight,width: labelWidth,height: lineHeight)
            originalBorderFrame  = CGRect(x: labelX,y: frame.height-lineHeight,width: labelWidth,height: lineHeight)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            lineView.frame = originalBorderFrame.offsetBy(dx: 0, dy: contentOffset.y)
            
        }
    }
    
    override open var bounds: CGRect {
        
        didSet {
            
            self.resizePlaceholder()
            
        }
        
    }
    
    open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
            updateTextAligment()
        }
    }
    
    fileprivate func updateTextAligment() {
        if isLTRLanguage {
            textAlignment = .left
        } else {
            textAlignment = .right
        }
    }
    
    /// The UITextView placeholder text
    @IBInspectable
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }

        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }


    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text

    private func resizePlaceholder() {

        if let placeholderLabel = self.viewWithTag(100) as? UILabel {

            let labelX = self.textContainer.lineFragmentPadding

            let labelY = self.textContainerInset.top

            let labelWidth = self.frame.width - (labelX)

            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.textColor = .lightGray

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)

        }

    }



    /// Adds a placeholder UILabel to this UITextView

    private func addPlaceholder(_ placeholderText: String) {

        let placeholderLabel = UILabel()

        placeholderLabel.font = self.font

        placeholderLabel.text = placeholderText

        placeholderLabel.sizeToFit()



        placeholderLabel.font = self.font

        placeholderLabel.textColor = .lightGray

        placeholderLabel.tag = 100
        
        self.addSubview(placeholderLabel)

        self.resizePlaceholder()

    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.errorMsg = ""
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            if self.text.count.hashValue > 0 {
                placeholderLabel.frame.origin.y = self.textContainerInset.top - self.topOfContainerView
                self.setActiveTitle(placeholderLabel)
            }else {
                placeholderLabel.frame.origin.y = self.textContainerInset.top
                self.setPlaceHolder(placeholderLabel)
            }
        }
        behavior?.textViewDidChange?(self)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            if self.text.count.hashValue > 0 {
                self.setActiveTitle(placeholderLabel)
            }else {
                self.setPlaceHolder(placeholderLabel)
            }
        }
        lineView.backgroundColor = activeLineViewColor
        behavior?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            if self.text.count.hashValue > 0 {
                self.setTitle(placeholderLabel)
            }else {
                self.setPlaceHolder(placeholderLabel)
            }
        }
        lineView.backgroundColor = lineViewColor
        behavior?.textViewDidBeginEditing?(textView)
    }
    
    fileprivate func setTitle(_ placeholderLabel: UILabel) {
        placeholderLabel.textColor = self.titleColor
        placeholderLabel.text = title
        placeholderLabel.font = titleFont
    }
    
    fileprivate func setPlaceHolder(_ placeholderLabel: UILabel) {
        placeholderLabel.textColor = self.placeHolderColor
        placeholderLabel.text = placeholder ?? ""
        placeholderLabel.font = placeHolderFont
    }
    
    fileprivate func setActiveTitle(_ placeholderLabel: UILabel) {
        placeholderLabel.textColor = self.activeTitleColor
        placeholderLabel.text = title
        placeholderLabel.font = titleFont
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let nsString = textView.text as NSString
        let newString = nsString.replacingCharacters(in: range, with: text)
        let tV = UITextView(frame: textView.frame)
        tV.attributedText = textView.attributedText
        tV.font = textView.font
        tV.textContainerInset = self.textContainerInset
        tV.textContainer.lineFragmentPadding = 0
        tV.text = newString
        let fixedWidth = tV.frame.size.width
        tV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = tV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = tV.frame
        if newSize.height > defaultHeight + topOfContainerView {
            textView.isScrollEnabled = false
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            textView.frame = newFrame
            height.constant = newFrame.height
        } else {
            textView.isScrollEnabled = false
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: defaultHeight + topOfContainerView)
            textView.frame = newFrame
            height.constant = defaultHeight + topOfContainerView
        }
        _ = behavior?.textView?(self, shouldChangeTextIn: range,replacementText: text)
        return true
    }
}
