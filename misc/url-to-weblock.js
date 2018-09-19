const fs = require('fs');
const path = require('path');

const ext = 'url';
const newExt = 'webloc';
const replaceFile = true;

function list(startPath) {
	const files = fs.readdirSync(startPath);
	for (const file of files) {
		const filepath = path.join(startPath, file);
		const stat = fs.lstatSync(filepath);
		if (stat.isDirectory()) {
			list(filepath);
		} else {
			const ext = filepath.split('.').pop();
			if (ext === 'url') {
				fs.readFile(filepath, 'utf-8', (err, content) => {
					if (err) {
						throw err;
					}

					const matches = content.match(/\bhttps?:\/\/\S+/gi);
					if (matches !== null) {
						createXML(filepath, file, matches[0]);
					}
				});
			}
		}
	}
}

function createXML(filepath, filename, url) {
	const newFilename = filename.slice(0, -ext.length) + newExt;
	const xml = '<?xml version="1.0" encoding="UTF-8"?>' +
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' +
		'<plist version="1.0">' +
		'<dict>' +
		'	<key>URL</key>' +
		'	<string>' + url + '</string>' +
		'</dict>' +
		'</plist>';
	const dir = filepath.slice(0, -filename.length);
	const newDir = (replaceFile) ? dir : dir + newExt;
	if (!fs.existsSync(newDir)) {
		fs.mkdirSync(newDir);
	}
	fs.writeFile(newDir + '/' + newFilename, xml, err => {
		if (err) {
			return console.log(err);
		}
		console.log(newFilename + ' saved!');
	});
	if (replaceFile) {
		fs.unlinkSync(filepath);
	}
}

list(__dirname);
