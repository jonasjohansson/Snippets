// Import https://ajax.googleapis.com/ajax/libs/webfont/1.6.26/webfont.js

const url = 'https://raw.githubusercontent.com/jonathantneal/google-fonts-complete/master/google-fonts.json';
const request = new XMLHttpRequest();
request.open('GET', url, true);
request.onload = function () {
	if (request.status >= 200 && request.status < 400) {
		const data = JSON.parse(request.responseText);
		const font = pickRandomProperty(data);
		WebFont.load({
			google: {
				families: [font]
			}
		});
		document.body.style.fontFamily = font;
		document.body.innerHTML = font;
	}
};
request.send();

function pickRandomProperty(obj) {
	let result;
	let count = 0;
	for (const prop in obj) {
		if (Math.random() < 1 / ++count) {
			result = prop;
		}
	}
	return result;
}
