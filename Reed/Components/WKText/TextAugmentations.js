// const html = document.documentElement.innerHTML;
// window.webkit.messageHandlers.handleTapWord.postMessage({ 'everything': html });

// Add CSS to ReaderView
const style = document.createElement('style');
style.textContent = `
    body {
        font-size: 36px; 
    }
    rt { 
        font-size: 18px;
    }
`;
document.head.appendChild(style);

const onTapWord = word => {
    return () => {
        if (window.webkit 
            && window.webkit.messageHandlers 
            && window.webkit.messageHandlers.handleTapWord)
        {
            window.webkit.messageHandlers.handleTapWord.postMessage({ word });
        }
    };
};

const tokens = document.getElementsByTagName('span');
for (token of tokens) {
    const word = token.getAttribute('data-surface');
    const handleTap = onTapWord(word);
    token.onclick = handleTap;
}