//const html = document.documentElement.innerHTML;
//window.webkit.messageHandlers.handleTapWord.postMessage({ 'everything': html });

// Add CSS to ReaderView
const style = document.createElement('style');
style.textContent = `
    :root {
        color-scheme: light dark;
    }
    * {
        -webkit-touch-callout: none;
        -webkit-user-select: none
    }
    body {
        font-family: -apple-system, "Helvetica Neue"
    }
    span {
        font-size: 36px;
        border: 1px solid transparent
    }
    rt {
        font-size: 18px;
    }
    .highlighted {
        background-color: rgba(237, 237, 135, 0.5);
        border-radius: 16px;
    }
`;
document.head.appendChild(style);

// disable zoom
const meta = document.createElement('meta');
meta.name = 'viewport';
meta.content = 'width=device-width, initial-scale=0.5, maximum-scale=0.5, user-scalable=no';
const head = document.getElementsByTagName('head')[0];
head.appendChild(meta);

let lastSelectedToken;
let timer;
const onTapWord = token => {
    return () => {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
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
        }, 150);
    };
};

const tokens = document.getElementsByTagName('span');
for (token of tokens) {
    const handleTap = onTapWord(token);
    token.onclick = handleTap;
    token.ondblclick = function() {
        clearTimeout(timer);
    }
}
