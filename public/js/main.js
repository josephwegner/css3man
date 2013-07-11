var app = angular.module('CSSManApp', []);

function randomString(len) {
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	var str = "";
	for(var i=0; i<len; i++) {
		str += possible[Math.floor(Math.random() * possible.length)];
	}

	return str;
}

/* Codekit Appends
   ---------------

  @codekit-append "controllers/CSSMan.js"
  @codekit-append "directives/human.js"
  @codekit-append "directives/superStyle.js"

*/


