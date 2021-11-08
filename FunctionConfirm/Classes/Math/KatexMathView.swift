//
//  KatexMathView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/11/08.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import WebKit

class KatexMathView: WKWebView {

    func loadLatex(_ content: String ) {
        guard let path = Bundle.main.path(forResource: "katex/index", ofType: "html") else {
            fatalError()
        }
        self.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.navigationDelegate = self
        self.isOpaque = false
        self.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        let htmlContent = getHtml(content, path)
        self.loadHTMLString(htmlContent, baseURL: URL(fileURLWithPath: path))
    }

    func getHtml(_ htmlContent: String, _ path: String) -> String {
        var htmlString = try! String(contentsOfFile: path, encoding: .utf8)
        var content = htmlContent
        let delimitter = "$"
        let startTexTag = "<span class=\"tex\">"
        let endTexTag = "</span>"
        var first = true
        while content.contains(delimitter) {
            let tag: String = first ? startTexTag : endTexTag
            if let range =  content.range(of: delimitter) {
                content = content.replacingOccurrences(of: delimitter, with: tag, options: NSString.CompareOptions.literal, range: range)
            }
            first = !first
        }
        htmlString = htmlString.replacingOccurrences(of: "$LATEX$", with: content)
        return htmlString
    }
}

// MARK: KatexMathView
extension KatexMathView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.evaluateJavaScript("document.readyState", completionHandler: { complete, _ in
            if complete != nil {
                self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { height, _ in
                    self.frame.size.height = height as! CGFloat
                    self.layoutIfNeeded()
                })
            }
        })
    }
}
