var jssdk = (function() {
  var jssdk = {
    version: '1.0',
    share: function (shareInfo) {
      _nativeShare(shareInfo)
    }
  }

  function _nativeShare(shareInfo) {
    // 至于Android端，也可以，比如 window.jsInterface.nativeShare(JSON.stringify(shareInfo));
		window.webkit.messageHandlers.nativeShare.postMessage(shareInfo);
  }

  return jssdk
})();