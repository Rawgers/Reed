//const html = document.documentElement.innerHTML;
//window.webkit.messageHandlers.handleTapWord.postMessage({ 'everything': html });

// Add CSS to ReaderView
const style = document.createElement('style');
style.textContent = `
    body {
        font-size: 36px;
    }
    span {
        border: 1px solid transparent
    }
    rt {
        font-size: 18px;
    }
    .highlighted {
        background-color: #FFFF00;
    }
`;
document.head.appendChild(style);

let lastSelectedToken;
const onTapWord = token => {
    return () => {
        if (window.webkit 
            && window.webkit.messageHandlers 
            && window.webkit.messageHandlers.handleTapWord)
        {
            if (lastSelectedToken) {
                lastSelectedToken.classList.remove('highlighted');
            }
            const word = token.getAttribute('data-deinflection');
            window.webkit.messageHandlers.handleTapWord.postMessage({ word });
            token.classList.add('highlighted');
            lastSelectedToken = token;
        }
    };
};

const tokens = document.getElementsByTagName('span');
for (token of tokens) {
    const handleTap = onTapWord(token);
    token.onclick = handleTap;
}
