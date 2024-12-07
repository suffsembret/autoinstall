// Typing effect for the name text
const nameElement = document.getElementById("name");

function typeWriter(element, text, i, fnCallback) {
    if (i < text.length) {
        element.innerHTML = text.substring(0, i + 1);
        setTimeout(function () {
            typeWriter(element, text, i + 1, fnCallback);
        }, 100);
    } else if (typeof fnCallback == "function") {
        fnCallback();
    }
}

document.addEventListener("DOMContentLoaded", function () {
    typeWriter(nameElement, "SUFYAN", 0, function () {
        console.log("Typing effect complete");
    });

    // Scroll Animation
    const scrollElements = document.querySelectorAll(".fade-in");

    const elementInView = (el, offset = 1) => {
        const elementTop = el.getBoundingClientRect().top;
        return (
            elementTop <=
            (window.innerHeight || document.documentElement.clientHeight) / offset
        );
    };

    const displayScrollElement = (element) => {
        element.classList.add("show");
    };

    const hideScrollElement = (element) => {
        element.classList.remove("show");
    };

    const handleScrollAnimation = () => {
        scrollElements.forEach((el) => {
            if (elementInView(el, 1.25)) {
                displayScrollElement(el);
            } else {
                hideScrollElement(el);
            }
        });
    };

    window.addEventListener("scroll", () => {
        handleScrollAnimation();
    });
});
