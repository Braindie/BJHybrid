function buttonDivAction() {
	window.webkit.messageHandlers.bj.postMessage('你点了我的按钮');
}

var num = document.getElementById("num");

function alertAction(message) {
    num.value = message;
//    window.webkit.messageHandlers.bj.postMessage('我是JS，你的消息我收到了：'+message);
}
