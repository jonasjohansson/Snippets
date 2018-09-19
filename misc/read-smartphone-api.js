const node = document.childNodes[0];
const end = '<br>';

window.ondevicemotion = function (event) {
	node.innerHTML = 'Acceleration X: ' + event.accelerationIncludingGravity.x + end;
	node.innerHTML += 'Acceleration Y: ' + event.accelerationIncludingGravity.y + end;
	node.innerHTML += 'Acceleration Z: ' + event.accelerationIncludingGravity.z + end;
	if (event.rotationRate) {
		node.innerHTML += 'Rotation Alpha: ' + Math.round(event.rotationRate.alpha) + end;
		node.innerHTML += 'Rotation Beta: ' + Math.round(event.rotationRate.beta) + end;
		node.innerHTML += 'Rotation Gamma: ' + Math.round(event.rotationRate.gamma) + end;
	}
};

window.ondeviceorientation = function (event) {
	node.innerHTML += 'Gyroscope Alpha: ' + Math.round(event.alpha) + end;
	node.innerHTML += 'Gyroscope Beta: ' + Math.round(event.beta) + end;
	node.innerHTML += 'Gyroscope Gamma: ' + Math.round(event.gamma);
};
