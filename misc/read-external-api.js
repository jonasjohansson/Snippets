const url = 'https://api.openweathermap.org/data/2.5/weather?lat=59.337396&lon=18.075943&APPID=676d4c8ad58a8656d3f70650231d0604';
// Var url = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/18.075943/lat/59.337396/data.json";
// var url = "http://api.kolada.se/v1/data/permunicipality/N07400/0186";
// var url = "https://ghibliapi.herokuapp.com/films/58611129-2dbc-4a81-a72f-77ddfc1b1b49";
// var url = "http://api.tvmaze.com/search/shows?q=girls";

const req = new XMLHttpRequest();
req.addEventListener('load', reqListener);
req.open('GET', url);
req.send();

function reqListener() {
	document.write(this.responseText);
}
