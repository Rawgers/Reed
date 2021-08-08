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

const rubyElements = document.getElementsByTagName("ruby");
const rtElements = document.getElementsByTagName("rt");
const numElements = rubyElements.length;

for (let i = 0; i < numElements; i++) {
    const word = rubyElements[i].innerHTML.split("<rp>")[0];
    const handleTap = onTapWord(word);
    rubyElements[i].onclick = handleTap;
}
