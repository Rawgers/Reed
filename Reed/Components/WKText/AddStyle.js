// Add CSS to WKText
const addStyle = () => {
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
            border: 1px solid transparent
        }
        .highlighted {
            background-color: rgba(237, 237, 135, 0.5);
            border-radius: 16px;
        }
    `;
    document.head.appendChild(style);
};
addStyle();

function setFontSizes(viewType) {
    const style = document.createElement('style');
    switch (viewType) {
        case 'title':
            style.textContent = `
                span {
                    font-size: 72px;
                    font-weight: bold;
                }
                rt {
                    font-size: 36px;
                    font-weight: normal;
                }
            `
            break;

        case 'body':
        default:
            style.textContent = `
                span {
                    font-size: 36px;
                    font-weight: normal;
                }
                rt {
                    font-size: 18px;
                    font-weight: normal;
                }
            `
    }
    document.head.appendChild(style);
}
