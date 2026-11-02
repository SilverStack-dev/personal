// <span class="email">pjk ku gor scb</span>
// <span class="email"pjk<b>@</b>bcs<i>.</i>org<i>.</i>uk</span>
document.addEventListener("DOMContentLoaded", () => {
    let spans = document.getElementsByClassName('email');
    for (let n = 0; n < spans.length; ++n) {
        let parts = spans[n].innerHTML.split(' ');
        let text = parts[0] + '<i>@</i>';
        for (let i = 1; i < parts.length; ++i) {
            let seg = parts[i].split('').reverse().join('');
            text += seg + '<b>.</b>';
        }
        text = text.slice(0, -8);
        spans[n].innerHTML = text;
    }
});