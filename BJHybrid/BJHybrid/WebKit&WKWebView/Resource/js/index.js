function buttonDivAction() {
	window.webkit.messageHandlers.currentCookies.postMessage('我是JS，我主动给你发了消息');
}

function alertAction(message) {
    window.webkit.messageHandlers.currentCookies.postMessage('我是JS，你的消息我收到了：'+message);
}
