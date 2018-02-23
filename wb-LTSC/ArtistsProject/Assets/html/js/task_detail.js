// var app = angular.module('app', ['infinite-scroll'])
var app = angular.module('app', ['ngSanitize'])
// var app = angular.module('app', [])
  // allow DI for use in controllers, unit tests
  .constant('_', window._)
  .constant('$', window.$)
  // use in views, ng-repeat="x in _.range(3) track by $index"
  .run(function ($rootScope) {
     $rootScope._ = window._;
     $rootScope.$ = window.$;
  });
app.controller('MainCtrl', ['$scope', '$sce','$timeout', '$location', '$anchorScroll',
function($scope,$sce,$timeout, $location, $anchorScroll) {

  function updateData(data) {
    console.log(data);
    $scope.task = data;
  }

  // 获取APP传来的页面配置：
  bridge.ready(function() {
    
    bridge.addHandler(this, "resetData", function(data) {
      $scope.$apply(function() {
        updateData(data);
      });
    });
    H5Log(bridge.config);
    $scope.$watch('task', function() {
      console.log("article content changed");
      $('#article-content img, .thumb-container').css('width', '100%');
      $('#article-content img, .task-thumb').css('width', '100%');
      $('#article-content img, .task-thumb').css('height', '');
      bridge.callHandler("onPageLoaded");
    });



    if (!bridge.config.connectApp) {
      setTimeout(function() {
        // 模拟调用H5注册的接口
        bridge.mockCallH5Handler("resetData", mockData1, function(data) {
          APPLog("app get resp:" + data);
        });
        // bridge.mockCallH5Handler("resetData", mockData1, function(data) {
        //   APPLog("app get resp:" + data);
        // });
      }, 500);
    }
  });

}]);