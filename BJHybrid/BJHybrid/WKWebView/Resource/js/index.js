function buttonDivAction() {
	window.webkit.messageHandlers.currentCookies.postMessage("JS传来的消息");
}

function alertAction(message) {
    window.webkit.messageHandlers.currentCookies.postMessage("我是JS，你的消息我收到了");
}
