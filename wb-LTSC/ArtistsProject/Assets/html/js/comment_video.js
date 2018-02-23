// 全局变量
// var CONTEXT_PATH = "http://192.168.0.109:3001";
var CONTEXT_PATH = "http://localhost:3001";
var g_articleId = 31946;
var g_currentCommentsPage = 0;
var g_pageSize = 10;
var g_hasNextPage = true;
var g_isContentLoaded = false;
var g_isCommentsLoaded = false;
var g_isFavourite = false;
var g_videoDetail = "";
var g_comments = {};
// 当前所用的字体的尺寸：大中小
var g_currentFontSize = "font-mid";
// 从APP传递过来的初始化参数
var g_initParams;
var H5Log = window.H5Log;

var g_changeFontConf = {
  "font-especial-big": [
    { "selector": "#article-title", "style": "font-size:34px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:24px!important;" },
    { "selector": ".comment-box", "style": "font-size:24px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:24px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:24px!important;" },
  ],
  "font-big": [
    { "selector": "#article-title", "style": "font-size:32px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:22px!important;" },
    { "selector": ".comment-box", "style": "font-size:22px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:22px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:22px!important;" },
  ],
  "font-mid": [
    { "selector": "#article-title", "style": "font-size:30px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:20px!important;" },
    { "selector": ".comment-box", "style": "font-size:20px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:20px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:20px!important;" },
  ],
  "font-small": [
    { "selector": "#article-title", "style": "font-size:28px!important;color:#333333;" },
    { "selector": "span", "style": "font-size:18px!important;" },
    { "selector": ".comment-box", "style": "font-size:18px!important;line-height:1.5;" },
    { "selector": ".post-comment-name", "style": "font-size:18px!important;" },
    { "selector": ".total-comment-text", "style": "font-size:18px!important;" },
  ]
};

var g_cateMap = {
  "1": "人事",
  "2": "观察",
  "3": "代理",
  "4": "奖项",
  "5": "媒介",
  "6": "培训",
  "9": "对话",
  "10": "案例",
  "13": "数据",
  "15": "有单",
  "16": "开眼",
  "18": "技术",
  "28": "讲师",
  "0": "其他"
}

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





// angular.module('ionicApp', ['ionic'])
//   .controller('MainCtrl', ['$scope', '$timeout', '$http', '$ionicScrollDelegate', '$ionicGesture', function($scope, $timeout, $http, $ionicScrollDelegate) {




app.controller('MainCtrl', ['$scope', '$sce', '$timeout', '$location', '$anchorScroll',
  function($scope, $sce, $timeout, $location, $anchorScroll) {
    $scope.data = {};
    $scope.videoDetail = {};
    $scope.hotCommentsList = [];
    $scope.commentsList = [];
    $scope.hasMoreComments = false; // 与$scope.canLoadMore 结合控制是否允许加载更多
    $scope.commentsTotalNum = 0;
    $scope.currentCommentsPage = {};
    $scope.assetsPath = "";
    $scope.themeStyle = false; //主题样式，NORMAL设为false，NIGHT设为true
    $scope.canLoadMore = false; // 初始进入页面，不允许加载更多，当页面加载完毕后，才允许加载更多
    $scope.loadMoreBusy = false; // 每次加载更多置为true，加载完毕后，置为false

    $scope.onBodyScroll = function() {

      }
      /* 安全执行函数，执行完毕进行脏检查 */
    $scope.safeApply = function(task) {
      setTimeout(function() {
        $scope.$apply(function() {
          task();
        });
      }, 1);
    }

    // 文章点赞
    $scope.upvoteArticle = function(is_praise) {
      if ($scope.videoDetail.upvoteStatus == 1) {
        return;
      } else {
        $scope.videoDetail.upvoteStatus = 1;
      }
      var data = {
        'is_praise': is_praise
      };
      // H5Log("data " + JSON.stringify(data));
      // console.log("data " + JSON.stringify(data));
      jsbridge.callNativeForResult("page", "upvoteArticle", data, function(resp) {
        resp = JSON.parse(resp);
        // H5Log("upvoteArticle " + resp);
        // console.log(resp);
        $scope.safeApply(function() {
          if (resp.is_praise) {
            $scope.videoDetail.praise++;
            $scope.videoDetail.is_praise = true;
          } else {
            $scope.videoDetail.praise--;
            $scope.videoDetail.is_praise = false;
          }
          $scope.videoDetail.upvoteStatus = 0;
        });
      });
    }

    /*为评论点赞，传入 comment对象*/
    $scope.upvoteComment = function(comment) {
      //upvoteStatus: 0可点击 1 locked, 2已点赞
      // H5Log("comment " + comment);
      if (comment.upvoteStatus == 1) {
        return;
      } else {
        comment.upvoteStatus = 1;
      }
      var data = {
        'comment_id': comment.comment_id,
        'is_praise': comment.is_praise
      };
      jsbridge.callNativeForResult("page", "upvoteComment", data, function(resp) {
        resp = JSON.parse(resp);
        // H5Log('upvoteComment  resp' + resp);
        // console.log(resp);
        $scope.safeApply(function() {
          if (resp.is_praise) {
            comment.praise++;
            comment.is_praise = true;
          } else {
            comment.praise--;
            comment.is_praise = false;
          }
          comment.upvoteStatus = 0;
        });
      });
    }

    /*基础方法，通过id在指定的评论列表中查找指定的评论，并返回改评论对象*/
    $scope.getCommentIndexById = function(commentId, commentList) {
      if (!commentList || commentList.length == 0) {
        return null;
      };
      for (var i = 0; i < commentList.length; i++) {
        if (commentList[i].comment_id == commentId) {
          return i;
        }
      }
      return null;
    }

    // 回复评论
    $scope.replyComment = function(comment, type, parentCommentId) {
      // console.log('comment:' + comment + '----type:' + type + '----parentCommentId:' + parentCommentId);
      var data = {
        'comment_id': comment.comment_id,
        'to_uid': comment.uid,
        'main_comment_id': parentCommentId,
        'content': comment.comment_content
      };

      jsbridge.callNativeForResult("page", "writeReply", data, function(resp) {
        // console.log("原生返回的评论数据 writeReply " + resp);
        H5Log("writeReply " + resp);
        resp = JSON.parse(resp);
        $scope.safeApply(function() {
          var parentCommentsList;
          if (type == 'comment') {
            parentCommentsList = $scope.commentsList;
          } else {
            parentCommentsList = $scope.hotCommentsList;
          }
          var parentIndex = $scope.getCommentIndexById(parentCommentId, parentCommentsList);
          var curtCommentsList = parentCommentsList[parentIndex].reply_comments.items;
          if (!curtCommentsList || curtCommentsList.length == 0) {
            curtCommentsList = [];
            curtCommentsList.push(resp);
          } else {
            var curtIndex = $scope.getCommentIndexById(comment.comment_id, curtCommentsList);
            if (curtIndex) {
              curtIndex++;
              curtCommentsList.splice(curtIndex, 0, resp);
            } else {
              curtCommentsList.push(resp);
            }
          }
          parentCommentsList[parentIndex].reply_comments.reply_comments_num += 1;
          parentCommentsList[parentIndex].reply_comments.items = curtCommentsList;
          if (type == 'comment') {
            $scope.commentsList = parentCommentsList;
          } else {
            $scope.hotCommentsList = parentCommentsList;
          }
        });

      });
    }

    // 查看所有评论
    $scope.showAllReply = function(comment_id, type) {
      var data = {
        "comment_id": comment_id
      };

      jsbridge.callNativeForResult("page", "commentAllReply", data, function(resp) {
        resp = JSON.parse(resp);
        // console.log("原生返回的评论数据 commentAllReply " + resp);
        $scope.safeApply(function() {
          var parentCommentsList;
          if (type == 'comment') {
            parentCommentsList = $scope.commentsList;
          } else {
            parentCommentsList = $scope.hotCommentsList;
          }
          var parentIndex = $scope.getCommentIndexById(comment_id, parentCommentsList);
          var curtCommentsList = parentCommentsList[parentIndex].reply_comments.items;
          curtCommentsList = curtCommentsList.concat(resp.reply_comments);
          parentCommentsList[parentIndex].reply_comments.items = curtCommentsList;
          parentCommentsList[parentIndex].reply_comments.hasmore = resp.hasmore;
          if (type == 'comment') {
            $scope.commentsList = parentCommentsList;
          } else {
            $scope.hotCommentsList = parentCommentsList;
          }
        });
      });
    }

    // 查看个人信息页
    $scope.readUserinfo = function(userId, anonymity) {
      var data = {
        'uid': userId,
        'anonymity': anonymity
      };
      jsbridge.callNative("page", "readUserinfo", data);
    }

    // 加载更多评论
    $scope.loadMore = function() {
      if ($scope.loadMoreBusy) {
        return;
      }
      $scope.loadMoreBusy = true;
      var data = $scope.currentCommentsPage;
      // H5Log('loadMore' + data);
      console.log('loadMore' + data);
      jsbridge.callNativeForResult("page", "loadMoreComment", data, function(resp) {
        resp = JSON.parse(resp);
        console.log('loadMore resp' + resp);
        // H5Log('getDataByPage callback' + resp);
        $scope.safeApply(function() {
          appendComments(resp);
          // $scope.$broadcast('scroll.infiniteScrollComplete');
          $scope.loadMoreBusy = false;
        });
      });
    }

    // 刷新热门评论
    function refreshHotComments(comments) {
      // H5Log(hotComments.items);
      for (var i = 0; i < comments.items.length; i++) {
        if (comments.items[i].is_praise) {
          comments.items[i].upvoteStatus = 2; // upvoteStatus 0 可点击，1 locked, 2已点赞
        } else {
          comments.items[i].upvoteStatus = 0;
        }
        if (comments.items[i].anonymity == 1) {
          comments.items[i].nickname = "匿名";
          comments.items[i].avatar = "../img/default.png";
        }
        //将空回复列表赋成空数组
        if (!comments.items[i].reply_comments.items || comments.items[i].reply_comments.items.length == 0) {
          comments.items[i].reply_comments.items = [];
        } else {
          for (var j = 0, len = comments.items[i].reply_comments.items.length; j < len; j++) {
            var replyItem = comments.items[i].reply_comments.items[j];
            if (replyItem.anonymity == 1) {
              replyItem.nickname = "匿名";
            }
            if (replyItem.reply_anonymity == 1) {
              replyItem.nickname = "匿名";
            }
          }
        }
      }
      $scope.hotCommentsList = comments.items;
      // console.log($scope.hotCommentsList);
    }

    // 刷新评论
    function refreshComments(comments) {
      // H5Log(comments.items);
      // console.log(comments);
      $scope.commentsTotalNum = comments.total;
      $scope.currentCommentsPage = {
        'offset': comments.offset,
        'pagesize': comments.pagesize
      };
      for (var i = 0; i < comments.items.length; i++) {
        if (comments.items[i].is_praise) {
          comments.items[i].upvoteStatus = 2; // upvoteStatus 0 可点击，1 locked, 2已点赞
        } else {
          comments.items[i].upvoteStatus = 0;
        }
        if (comments.items[i].anonymity == 1) {
          comments.items[i].nickname = "匿名";
          comments.items[i].avatar = "../img/default.png";
        }
        if (!comments.items[i].reply_comments.items || comments.items[i].reply_comments.items.length == 0) {
          comments.items[i].reply_comments.items = [];
        } else {
          for (var j = 0, len = comments.items[i].reply_comments.items.length; j < len; j++) {
            var replyItem = comments.items[i].reply_comments.items[j];
            if (replyItem.anonymity == 1) {
              replyItem.nickname = "匿名";
            }
            if (replyItem.reply_anonymity == 1) {
              replyItem.nickname = "匿名";
            }
          }
        }
      }

      if (comments.total <= comments.offset) {
        $scope.hasMoreComments = false;
        $scope.disableLoadMore = true;
      } else {
        $scope.hasMoreComments = true;
        $scope.disableLoadMore = false;
      }

      $scope.commentsList = comments.items;
      // console.log($scope.commentsList);
      $scope.commentsTotalNum = comments.total;
      // H5Log($scope.comments.length);
    }

    $scope.appendComments = appendComments;

    /*加载更多评论*/
    function appendComments(comments) {
      $scope.commentsTotalNum = comments.total;
      $scope.currentCommentsPage = {
        'offset': comments.offset,
        'pagesize': comments.pagesize
      };
      for (var i = 0; i < comments.items.length; i++) {
        if (comments.items[i].is_praise) {
          comments.items[i].upvoteStatus = 2; // upvoteStatus 0 可点击，1 locked, 2已点赞
        } else {
          comments.items[i].upvoteStatus = 0;
        }
        if (comments.items[i].anonymity == 1) {
          comments.items[i].nickname = "匿名";
          comments.items[i].avatar = "";
        }
        if (!comments.items[i].reply_comments.items || comments.items[i].reply_comments.items.length == 0) {
          comments.items[i].reply_comments.items = [];
        } else {
          for (var j = 0, len = comments.items[i].reply_comments.items.length; j < len; j++) {
            var replyItem = comments.items[i].reply_comments.items[j];
            if (replyItem || replyItem.anonymity == 1) {
              replyItem.nickname = "匿名";
            }
            if (replyItem.reply_anonymity == 1) {
              replyItem.nickname = "匿名";
            }
          }
        }
      }
      // H5Log(comments.items)

      if (comments.total <= comments.offset) {
        $scope.hasMoreComments = false;
        $scope.disableLoadMore = true;
      } else {
        $scope.hasMoreComments = true;
        $scope.disableLoadMore = false;
      }

      $scope.commentsList = $scope.commentsList.concat(comments.items);
      // H5Log($scope.comments.length);
    }

    // 初始化文章相关的数据
    function initVideoData() {
      var videoDetail = $scope.data.videoDetail;
      $scope.videoDetail = videoDetail;
      if (videoDetail.is_praise) {
        $scope.videoDetail.upvoteStatus = 2; // upvoteStatus 0 可点击，1 locked, 2已点赞
      } else {
        $scope.videoDetail.upvoteStatus = 0;
      }
      // $scope.videoDetail.content = $sce.trustAsHtml(videoDetail.post_content);
    }

    /* 初始化评论相关数据 */
    function initBeginCommentsData(data) {
      refreshHotComments(data.hotComments);
      refreshComments(data.comments);
    }

    function updateData(data) {
      $scope.data = data;
      initVideoData(data.videoDetail);
      initBeginCommentsData(data)
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
      jsbridge.callNative("page", "imagesNeedDownload", {
        'imagePaths': imagePaths
      });
    }

    // FIXME 需要淘汰，目前仅在android中是用
    function initBodyEvents() {
      // 监听屏幕滚动事件
      $("body").scroll(function() {
        // H5Log("a")
        if ($(window).scrollTop() > 1) {}
        jsbridge.callNative("page", "onScreenScroll");
      });
      // 监听文章点击事件 
      $("body:not(#comments)").on("click", function() {
        jsbridge.callNative("page", "onBodyClicked");
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

    // 设置白天\夜间模式
    function setThemeVersion(theme) {
      if (theme == "NIGHT") {
        $('body').css({ 'background': '#1c1c1c' });
        $scope.themeStyle = true;
      } else {
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
        // H5Log("jumpToCommentsxxxx");
        // window.location.href = "#comment-section";
        // $ionicScrollDelegate.scrollTo(0, $("#comment-section").offset().top, true);
        // $ionicScrollDelegate.scrollBottom();
        var old = $location.hash();
        $location.hash('bottom');
        $anchorScroll();
        $location.hash(old);
      });

      // 添加最新评论
      jsbridge.addHandler(this, "page", "writeComment", function(data) {
        // console.log('loadMore data' + data);
        // H5Log('getDataByPage callback' + JSON.stringify(data));
        $scope.safeApply(function() {
          $scope.commentsList.unshift(data);
        });
      });

      // 设置字体大小
      jsbridge.addHandler(this, "page", "setFontSize", function(data) {
        $scope.fontSize = data;
        setFontSize(data);
      });

      // 加载本地缓存图片
      jsbridge.addHandler(this, "page", "setImgLocalPath", function(data) {
        // H5Log("ios/android call js: = " + data);
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
      jsbridge.pageReady();

      setThemeVersion(jsbridge.config.themeVersion);
      setFontSize(jsbridge.config.fontSize);

      initOtherHandlers(jsbridge);

      // 加载页面
      // H5Log(bridge.config);
      $scope.safeApply(function() {
        updateData(jsbridge.config);
      });

      notifyImagesNeedDownload();

      // return;

      $scope.$watch('commentsList', function() {
        console.log("commentsList changed");
        $timeout(function() {
          $scope.canLoadMore = true;
          $scope.disableLoadMore = false;
        }, 500);
      });

      // 当点击文章内容区域里的链接时，跳转新页面显示链接
      $("#article-content a").click(function(event) {
        var request = {
          "url": $(this).attr("href"),
          "title": $(this).text(),
        };
        console.log(request);
        jsbridge.callNative("page", "loadUrl", request);
        return false; // 阻止链接跳转
      });


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
