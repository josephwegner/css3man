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
	        	$compile( '<style> '+scope.selector+' { '+scope.styles+' } </style>' )( scope ) :
	        	$compile( '<style>'+scope.styles+'</style>' )( scope )

	        element.html("");
	        element.append( el );
    	}
      })
    }
  };
});