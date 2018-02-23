var gIsDebug = false; //GlobalConfig.gIsDebug;
var gDebugContainer = '<div id="page_trace"><div id="page_trace_tab"><div id="page_trace_tab_tit"><span>H5</span><span>APP</span></div><div id="page_trace_tab_cont"><div><ol id="h5-logs"></ol></div><div><ol id="app-logs"></ol></div></div></div><div id="page_trace_close"><span>X</span></div></div><div id="page_trace_open"><div>DEBUG</div></div>';
if (gIsDebug) {
  $(document.body).append($(gDebugContainer));
}

(function() {
  if (!gIsDebug) {
    return;
  }
  var tab_tit = document.getElementById('page_trace_tab_tit').getElementsByTagName('span');
  var tab_cont = document.getElementById('page_trace_tab_cont').getElementsByTagName('div');
  var open = document.getElementById('page_trace_open');
  var close = document.getElementById('page_trace_close').childNodes[0];
  var trace = document.getElementById('page_trace_tab');
  // var cookie = document.cookie.match(/show_page_trace=(\d\|\d)/);
  // var history = (cookie && typeof cookie[1] != 'undefined' && cookie[1].split('|')) || [0, 0];
  open.onclick = function() {
    trace.style.display = 'block';
    this.style.display = 'none';
    close.parentNode.style.display = 'block';
    // history[0] = 1;
    // document.cookie = 'show_page_trace=' + history.join('|')
  }
  close.onclick = function() {
    trace.style.display = 'none';
    this.parentNode.style.display = 'none';
    open.style.display = 'block';
    // history[0] = 0;
    // document.cookie = 'show_page_trace=' + history.join('|')
  }
  for (var i = 0; i < tab_tit.length; i++) {
    tab_tit[i].onclick = (function(i) {
      return function() {
        for (var j = 0; j < tab_cont.length; j++) {
          tab_cont[j].style.display = 'none';
          tab_tit[j].style.color = '#999';
        }
        tab_cont[i].style.display = 'block';
        tab_tit[i].style.color = '#000';
        // history[1] = i;
        // document.cookie = 'show_page_trace=' + history.join('|')
      }
    })(i)
  }
  // parseInt(history[0]) && open.click();
  // (tab_tit[history[1]] || tab_tit[0]).click();
  $(tab_tit[0]).trigger("click");
})();
// 将json对象或者json数组转换为字符串
function obj2str(value) {
  var valueType = "";
  if (value != null && typeof value === "object") {
    valueType = "object";
    return JSON.stringify(value);
  }
  return value;
}

var APPLogHooks = [];

// callback接收一个参数logMsg,比如
// addAPPLogHooks(function(logMsg){
//   console.log(logMsg);
// })
function addAPPLogHooks(callback) {
  APPLogHooks.push(callback);
}

function APPLog() {
  var str = [];
  for (var i = 0; i < arguments.length; i++) {
    str[i] = obj2str(arguments[i]);
  }
  var transformedStr = str.join();
  console.log.apply(console, arguments);
  if (gIsDebug) {
    $("#app-logs").append("<li>APPLog: " + transformedStr + "  " + "</li>");
    for (var i = 0; i < APPLogHooks.length; i++) {
      APPLogHooks[i](transformedStr);
    }
  }
}

function H5Log() {
  var str = [];
  for (var i = 0; i < arguments.length; i++) {
    str[i] = obj2str(arguments[i]);
  }
  var transformedStr = "H5Log: " + str.join();
  console.log.apply(console, arguments);
  if (gIsDebug) {
    $("#h5-logs").append("<li>" + transformedStr + "  " + "</li>");
  }
}
