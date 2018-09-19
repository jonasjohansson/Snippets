window.onload = function(){
	var el = document.querySelector("#element");
	var ypos = el.scrollTop + el.offsetTop;
	document.addEventListener("scroll",function(e){
		if (window.pageYOffset > ypos){
			el.style.position = "fixed";
		} else {
			el.style.position = "";
		}
	});
}