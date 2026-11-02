document.addEventListener("DOMContentLoaded", () => imageInit());
let imageSelect = 1;
let imageCount = 0;
let timer;

function imageInit() {
    let pics = document.getElementsByClassName('img-select');
    imageCount = pics.length;

    for (let n = 0; n < pics.length; ++n) {
        let img = pics[n];
        img.style.textDecoration = 'underline';
        img.style.fontWeight = 'normal';
        img.style.cursor = 'pointer';
        img.addEventListener('click', () => selectImage(n));
    }
    selectImage();
}

function selectImage() {
    clearTimeout(timer);

    let pic = document.images.pic;
    let sel = pic.src;
    pic.src = './images/pjk' + (imageSelect) + '.gif';

    sel = sel.split('/');
    sel = sel[sel.length - 1];
    sel = sel.slice(3, sel.length - 4);

    sel = document.getElementById('sel-' + sel);
    sel.style.textDecoration = 'underline';
    sel.style.fontWeight = 'normal';

    sel = document.getElementById('sel-' + imageSelect);
    sel.style.textDecoration = 'none';
    sel.style.fontWeight = 'bold';

    imageSelect = 1 + (imageSelect % imageCount);

    timer = setTimeout("selectImage()", 10_000);
}