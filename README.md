# BJHybrid

### JSPatch
使用JSPatch实现热更新

### NSURLProtocol
通过此协议可以实现webView中的图片用本地资源来代替

### UIWebView（JavaScriptCore）
OC与JS中的方法可以相互调用，不过JS中要有特定的对象作为OC的代理对象

### UIWebView（WebViewJavascriptBridge）
只能使用UIWebView<br/>
通过给JS中注入特点代码，然后匹配方法名可以实现JS与OC的相互调用，并且每次调用都会有回调

### WKWebView（自带交互API）
不需要JavaScriptCore，直接交互

### WKWebView（WKWebViewJavascriptBridge）
用的是swift版本

### WKWebView
KVO、代理
