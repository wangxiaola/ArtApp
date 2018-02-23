$.support.cors = true;

// 全局变量
// var CONTEXT_PATH = "http://192.168.0.109:3001";
var CONTEXT_PATH = "http://localhost:3001";
var g_articleId = 31946;
var g_currentPage = 0;
var g_pageSize = 10;
var g_hasNextPage = true;
var g_isContentLoaded = false;
var g_isCommentsLoaded = false;
var g_isFavourite = false;
var g_articleDetail = "";
var g_comments = {};
// 当前所用的字体的尺寸：大中小
var g_currentFontSize = "font-mid";
// 从APP传递过来的初始化参数
var g_initParams;

var g_changeFontConf = {
  "font-big": [
    {"selector": "#article-title", "style":"font-size:32px!important;color:#333333;"},
    {"selector": "span", "style":"font-size:22px!important;"},
    {"selector": ".comment-box", "style":"font-size:22px!important;line-height:1.5;"},
    {"selector": ".post-comment-name", "style":"font-size:22px!important;"},
    {"selector": ".total-comment-text", "style":"font-size:22px!important;"},
  ],
  "font-mid": [
    {"selector": "#article-title", "style":"font-size:30px!important;color:#333333;"},
    {"selector": "span", "style":"font-size:20px!important;"},
    {"selector": ".comment-box", "style":"font-size:20px!important;line-height:1.5;"},
    {"selector": ".post-comment-name", "style":"font-size:20px!important;"},
    {"selector": ".total-comment-text", "style":"font-size:20px!important;"},
  ],
  "font-small": [
    {"selector": "#article-title", "style":"font-size:28px!important;color:#333333;"},
    {"selector": "span", "style":"font-size:18px!important;"},
    {"selector": ".comment-box", "style":"font-size:18px!important;line-height:1.5;"},
    {"selector": ".post-comment-name", "style":"font-size:18px!important;"},
    {"selector": ".total-comment-text", "style":"font-size:18px!important;"},
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



// 对WebViewJavascriptBridge重命名
JSBridge = new Object();
JSBridge.call = function(method, param, callback) {
    console.log("method:" + method + ", param:" + param);
  }
  // init web js bridge
function connectWebViewJavascriptBridge(callback) {
  if (window.WebViewJavascriptBridge) {
    callback(WebViewJavascriptBridge);
  } else {
    document.addEventListener(
      'WebViewJavascriptBridgeReady',
      function() {
        callback(WebViewJavascriptBridge);
      },
      false
    );
  }
}

connectWebViewJavascriptBridge(function(bridge) {
  // alert("js bridge inited");
  bridge.init(function(message, responseCallback) {
    console.log('JS got a message' + message);
    var data = {
      'Javascript Responds': 'Wee!'
    };
    console.log('JS responding with' + data);
    responseCallback(data);
  });

  JSBridge.call = function(method, param, callback) {
    window.WebViewJavascriptBridge.callHandler(method, param, callback);
  }


  bridge.registerHandler("initGlobal", function(data, responseCallback) {
    console.log("ios/android call js: = " + data);
    if (typeof(data) == "string") {
      data = JSON.parse(data);
    }
    g_initParams = data;
    // 初始化全局变量
    initGlobal(data);

    // 加载页面
    initPage();
    if (data["fontSize"]) {
      g_currentFontSize = data["fontSize"];
      setFontSize();
    } else {
      setFontSize();
    }
    var responseData = "initGlobal finished";
    responseCallback(responseData);
  });

  initOtherHandlers(bridge);
});

function initOtherHandlers(bridge) {
  // 注册刷新comment事件
  bridge.registerHandler("refreshComment", function(data, responseCallback) {
    refreshComment(data);
  });

  // 跳转到页面的评论位置
  bridge.registerHandler("jumpToComments", function(data, responseCallback) {
    window.location.href = "#comment-section";
  });

  // 设置字体大小
  bridge.registerHandler("setFontSize", function(data, responseCallback) {
    g_currentFontSize = data;
    setFontSize();
  });

  // 加载本地缓存图片
  bridge.registerHandler("setImgLocalPath", function(data, responseCallback) {
    console.log("ios/android call js: = " + data);
    if (typeof(data) == "string") {
      data = JSON.parse(data);
    }
    // android
    //data.path = "content://com.adquan.adquan.provider.localfile" + data.path;
    $("#article-content img[data-ref-id=" + data.index + "]").attr("src", data.path);
  });

  // 评论成功后，将评论内容直接添加到评论后面
  bridge.registerHandler("appendComment", function(data, responseCallback) {
    if (typeof(data) == "string") {
      data = JSON.parse(data);
    }

    var commentTpl = $("#comment-tpl").html();
    var template = _.template(commentTpl);

    var html = template(data);
    $("#comments").append(html);
  });

  // 重新加载评论
  bridge.registerHandler("initComments", function(data, responseCallback) {
    if (typeof(data) == "string") {
      data = JSON.parse(data);
    }
    g_comments = data;
    initComments(data);
  });
}

// 初始化页面变量
function initGlobal(data) {
//  alert(JSON.stringify(data));
  
  if (data["CONTEXT_PATH"]) {
    CONTEXT_PATH = data["CONTEXT_PATH"];
  }
  if (data["g_articleId"]) {
    g_articleId = data["g_articleId"];
  }
  if (data["g_isFavourite"] != null) {
    g_isFavourite = data["g_isFavourite"];
  }
  if (data["g_articleDetail"] != null) {
    if (typeof(data["g_articleDetail"]) == "string") {
      data["g_articleDetail"] = JSON.parse(data["g_articleDetail"]);
    }
    g_articleDetail = data["g_articleDetail"];
  }

  if (data["comments"] != null) {
    if (typeof(data["comments"]) == "string") {
      data["comments"] = JSON.parse(data["comments"]);
    }
    g_comments = data["comments"];
  }

  console.log("now contaxt path :" + CONTEXT_PATH);
  console.log("articleId" + g_articleId);
}

// 使用jsonp协议获取文章信息，现已废弃
function getDetailOld() {
  $.ajax({
    url: CONTEXT_PATH + '/news/post/' + g_articleId,
    type: 'get',
    dataType: 'jsonp',
    contentType: "application/json",
    cache: false,
    success: function(resp) {
      console.log('success:');
      // alert(JSON.stringify(resp));
      // 填充文章内容和点赞数
      $("#article-title").html(resp['data']["article"]["title"]);
      var content = resp['data']["article"]["content"];
      content = content.replace(/src=\"\/upload_img/g,"src=\"http://www.adquan.com/upload_img");
      $("#article-content").html(content);

      var averageStar = 5;
      if (averageStar != null && averageStar >= 0 && averageStar <= 5) {
        // 平均星级
        $(".article-rating div.star").eq(5-averageStar).addClass("current");
      }

  
      // $("span").removeAttr("style");
      g_currentFontSize = "font-mid";
      setFontSize();
      // $("span").css("font-size","18px!important;");
      console.log(resp['data']["article"]["upvote"]);
      console.log(resp['data']["article"]["downvote"]);

      var data = {
        'upvote': resp['data']["article"]["upvote"],
      };

      $('#article-praise-favorite-cnt .upvote-num').html(data["upvote"]);
      $(".praise-btn").on("click", upvoteArticle);
      $(".favorite-btn").on('click', favorArticle);

      g_isContentLoaded = true;
      checkPageLoadFinished();
      // console.log(JSON.stringify(resp));
      // console.log(resp);
    },
    error: function(resp) {
      // console.log('error:');
      // console.log(JSON.stringify(resp));
      alert(JSON.stringify(resp));
    }
  });
}



function getDetail() {
  // 标题
  $("#article-title").html(g_articleDetail["article"]["title"]);
  $("#article-clicked-cnt").html(g_articleDetail["article"]["clicked"]);
  $("#article-comment-cnt").html(g_articleDetail["article"]["zan"]);
  $(".article-post-time").html(g_articleDetail["article"]["postTime"]);
  $(".author-name").html(g_articleDetail["article"]["author"]);
  // 参与评星人数
  $(".grade-people-cnt").html(g_articleDetail["article"]["starnum"]);
  var averageStar = g_articleDetail["article"]["star"];
  if (averageStar != null && averageStar >= 0 && averageStar <= 5) {
    // 平均星级
    for (var i = 0; i < averageStar; i++) {
      $(".article-rating div.star").eq(4 - i).addClass("current");
    }
  }
  // 如果之前已经评过分，则在我的评分的星星上进行高亮
  var mystar = g_articleDetail["article"]["mystar"];
  if (mystar && mystar >= 0 && mystar <= 5) {
    var stars = $(".my-rating div.star");
    for (var i = 0; i < mystar; i++) {
      stars.eq(4 - i).addClass("highlighted");
    }
  }
  
  // 如果是新闻资讯，需要标注文章分类
  if (g_articleDetail["article"]["type"] == 1) { // 新闻资讯
    var cateName = g_cateMap["" + g_articleDetail["article"]["cate"]];
    if (cateName) {
      $(".average-grade").html(cateName);
    } else {
      $(".average-grade").html("其他");
    }
    $(".average-grade").css({border:'1px solid red','padding-left':'5px','padding-right':'5px'});
  }
  var content = g_articleDetail["article"]["content"];

  // 将图片的src路径换为本地图片
  //content = content.replace(/src=\".*?\"/g, "src=\"" + g_initParams["assetsPath"] + "/html/img/placeholder.png\"");
  //content = content.replace(/src=\"\/upload/g, "src=\"http://www.adquan.com/upload");
  $("#article-content").html(content);
  // 将所有的img的路径提取出来，传给native
  var images = $("#article-content img");

  var imagePaths = [];
  for (var i = 0; i < images.length; i++) {
    $(images[i]).attr("data-ref-id", i);
    // $(images[i]).attr("src",  "img/placeholder.png"); // android
    $(images[i]).attr("src", g_initParams["assetsPath"] + "/html/img/placeholder.png"); // ios
    var originSrc = $(images[i]).attr("esrc");
    if (originSrc.indexOf("http") >= 0) {
      imagePaths.push(originSrc);
    } else {
      imagePaths.push("http://www.adquan.com" + originSrc);
    }
    
  }

  JSBridge.call("imagesNeedDownload", imagePaths, function(responseData) {});
  // $("span").removeAttr("style");
  // $("span").css("font-size","18px!important;");
  console.log(g_articleDetail["article"]["upvote"]);
  console.log(g_articleDetail["article"]["downvote"]);

  var data = {
    'upvote': g_articleDetail["article"]["upvote"],
  };

  $('#article-praise-favorite-cnt .upvote-num').html(data["upvote"]);
  $(".praise-btn").on("click", upvoteArticle);
  $(".favorite-btn").on('click', favorArticle);

  // 当点击文章内容区域里的链接时，跳转新页面显示链接
  $("#article-content a").click(function(event) {
    var request = {
      "url" : $(this).attr("href"),
      "title": $(this).text(),
    };
    JSBridge.call("loadUrl", request, function(responseData) {});
    return false;// 阻止链接跳转
  });

  JSBridge.call("onPageLoaded", "", function(responseData) {});
  scrollBottomTest();
}

// 页面第一次加载时，直接从app中获取到评论信息
function initComments(comments) {
  $("#comments").html("");
  var total = comments["total"];
  // 评论总数
  if (total <= 0) {
    $(".total-comment-text").html('<div class="div-inline gray-color">暂无评论</div>');
  } else {
    $(".total-comment-text").html('<div class="div-inline">' + total + '条评论</div>');
  }


  console.log("total" + total);
  console.log("p" + comments["p"]);
  console.log("pagesize" + comments["pagesize"]);
  if (total < (g_currentPage + 1) * g_pageSize) {
    g_hasNextPage = false;
    $("#load-more").css("display", "none");
  } else {
    $("#load-more").css("display", "block");
  }
  renderComment(comments['items']);

}

// 使用jsonp获取评论，已废弃
function getCommentsOld() {
  if (g_hasNextPage) {
    g_currentPage = g_currentPage + 1;
  } else {
    alert("没有更多评论了");
    console.log("no next page");
    return;
  }
  $.ajax({
    url: CONTEXT_PATH + '/news/comments/' + g_articleId,
    type: 'get',
    data: {'aid': g_articleId, "p":g_currentPage, "pagesize": g_pageSize},
    dataType: 'jsonp',
    contentType: "application/json",
    cache: false,
    success: function(resp) {
      console.log('success:');
      // $("#article-title").html(resp['data']["article"]["title"]);
      // $("#article-content").html(resp['data']["article"]["content"]);
      // console.log(JSON.stringify(resp));

      // console.log(resp);
      var total = resp["data"]["total"];
      console.log("total" + total);
      console.log("p" + resp["data"]["p"]);
      console.log("pagesize" + resp["data"]["pagesize"]);
      if (total < (g_currentPage + 1) * g_pageSize) {
        g_hasNextPage = false;
      }
      renderComment(resp["data"]['items']);
      g_isCommentsLoaded = true;
      checkPageLoadFinished();
    },
    error: function(data) {
      console.log('error:');
      console.log(JSON.stringify(data));
    }
  });
}


function getComments() {
  if (g_hasNextPage) {
    g_currentPage = g_currentPage + 1;
    $("#load-more").css("display", "block");
  } else {
    $("#load-more").css("display", "none");
    if (g_currentPage > 1) {
//      JSBridge.call("noMoreComments", null, function(responseData) {});
    }
    console.log("no next page");
    return;
  }
  var data = {
    'aid': g_articleId,
    "p": g_currentPage,
    "pagesize": g_pageSize
  };
  JSBridge.call("getComments", data, function(comments) {
//    alert(comments);
    if (typeof(comments) == "string") {
      comments = JSON.parse(comments);
    }

    var total = comments["total"];
    console.log("total" + total);
    console.log("p" + comments["p"]);
    console.log("pagesize" + comments["pagesize"]);
    if (total < (g_currentPage + 1) * g_pageSize) {
      g_hasNextPage = false;
      $("#load-more").css("display", "none");
    } else {
      $("#load-more").css("display", "block");
    }
    renderComment(comments['items']);
  });
}

function renderComment(comments) {
  var commentDividerTpl = $("#comment-divider-tpl").html();
  var commentTpl = $("#comment-tpl").html();
  var template = _.template(commentTpl);

  var html = ""; //commentTpl + commentDividerTpl + commentTpl;
  for (var i = 0; i < comments.length; i++) {
    var comment = comments[i];
    // var date = comments[i]["time"].split(" ", 2)[0];
    // comment["time"] = date;
    comment["upvote"] = shortNum(comment["upvote"]);
    console.log(comment["username"]);
    html += template(comment);
    if (i < comments.length - 1) {
      html += commentDividerTpl;
    }
  }
  $("#comments").append(html);
  $('.comment-body').each(function() {
    console.log('s')
    if ($(this).find('.comment-box').height() == $(this).find('.comment-cont').height()) {
      $(this).find('.comment-over').hide();
      $(this).removeClass('compression')
    }
  });
  // 设置字号
  setFontSize();

  $(".upvote-comment").off('click');
  $(".reply-comment").off("click");
  $("img.headimg").off("click");

  $(".upvote-comment").on('click', upvoteComment);
  $(".reply-comment").on("click", function() {
    replyComment($(this));
    return false;
  });
  $("img.headimg").on("click", readUserinfo);
}


function checkPageLoadFinished() {
  if (g_isContentLoaded && g_isCommentsLoaded) {
    JSBridge.call("onPageLoaded", "", function(responseData) {});
  }
}

function upvoteArticle() {
  console.log("upvoteArticle");
  $this = $(this);
  $this.off("click");
  var flag = $(this).attr('data-praised')
  $praiseBtn = $(this);


  JSBridge.call("upvoteArticle", null, function(responseData) {
    if (flag == 0) {
      $('.img-praise').attr('src', 'img/great.png');
      $(".praise-btn .upvote-num").html(parseInt($(".praise-btn .upvote-num").html()) + 1);
      $praiseBtn.attr('data-praised', 1)
    } else if (flag == 1) {
      $('.img-praise').attr('src', 'img/great_o.png');
      $(".praise-btn .upvote-num").html(parseInt($(".praise-btn .upvote-num").html()) - 1);
      $praiseBtn.attr('data-praised', 0)
    }
    $this.on('click', upvoteArticle);
  });
}

// 收藏或取消收藏
function favorArticle() {
  console.log("favorArticle");
  g_isFavourite = !g_isFavourite;

  if (g_isFavourite) {
    $('.img-favorite').attr('src', 'img/heart.png');
  } else {
    $('.img-favorite').attr('src', 'img/heart_o.png');
  }

  JSBridge.call("favorArticle", "", function(responseData) {
    console.log('send get responseData from java, data = ' + responseData, true);
  });
}

function upvoteComment() {
  console.log($(this).parent().attr("data-id"));
  var commentId = $(this).parent().attr("data-id");
  $this = $(this);
  $this.off("click");
  $upvoteBtn = $(this).parent();
  var flag = $upvoteBtn.attr('data-upvote');


  JSBridge.call("upvoteComment", commentId, function(responseData) {
    var selector = ".comment-item-right[data-id=" + commentId + "] .num-upvote";
    var numVote = parseInt($(selector).html());
    if (flag == 0) {
      // $upvoteBtn.find('.img-upvote').attr('src', 'img/great.png');
      $(selector).html(numVote + 1);
      $upvoteBtn.attr('data-upvote', 1);
    // } else if (flag == 1) {
    //   $upvoteBtn.find('.img-upvote').attr('src', 'img/great_o.png');
    //   if (numVote > 0) {
    //     $(selector).html(numVote - 1);
    //   }
    //   $upvoteBtn.attr('data-upvote', 0);
    }
    // $this.on('click', upvoteComment);
    $this.off('click');
  });
}

// 回复评论
function replyComment(elem) {
  $this = $(this);
  if (elem) {
    $this = elem;
  }
  console.log($this.parent().attr("data-id"));
  var commentId = $this.parent().attr("data-id");
  var username = $this.parent().parent().find("div.post-comment-name").html().trim();
  console.log(username);
  var data = {
    "commentId": commentId,
    "userName": username
  };
  JSBridge.call("writeReply", data, function(responseData) {
    console.log('send get responseData from java, data = ' + responseData, true);
  });
}

function readUserinfo() {
    console.log($(this).attr("data-id"));
    var userId = $(this).attr("data-id");

    JSBridge.call("readUserinfo", userId, function(responseData) {
  console.log('send get responseData from java, data = ' + responseData, true);
  });
}

function refreshComment() {
  // 去掉点击事件
  $(".upvote-comment").off('click');
  $(".reply-comment").off("click");
  $("img.headimg").off("click");
  // 清空评论
  $("#comments").html("");
  // 重置初始参数
  g_currentPage = 0;
  g_hasNextPage = true;
  // 获取评论
  getComments();
}


function initPage() {
  // 监听屏幕滚动事件
  $("body").scroll(function() {
    if ($(window).scrollTop() > 1) {}
    JSBridge.call("onScreenScroll", null, function(responseData) {
      console.log('send get responseData from java, data = ' + responseData, true);
    });
  });
  // 监听文章点击事件
  $("body:not(#comments)").on("click", function() {
    JSBridge.call("onBodyClicked", null, function(responseData) {});
  });
  // 根据当前是否已经收藏过来显示不同的样式
  if (g_isFavourite) {
    $('.img-favorite').attr('src', 'img/heart.png');
  } else {
    $('.img-favorite').attr('src', 'img/heart_o.png');
  }
  
  // getDetailOld();
  // getCommentsOld();
  getDetail();
  initComments(g_comments);
  $("#set-font .font-mid").addClass("font-current");
  $("#set-font .font-big").on("click", function() {
    g_currentFontSize = "font-big";
    setFontSize();
  });
  $("#set-font .font-mid").on("click", function() {
    g_currentFontSize = "font-big";
    setFontSize();
  });
  $("#set-font .font-small").on("click", function() {
    g_currentFontSize = "font-small";
    setFontSize();
  });
  // 初始化评星级事件
  $(".my-rating div.star").on("click", function() {
    $star = $(this);
    var starPoint = 5 - $star.index();
    var data = {"grade": starPoint}

    JSBridge.call("gradeArticle", data, function(resp) {
      if (typeof(resp) == "string" && resp == "true") {
        resp = true;
      }
      if (resp) {
        $(".my-rating div.star.current").removeClass("current");
        $(".my-rating div.star.highlighted").removeClass("highlighted");

        $star.addClass("current");

        console.log("index:" + starPoint);
        var stars = $(".my-rating div.star");
        for (var i = 0; i < starPoint; i++) {
          stars.eq(4 - i).addClass("highlighted");
        }
      }
    });
  });
}

function setFontSize() {
  $(".set-font.font-current").removeClass("font-current");
  if (g_changeFontConf[g_currentFontSize] == null
      || g_changeFontConf[g_currentFontSize].length <= 0) {
    return;
  }
  for (var i = 0; i < g_changeFontConf[g_currentFontSize].length; i++) {
    var conf = g_changeFontConf[g_currentFontSize][i];
    $(conf["selector"]).attr("style", conf["style"]);
  }
  $("." + g_currentFontSize).addClass("font-current");
}

//initPage();

function scrollBottomTest() {
  $(document).scroll(function() {
    var $this =$(this),
    viewH =document.body.clientHeight,//可见高度
    contentH =$(document).height(),//内容高度
    scrollTop =$(document).scrollTop();//滚动高度
    if (scrollTop/(contentH -viewH) >= 0.95) { //到达底部100px时,加载新内容
      // 加载数据
      getComments();
    }
  });
}

$("#load-more").on("click", function() {
  // getCommentsOld();
  getComments();
})
console.log("articleId:" + g_articleId);
