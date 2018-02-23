(function() {

    function setFontbase() {
        var fontSize = document.documentElement.offsetWidth / 37.5;

        fontSize = fontSize > 18 ? 18 : fontSize;

        document.documentElement.style.fontSize = fontSize + 'px';
    }

    setFontbase();

    window.onresize = function() {

        setFontbase();
    }
})();