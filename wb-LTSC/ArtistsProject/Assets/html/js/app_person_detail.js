// 全局变量
// var CONTEXT_PATH = "http://192.168.0.109:3001";
var CONTEXT_PATH = "http://localhost:3001";
var g_currentPage = 0;
var g_pageSize = 10;
var g_artistId = 3;
var g_hasNextPage = true;
var g_isContentLoaded = false;
var g_isCommentsLoaded = false;
var g_isFavourite = false;
var g_personDetail = "";
var g_personWorls = "";
var g_comments = {};
// 当前所用的字体的尺寸：大中小
var g_currentFontSize = "font-mid";
// 从APP传递过来的初始化参数
var g_initParams;

var g_changeFontConf = {
  "font-especial-big": [
    { "selector": "#article-title", "style": "font-size:26px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:22px!important;" },
    { "selector": ".comment-box", "style": "font-size:22px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:22px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:22px!important;" },
  ],
  "font-big": [
    { "selector": "#article-title", "style": "font-size:24px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:20px!important;" },
    { "selector": ".comment-box", "style": "font-size:20px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:20px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:20px!important;" },
  ],
  "font-mid": [
    { "selector": "#article-title", "style": "font-size:22px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:16px!important;" },
    { "selector": ".comment-box", "style": "font-size:16px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:16px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:16px!important;" },
  ],
  "font-small": [
    { "selector": "#article-title", "style": "font-size:20px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:14px!important;" },
    { "selector": ".comment-box", "style": "font-size:14px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:14px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:14px!important;" },
  ]
};



// var app = angular.module('app', ['infinite-scroll'])
var app = angular.module('app', ['infinite-scroll', 'ngSanitize'])
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
    $scope.personDetail = {};
    $scope.personWorks = [];
    $scope.personInfo = [];
    $scope.personAdvise = [];
    $scope.comments = [];
    $scope.hotComments = [];
    $scope.hasMoreWorkData = false; // 与$scope.canLoadMore 结合控制是否允许加载更多
    $scope.hasMoreInfoData = false; // 与$scope.canLoadMore 结合控制是否允许加载更多
    $scope.hasMoreAdvData = false;
    $scope.hasMoreData = false;
    $scope.comDataTotalNum = 0;
    $scope.workOffset = 0;
    $scope.infoOffset = 0;
    $scope.adviseOffset = 0;
    // $scope.offset = 0;
    $scope.assetsPath = "";
    $scope.canLoadMore = false; // 初始进入页面，不允许加载更多，当页面加载完毕后，才允许加载更多
    $scope.loadMoreBusy = false; // 每次加载更多置为true，加载完毕后，置为false
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


    /*更新人物详情页面，包括人物和评论*/
    function updateData(data) {
      $scope.data = data;
      $scope.personWorks = data.personDetail.workData.items;
      $scope.workOffset = data.personDetail.workData.offset;
      updatePerson(data.personDetail);
      updataHotComments(data.hotComments);
      if (data.comments) {
        updataHotComments(data.comments);
      }
    }

    // 更新人物相关的数据
    function updatePerson(personDetail) {
      $scope.personDetail = personDetail;
      $scope.content = personDetail.lifetime;
      $scope.personDetail.content = $sce.trustAsHtml($scope.content);
    }

    // 更新评论
    function updataHotComments(hotComments) {
      $scope.hotCommentsObj = hotComments;
      $scope.hotComments = hotComments.items;
    }

    // 更新评论
    function updataComments(comments) {
      $scope.commentsObj = comments;
      $scope.comments = comments.items;
      $scope.commentsTotalNum = comments.total;
      $scope.currentPage = comments.p;
      for (var i = 0; i < comments.items.length; i++) {
        comments.items[i].upvoteStatus = 0; // upvoteStatus 0 可点击，1 locked, 2已点赞
      }
      if (comments.total < (comments.p + 1) * comments.pagesize) {
        $scope.hasMoreData = false;
        $scope.disableLoadMore = true;
      } else {
        $scope.hasMoreData = true;
        $scope.disableLoadMore = false;
      }
    }

    // 添加内容
    function appendComData(comData, type) {
      $scope.comDataTotalNum = comData.total;
      // $scope.offse = comData.offset;
      if (type == 4) {
        $scope.personAdvise = $scope.personAdvise.concat(comData.items);
        changeState(comData, type);
        $scope.adviseOffset = comData.offset;
      } else if (type == 2) {
        $scope.personInfo = $scope.personInfo.concat(comData.items);
        changeState(comData, type);
        $scope.infoOffset = comData.offset;
      } else if (type == 1) {
        $scope.personWorks = $scope.personWorks.concat(comData.items);
        changeState(comData, type);
        $scope.workOffset = comData.offset;
      }

    }

    function changeState(comData, type) {

      if (comData.total < comData.offset) {
        if (type == 4) {
          $scope.hasMoreAdvData = false;
        } else if (type == 2) {
          $scope.hasMoreInfoData = false;
        } else if (type == 1) {
          $scope.hasMoreWorkData = false;
        }
        $scope.disableLoadMore = true;
      } else {
        if (type == 4) {
          $scope.hasMoreAdvData = true;
        } else if (type == 2) {
          $scope.hasMoreInfoData = true;
          $scope.infoOffset = comData.offset;
        } else if (type == 1) {
          $scope.hasMoreWorkData = true;
          $scope.workOffset = comData.offset;
        }
        $scope.disableLoadMore = false;
      }
    }

    //tab栏切换事件

    $scope.clickAritistSegment = function(type) {
      $scope.offset = 0;
      var $sectionList = $('.section');
      var $navList = $('.nav-item');
      $navList.removeClass('current');
      $navList.find('.nav-txt').removeClass('current');
      $navList.find('.nav-txt').eq(type - 1).addClass('current');
      $navList.eq(type - 1).addClass('current');
      $sectionList.addClass('hide');
      $sectionList.eq(type - 1).removeClass('hide');
      var request = {
        "type": type
      };
      jsbridge.callNativeForResult("page", "clickAritistSegment", request, function(responseData) {
        responseData = JSON.parse(responseData);
        $scope.safeApply(function() {
          if (type == 1) {
            $scope.personWorks = responseData.items;
            // $scope.hasMoreWorkData = true;
          } else if (type == 2) {
            $scope.personInfo = responseData.items;

            // $scope.hasMoreInfoData = true;
          } else if (type == 4) {
            $scope.personAdvise = responseData.items;

            // $scope.hasMoreAdvData = true;
          }
          changeState(responseData, type);
        });
      });
    }


    $scope.clickAritistItem = function(itemId, itemType) {
      var data = {
        "type": itemType,
        "post_id": itemId
      };
      jsbridge.callNative("page", "clickAritistItem", data);
    }

    $scope.clickPubItem = function(workId) {
      var data = {
        "work_id": workId
      }
      jsbridge.callNative("page", "clickPubItem", data);
    }

    /*基础方法，通过id在指定的评论列表中查找指定的评论，并返回改评论对象*/

    $scope.getCommentById = function(commentId, commentList) {
      for (var i = 0; i < commentList.length; i++) {
        if (commentList[i].comment_id == commentId) {
          return commentList[i];
        }
      }
      return null;
    }

    /*评论点赞:需要传如评论id，和所要搜索的评论列表数组*/
    $scope.upvoteComment = function(commentId, commentsList, $event) {
      $event.stopPropagation();
      var comments = commentsList;
      var comment = $scope.getCommentById(commentId, comments);
      var data = comment;
      // if (comment.is_praise == true) {
      // comment.is_praise = false;
      // comment.praise = comment.praise - 1;
      // } else {
      jsbridge.callNativeForResult("page", "upvoteComment", data, function(responseData) {
        responseData = JSON.parse(responseData);
        $scope.safeApply(function() {
          if (responseData.is_praise) {
            console.log('点赞成功');
            comment.is_praise = true;
            comment.praise = comment.praise + 1;
          } else {
            comment.is_praise = false;
            comment.praise = comment.praise - 1;
          }
        });

      });
      // }
    }

    // 回复评论
    $scope.replyComment = function(commentId, username) {
      var data = {
        "comment_id": commentId,
        "user_name": username
      };

      jsbridge.callNativeForResult("page", "writeReply", data, function(resp) {
        H5Log("原生返回的评论数据 writeReply ", resp);
        // H5Log( $scope.hotComments);
      });
    }

    // 查看个人信息页：传入用户id
    $scope.hotCommentClick = function() {
      // var data = {
      //   "user_id": userId
      // }
      jsbridge.callNative("page", "hotCommentClick");
    }

    // 加载更多内容
    $scope.loadMore = function() {
      if ($scope.loadMoreBusy) {
        return;
      }
      $scope.loadMoreBusy = true;
      H5Log('loadMore');
      var type = parseInt($('.nav-item.current').index()) + 1;
      if (type == 4) {
        var request = {
          "offset": $scope.adviseOffset,
          "type": type
        };
      } else if (type == 2) {
        var request = {
          "offset": $scope.infoOffset,
          "type": type
        };
      } else if (type == 1) {
        var request = {
          "offset": $scope.workOffset,
          "type": type
        };
      }
      // var request = {
      //   "offset": $scope.offset + 1,
      //   "type": type
      // };
      jsbridge.callNativeForResult("page", "loadMoreData", request, function(responseData) {
        H5Log('[getDataByPage callback]');
        responseData = JSON.parse(responseData);
        $timeout(function() {
          appendComData(responseData, type);
          // $scope.$broadcast('scroll.infiniteScrollComplete');
          $scope.loadMoreBusy = false;
        }, 0);
      });
    }

    // 获取需要native app加载的图片url
    function notifyImagesNeedDownload() {
      // 将所有的img的路径提取出来，传给native
      var images = $("#article-content img");
      // H5Log("images count" + images.length);
      var imagePaths = [];
      for (var i = 0; i < images.length; i++) {
        $(images[i]).attr("data-ref-id", i);
        // $(images[i]).attr("src",  "img/placeholder.png"); // android
        $(images[i]).attr("src", $scope.assetsPath + "/html/img/placeholder.png"); // ios
        // imagePaths.push("http://www.adquan.com" + $(images[i]).attr("esrc"));
        // imagePaths.push($(images[i]).attr("esrc"));
        var originSrc = $(images[i]).attr("esrc");
        if (originSrc.indexOf("http") >= 0) {
          imagePaths.push(originSrc);
        } else {
          imagePaths.push("http://www.adquan.com" + originSrc);
        }
      }
      // jsbridge.callNative("page", "imagesNeedDownload", {'imagePaths':imagePaths});
    }

    // FIXME 需要淘汰，目前仅在android中是用
    function initBodyEvents() {
      // 监听屏幕滚动事件
      $("body").scroll(function() {
        // H5Log("a")
        if ($(window).scrollTop() > 1) {}
        jsbridge.callNative("page", "onScreenScroll");
      });
      // 监听人物点击事件 
      $("body:not(#comments)").on("click", function() {
        // jsbridge.callNative("page", "onBodyClicked");
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
        var oldStyle = $(conf["selector"]).attr("style");
        var textIndent = '';
        if (oldStyle) {
          console.log("oldStyle " + oldStyle);
          textIndent = oldStyle.match(/text-indent:.*?;/);
          console.log("old  text indent:" + textIndent);
          if (!textIndent) {
            textIndent = '';
          }
        }
        $(conf["selector"]).attr("style", conf["style"] + textIndent);
      }
    }

    // 设置白天\夜间模式
    function setThemeVersion(theme) {
      if (theme == "NIGHT") {
        $('.container').addClass('container-theme-night');
        $('.artist-intro-box').addClass('artist-intro-night');
        $('.artist-name').addClass('line-night');
        $('.artist-box').addClass('line-night');
        $('body').css({ 'background': '#1c1c1c' });
        $scope.themeStyle = true;
      } else {
        $('.container').removeClass('container-theme-night');
        $('.artist-name').removeClass('line-night');
        $('.artist-box').removeClass('line-night');
        $('.artist-intro-box').removeClass('artist-intro-night');
        $('body').css({ 'background': '#fff' });
        $scope.themeStyle = false;
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
        $scope.fontSize = data;
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
        });
      });

    }
    // 获取APP传来的页面配置：
    // 获取APP传来的页面配置：
    jsbridge.ready(function() {
      // H5Log("jsbridge.ready");
      // H5Log("font size " + jsbridge.config.fontSize);


      initOtherHandlers(jsbridge);

      // jsbridge.callNative("page", "hotCommentClick", 5);

      // jsbridge.callNativeForResult("page", "writeReply", 6, function(commentId) {
      //   APPLog('传入的评论id参数是' + commentId);
      // });




      // 加载页面
      // H5Log(bridge.config);
      setTimeout(function() {
        $scope.$apply(function() {
          console.log('jsbridge.config', jsbridge.config);
          updateData(jsbridge.config);
        });
      }, 1);


      $scope.$watch('personDetail.lifetime', function() {
        console.log("person content changed");
        console.log($(window).height());
        console.log($(".bs-docs-section").height());
        console.log($(".bs-comment-section").height());

        // 当点击人物内容区域里的链接时，跳转新页面显示链接
        // $(".lifetime-intro a").click(function(event) {
        //   var request = {
        //     "url": $(this).attr("href"),
        //     "title": $(this).text(),
        //   };
        //   jsbridge.callNative("page", "loadUrl", request);
        //   return false; // 阻止链接跳转
        // });

        $('.lifetime-intro img').click(function(event) {
          var request = {
            "url": $(this).attr('src'),
          };
          jsbridge.callNative("page", "imageDidClick", request);
        });


        $timeout(function() {
          $scope.canLoadMore = true;
          $scope.disableLoadMore = false;

          if ($scope.personWorks.items!=[]){
              $scope.hasMoreWorkData = true;
          };
        }, 500);
        jsbridge.pageReady();
      });
      $scope.$watch('comments', function() {
        console.log("comment changed");
        setFontSize(jsbridge.config.fontSize);
      });


      notifyImagesNeedDownload();
      setFontSize(jsbridge.config.fontSize);
      console.log(jsbridge.config.themeVersion);
      setThemeVersion(jsbridge.config.themeVersion);

      initBodyEvents();

      setTimeout(function() {
        // $ionicScrollDelegate.scrollTo(0, $("#comment-section").offset().top, true)
        // $ionicScrollDelegate.scrollBottom();
        // var old = $location.hash();
        // $location.hash('bottom');
        // $anchorScroll();
        // $location.hash(old);
      }, 2000);

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
