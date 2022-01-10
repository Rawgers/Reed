const highlightedToken = document.getElementsByClassName("highlighted");
window.webkit.messageHandlers.handleTapWord.postMessage({ 'everything': "highlightedToken" });

if (highlightedToken && highlightedToken.length > 0) {
    highlightedToken[0].classList.remove("highlighted");
}
