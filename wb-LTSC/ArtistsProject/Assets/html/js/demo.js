// 全局变量
// var CONTEXT_PATH = "http://192.168.0.109:3001";
var CONTEXT_PATH = "http://localhost:3001";
var g_articleId = 31946;
var g_currentPage = 0;
var g_isFavourite = false;
var g_articleDetail = "";
// 当前所用的字体的尺寸：大中小
var g_currentFontSize = "font-mid";
// 从APP传递过来的初始化参数
var g_initParams;

var g_changeFontConf = {
  "font-especial-big": [
    { "selector": "body", "style": "font-size:22px!important;color:#333333;" },
    { "selector": "#article-title", "style": "font-size:26px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:22px!important;" },
    { "selector": "p", "style": "font-size:22px!important;" },
    { "selector": "strong", "style": "font-size:22px!important;" },
    { "selector": ".comments-box", "style": "font-size:22px!important;line-height:1.5;" },
    { "selector": ".user-name", "style": "font-size:22px!important;" },
    { "selector": ".comment-cont", "style": "font-size:22px!important;" },
    { "selector": ".user-comment-box", "style": "font-size:22px!important;" },
  ],
  "font-big": [
    { "selector": "body", "style": "font-size:20px!important;color:#333333;" },
    { "selector": "#article-title", "style": "font-size:24px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:20px!important;" },
    { "selector": "p", "style": "font-size:20px!important;" },
    { "selector": "strong", "style": "font-size:22px!important;" },
    { "selector": ".comments-box", "style": "font-size:20px!important;line-height:1.5;" },
    { "selector": ".user-name", "style": "font-size:20px!important;" },
    { "selector": ".comment-cont", "style": "font-size:20px!important;" },
    { "selector": ".user-comment-box", "style": "font-size:20px!important;" },
  ],
  "font-mid": [
    { "selector": "body", "style": "font-size:16px!important;color:#333333;" },
    { "selector": "#article-title", "style": "font-size:22px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:16px!important;" },
    { "selector": "p", "style": "font-size:16px!important;" },
    { "selector": "strong", "style": "font-size:16px!important;" },
    { "selector": ".comments-box", "style": "font-size:16px!important;line-height:1.5;" },
    { "selector": ".user-name", "style": "font-size:16px!important;" },
    { "selector": ".comment-cont", "style": "font-size:16px!important;" },
    { "selector": ".user-comment-box", "style": "font-size:16px!important;" },
  ],
  "font-small": [
    { "selector": "body", "style": "font-size:14px!important;color:#333333;" },
    { "selector": "#article-title", "style": "font-size:20px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:14px!important;" },
    { "selector": "p", "style": "font-size:14px!important;" },
    { "selector": "strong", "style": "font-size:14px!important;" },
    { "selector": ".comments-box", "style": "font-size:14px!important;line-height:1.5;" },
    { "selector": ".user-name", "style": "font-size:14px!important;" },
    { "selector": ".comment-cont", "style": "font-size:14px!important;" },
    { "selector": ".user-comment-box", "style": "font-size:14px!important;" },
  ]
};


var app = angular.module('app', ['ngSanitize'])
  // allow DI for use in controllers, unit tests
  .constant('_', window._)
  .constant('$', window.$)
  // use in views, ng-repeat="x in _.range(3) track by $index"
  .run(function($rootScope) {
    $rootScope._ = window._;
    $rootScope.$ = window.$;
  });

app.controller('MainCtrl', ['$scope', '$sce', '$timeout', '$location', '$anchorScroll',
  function($scope, $sce, $timeout, $location, $anchorScroll) {
    $scope.articleDetail = {};
    $scope.assetsPath = "";
    $scope.themeStyle;
    $scope.onBodyScroll = function() {

    }
    $scope.safeApply = function(task) {
      setTimeout(function() {
        $scope.$apply(function() {
          task();
        });
      }, 1);
    };


    /*更新文章详情页面，包括文章和评论*/
    function updateData(data) {
      $scope.data = data;
      updateArticle(data.articleDetail);
    }

    // 更新文章相关的数据
    function updateArticle(articleDetail) {
      $scope.articleDetail = articleDetail;
      $scope.content = articleDetail.post_content;
      $scope.articleDetail.content = $sce.trustAsHtml($scope.content);
    }


    // FIXME 需要淘汰，目前仅在android中是用
    function initBodyEvents() {
      // 监听屏幕滚动事件
      $("body").scroll(function() {
        // H5Log("a")
        if ($(window).scrollTop() > 1) {}
        jsbridge.callNative("page", "onScreenScroll");
      });

    }

    function setFontSize(fontClassStr) {
      // H5Log("setFontSize " + fontClassStr);
      if (g_changeFontConf[fontClassStr] == null || g_changeFontConf[fontClassStr].length <= 0) {
        return;
      }
      if (fontClassStr == null) {
        fontClassStr = "font-mid";
      }
      for (var i = 0; i < g_changeFontConf[fontClassStr].length; i++) {
        var conf = g_changeFontConf[fontClassStr][i];
        console.log("selector " + conf["selector"] + ", length " + $(conf["selector"]).length);
        $(conf["selector"]).attr("style", conf["style"]);
      }
    }

    // 初始化handler
    function initOtherHandlers(jsbridge) {
      // H5Log("initOtherHandlers");
      // H5Log(jsbridge);
      // 跳转到页面的评论位置
      jsbridge.addHandler(this, "page", "jumpToComments", function(data) {
        H5Log("jumpToCommentsxxxx");
        // window.location.href = "#comment-section";
        // $ionicScrollDelegate.scrollTo(0, $("#comment-section").offset().top, true);
        // $ionicScrollDelegate.scrollBottom();
        var old = $location.hash();
        $location.hash('bottom');
        $anchorScroll();
        $location.hash(old);
      });

      // 设置字体大小
      jsbridge.addHandler(this, "page", "setFontSize", function(data) {
        H5Log("设置字体");
        $scope.fontSize = data;
        console.log(data);
        setFontSize(data);
      });

      // 加载本地缓存图片
      jsbridge.addHandler(this, "page", "setImgLocalPath", function(data) {
        // data 格式
        // data = {
        //   index:0,
        //   path:''
        // }
        H5Log("ios/android call js: = " + data);
        // android 需要加前缀
        //data.path = "content://com.adquan.adquan.provider.localfile" + data.path;
        $("#article-content img[data-ref-id=" + data.index + "]").attr("src", data.path);
      });

      // 重新加载评论
      jsbridge.addHandler(this, "page", "comment", function(data) {
        // H5Log("comment XXXXXX" + data);
        $scope.$apply(function() {
          refreshComments(data);
          setFontSize(jsbridge.config.fontSize);
        });
      });

    }
    // 获取APP传来的页面配置：
    // 获取APP传来的页面配置：
    jsbridge.ready(function() {
      initOtherHandlers(jsbridge);

      setTimeout(function() {
        $scope.$apply(function() {
          console.log('jsbridge.config', jsbridge.config);
          setFontSize(jsbridge.config.fontSize);
          updateData(jsbridge.config);
        });
      }, 1);
      $scope.$watch('articleDetail.content', function() {
        console.log("article content changed");
        console.log($(window).height());
        console.log($(".bs-docs-section").height());
        console.log($(".bs-comment-section").height());

        jsbridge.pageReady();
      });
      setFontSize(jsbridge.config.fontSize);
      initBodyEvents();


      if (!jsbridge.config.connectApp) {
        setTimeout(function() {
          // 模拟调用H5注册的接口
          // bridge.mockCallH5Handler("resetData", mockData1, function(data) {
          //   APPLog("app get resp:" + data);
          // });
          // bridge.mockCallH5Handler("resetData", mockData1, function(data) {
          //   APPLog("app get resp:" + data);
          // });
        }, 500);
      }
    });

  }
]);
