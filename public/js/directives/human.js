app.directive("human", function() {
	return {
		restrict: 'E',
		templateUrl: "/assets/templates/human.html",
		scope: {
			human: "=human", 
			click: "=ngClick"
		},
		link: function(scope, element, attrs) {
			var possibilities = ['close', 'medium', 'far'];

			scope.distance = possibilities[Math.floor(Math.random() * possibilities.length)];

			var styleTag = "<style type='text/css'>";
			styleTag	+= scope.human.css.animations;
			styleTag	+= "#human_" + scope.human._id + " .head { ";
			styleTag	+= 		scope.human.css.head;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .head:before { ";
			styleTag	+= 		scope.human.css.head_before;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .head:after { ";
			styleTag	+= 		scope.human.css.head_after;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .legs { ";
			styleTag	+= 		scope.human.css.legs;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .legs:before { ";
			styleTag	+= 		scope.human.css.legs_before;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .legs:after { ";
			styleTag	+= 		scope.human.css.legs_after;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .body { ";
			styleTag	+= 		scope.human.css.body;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .body:before { ";
			styleTag	+= 		scope.human.css.body_before;
			styleTag 	+= "}";
			styleTag	+= "#human_" + scope.human._id + " .body:after { ";
			styleTag	+= 		scope.human.css.body_after;
			styleTag 	+= "}";
			styleTag 	+= "</style>"

			element.prepend(styleTag);
		}
	};
});