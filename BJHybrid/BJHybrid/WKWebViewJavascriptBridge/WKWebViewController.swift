//
//  WKWebViewController.swift
//  BJHybrid
//
//  Created by zhangwenjun on 2019/1/3.
//  Copyright © 2019 zhangwenjun. All rights reserved.
//

import Foundation
import WebKit
import WebKit
import WKWebViewJavascriptBridge

class WKWebViewController : UIViewController {
    
    
    /// property
    let webView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())
    var bridge : WKWebViewJavascriptBridge!
    
    
    
    /// cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = view.bounds
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        bridge = WKWebViewJavascriptBridge(webView: webView)
        bridge.isLogEnable = true
        // 注册（固定模板）
        bridge.register(handlerName: "testiOSCallback") { (paramters, callback) in
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }
        bridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configData()
        callHandler()
    }
    
 
    
    /// configData
    func configData(){
        
        let pagePath = Bundle.main.path(forResource: "Demo", ofType: "html")
        
        let pageHtml = try? String(contentsOfFile: pagePath!, encoding: .utf8)
        let baseUrl = URL(fileURLWithPath: pageHtml!)
        
        webView.loadHTMLString(pageHtml!, baseURL: baseUrl)
    }
    
    
    @objc func callHandler() {
        let data = ["greetingFromiOS": "Hi there, JS!"]
        bridge.call(handlerName: "testJavascriptHandler", data: data) { (response) in
            print("testJavascriptHandler responded: \(String(describing: response))")
        }
    }
    
    
}


extension WKWebViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
}
