(function() {

	var app = angular.module('CSSManApp', []);

	app.config(function($routeProvider) {
		$routeProvider.when('/', {controller: 'CSSManCtrl'}).otherwise({redirectTo: '/'})
	});

	app.directive( 'superstyle', function( $compile ) {
	  return {
	    restrict: 'E',
	    scope: { selector: "=selector", styles: "=styles", verify: "=verify", key: "=key" },
	    link: function ( scope, element, attrs ) {
	      var el;

	      scope.$watch( 'selector', function () {
	      	if(typeof(scope.key) === "string") {
		        el = typeof(scope.selector) !== "undefined"  ? 
		        	$compile( '<style> '+scope.selector+' { '+scope.styles+' } </style>' )( scope ) :
		        	$compile( '<style>'+scope.styles+'</style>' )( scope )

		        element.html("");
		        element.append( el );
	        }
	      });

	       scope.$watch( 'styles', function() {
	       	if(typeof(scope.key) === "string") {
		       	if(typeof(scope.verify) === "function") {
		       		if(!scope.verify(scope.key, scope.styles)) {
		       			return false;
		       		}
		       	}

		        el = typeof(scope.selector) !== "undefined"  ? 
		        	'<style> '+scope.selector+' { '+scope.styles+' } </style>' :
		        	'<style>'+scope.styles+'</style>'

		        element.html(el);
	    	}
	      })
	    }
	  };
	});

	app.directive("human", function() {
		return {
			restrict: 'E',
			templateUrl: "/assets/templates/human.html",
			scope: {
				human: "=human", 
				click: "=ngClick"
			}
		};
	});

	app.controller('CSSManCtrl', function($scope, $http) {
		$scope.userKey = randomString(5);

		$scope.activeTab = 'head';

		$scope.preview_head_css = "height: 14%;\nwidth: 25%;\nposition: relative;\nleft: 60%;\nborder-radius: 30px;\nbackground-color: white;\nanimation: "+$scope.userKey+"_headBounce 1.5s linear infinite;\n-webkit-animation: "+$scope.userKey+"_headBounce 1.5s linear infinite;\n-moz-animation: "+$scope.userKey+"_headBounce 1.5s linear infinite;\nmargin: 0 0 0 -13%;\ntop: 8%;";
		$scope.preview_head_before_css = "content: ' ';\ndisplay: block;\nheight: 50%;\nwidth: 70%;\nborder-radius: 30px;\nbackground-color: white;\nposition: absolute;\nleft: -12%;\ntop: 20%"
		$scope.preview_head_after_css = "content: ' ';\ndisplay: block;\nheight: 50%;\nwidth: 70%;\nborder-radius: 30px;\nbackground-color: white;\nposition: absolute;\nright: -12%;\ntop: 20%;"
	
		$scope.preview_body_css = "position: relative;\ntop: 9%;\nleft: 30%;\nheight: 40%;\nwidth: 40%;\nbackground-color: white;\nborder-radius: 15px;";
		$scope.preview_body_before_css = "content: ' ';\ndisplay: block;\nheight: 100%;\nwidth: 35%;\nborder-radius: 30px;\nposition: absolute;\nleft: -25%;\ntop: 0px;\nbackground-color: white;\ntransform: rotateZ(15deg);\n-webkit-transform: rotateZ(15deg);\n-moz-transform: rotateZ(15deg);";
		$scope.preview_body_after_css = "content: ' ';\ndisplay: block;\nheight: 100%;\nwidth: 35%;\nborder-radius: 30px;\nposition: absolute;\nright: -25%;\ntop: 0px;\nbackground-color: white;\ntransform: rotateZ(-15deg);\n-webkit-transform: rotateZ(-15deg);\n-moz-transform: rotateZ(-15deg);"

		$scope.preview_legs_css = "height: 100%;\nwidth: 36%;\nbackground-color: transparent;\nposition: relative;\ntop: 9%;\nleft: 30%;";
		$scope.preview_legs_before_css = "content: ' ';\ndisplay: block;\nheight: 50%;\nwidth: 50%;\nborder-radius: 30px;\nposition: absolute;\nleft: 0px;\ntop: -14%;\nbackground-color: white;"
		$scope.preview_legs_after_css = "content: ' ';\ndisplay: block;\nheight: 50%;\nwidth: 50%;\nborder-radius: 30px;\nposition: absolute;\nright: -14%;\ntop: -14%;\nbackground-color: white;";

		$scope.preview_animations_css = "@keyframes "+$scope.userKey+"_headBounce {\n	0% {\n		margin: 0 0 0 -13%;\n		left: 55%;\n	}\n	25% {\n		margin: -8% 0 8% -13%;\n		left: 50%;\n	}\n	50% {\n		margin: 0 0 0 -13%;\n		left: 45%;\n	}\n	75% {\n		margin: -8% 0 8% -13%;\n		left: 50%;\n	}\n	100% {\n		margin: 0 0 0 -13%;\n		left: 55%;\n	}\n}\n\n@-webkit-keyframes "+$scope.userKey+"_headBounce {\n	0% {\n		margin: 0 0 0 -13%;\n		left: 55%;\n	}\n	25% {\n		margin: -8% 0 8% -13%;\n		left: 50%;\n	}\n	50% {\n		margin: 0 0 0 -13%;\n		left: 45%;\n	}\n	75% {\n		margin: -8% 0 8% -13%;\n		left: 50%;\n	}\n	100% {\n		margin: 0 0 0 -13%;\n		left: 55%;\n	}\n}";
	
		$scope.footer_guy_head = "head";

		$scope.error = "";

		$scope.verify_css = function(key, css) {
			if(css.indexOf("{") !== -1 || css.indexOf("}") !== -1) {
				$scope.error = "Brackets?  That seems like cheating!"
				return false;
			}

			if(css.indexOf(">") !== -1 || css.indexOf("<") !== -1) {
				$scope.error = "I like carrots, but probably not here...";
				return false;
			}

			if(css.indexOf("\"") !== -1) {
				$scope.error = "I'm all for double quotes, but please use single ones here"
				return false;
			}

			var animations = css.match(/keyframes[^{]*{/g);
			if(animations) {
				for(var i=0, max=animations.length; i<max; i++) {
					if(animations[i].indexOf($scope.userKey) === -1) {
						$scope.error = "I know it's a pain, but we require all animations to have a user key in the name.  Yours is "+key;
						return false;
					}
				}
			}

			$scope.error = "";
			return true;
		}

		$scope.verify_animations = function(key, css) {
			var justOpens = css.replace(/[^{]+/g, "");
			var justCloses = css.replace(/[^}]+/g, "");

			if(justOpens.length !== justCloses.length) {
				$scope.error = "You seem to have mismatched curly brackets.  What's the deal?";
				return false;
			}

			if(css.indexOf(">") !== -1 || css.indexOf("<") !== -1) {
				$scope.error = "I like carrots, but probably not here...";
				return false;
			}

			if(css.indexOf("\"") !== -1) {
				$scope.error = "I'm all for double quotes, but please use single ones here"
				return false;
			}

			var animations = css.match(/keyframes[^{]*{/g);
			if(animations) {
				for(var i=0, max=animations.length; i<max; i++) {
					if(animations[i].indexOf($scope.userKey) === -1) {
						$scope.error = "I know it's a pain, but we require all animations to have a user key in the name.  Yours is "+key;
						return false;
					}
				}
			}

			$scope.error = "";
			return true;
		}

		$scope.sendMan = function() {
			var dat = {
				key: $scope.userKey,
				css: {
					head: $scope.preview_head_css,
					head_before: $scope.preview_head_before_css,
					head_after: $scope.preview_head_after_css,
					body: $scope.preview_body_css,
					body_before: $scope.preview_body_before_css,
					body_after: $scope.preview_body_after_css,
					legs: $scope.preview_legs_css,
					legs_before: $scope.preview_legs_before_css,
					legs_after: $scope.preview_legs_after_css,
					animations: $scope.preview_animations_css
				}
			};

			$http.post("/api/v0/men/create", dat).success(function(data, status, headers, config) {
				console.log(data, status, headers, config);
			});
		}

		$scope.grabMan = function(human) {

			var replaceKey = new RegExp(human.key, "g");

			$scope.preview_head_css = human.css.head.replace(replaceKey, $scope.userKey);
			$scope.preview_head_before_css = human.css.head_before.replace(replaceKey, $scope.userKey);
			$scope.preview_head_after_css = human.css.head_after.replace(replaceKey, $scope.userKey);
			$scope.preview_body_css = human.css.body.replace(replaceKey, $scope.userKey);
			$scope.preview_body_before_css = human.css.body_before.replace(replaceKey, $scope.userKey);
			$scope.preview_body_after_css = human.css.body_after.replace(replaceKey, $scope.userKey);
			$scope.preview_legs_css = human.css.legs.replace(replaceKey, $scope.userKey);
			$scope.preview_legs_before_css = human.css.legs_before.replace(replaceKey, $scope.userKey);
			$scope.preview_legs_after_css = human.css.legs_after.replace(replaceKey, $scope.userKey);
			$scope.preview_animations_css = human.css.animations.replace(replaceKey, $scope.userKey);
		}

		$http.get("/api/v0/men").success(function(data, status, headers, config) {
			$scope.humans = data;
		});
	});

	function randomString(len) {
		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

		var str = "";
		for(var i=0; i<len; i++) {
			str += possible[Math.floor(Math.random() * possible.length)];
		}

		return str;
	}



})();