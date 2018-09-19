window.onload = function(){
	let scrollToTop = window.setInterval(function(){
		let pos = window.pageYOffset;
		if (pos > 0) {
			window.scrollTo(0, 0);
		} else {
			window.clearInterval(scrollToTop);
		}
	}, 10);
}