/**
 * Benbun jsbridge v2
 * 此版本，在Android设备上，使用webview的接口实现js和原生通信
 * 在iOS设备上，使用webview的context
 * maintainer: kongweixian@benbun.com, lilingbin@benbun.com
 */
(function(global, factory) {

  if (typeof module === "object" && typeof module.exports === "object") {
    // FOR CommonJS
    // e.g. var JSBridge = require("jquery")(window);
    module.exports = global.document ?
      factory(global, true) :
      function(w) {
        if (!w.document) {
          throw new Error("JSBridge requires a window with a document");
        }
        return factory(w);
      };
  } else {
    factory(global);
  }
}(typeof window !== "undefined" ? window : this, function(window, noGlobal) {


  var strundefined = typeof undefined;

  var version = "2.0.0";

  // 初始化
  var JSBridge = function(config) {
    return new JSBridge.fn.init(config);
  };

  JSBridge.fn = JSBridge.prototype = {
    version: version,
    constructor: JSBridge,
  };

  if (!window.APPLog) {
    window.APPLog = function() {
      console.log.apply(console, arguments);
    }
    window.H5Log = window.APPLog;
  }

  // jQuery的extend方法
  JSBridge.extend = JSBridge.fn.extend = function() {
    var options, name, src, copy, copyIsArray, clone,
      target = arguments[0] || {},
      i = 1,
      length = arguments.length,
      deep = false;

    // Handle a deep copy situation
    if (typeof target === "boolean") {
      deep = target;

      // Skip the boolean and the target
      target = arguments[i] || {};
      i++;
    }

    // Handle case when target is a string or something (possible in deep copy)
    if (typeof target !== "object" && !JSBridge.isFunction(target)) {
      target = {};
    }

    // Extend JSBridge itself if only one argument is passed
    if (i === length) {
      target = this;
      i--;
    }

    for (; i < length; i++) {
      // Only deal with non-null/undefined values
      if ((options = arguments[i]) != null) {
        // Extend the base object
        for (name in options) {
          src = target[name];
          copy = options[name];

          // Prevent never-ending loop
          if (target === copy) {
            continue;
          }

          // Recurse if we're merging plain objects or arrays
          if (deep && copy && (JSBridge.isPlainObject(copy) || (copyIsArray = JSBridge.isArray(copy)))) {
            if (copyIsArray) {
              copyIsArray = false;
              clone = src && JSBridge.isArray(src) ? src : [];

            } else {
              clone = src && JSBridge.isPlainObject(src) ? src : {};
            }

            // Never move original objects, clone them
            target[name] = JSBridge.extend(deep, clone, copy);

            // Don't bring in undefined values
          } else if (copy !== undefined) {
            target[name] = copy;
          }
        }
      }
    }

    // Return the modified object
    return target;
  };

  // 生成uuid
  var UUID = (function() {
    var lut = [];
    for (var i = 0; i < 256; i++) {
      lut[i] = (i < 16 ? '0' : '') + (i).toString(16);
    }

    function e7() {

      var d0 = Math.random() * 0xffffffff | 0;
      var d1 = Math.random() * 0xffffffff | 0;
      var d2 = Math.random() * 0xffffffff | 0;
      var d3 = Math.random() * 0xffffffff | 0;
      return lut[d0 & 0xff] + lut[d0 >> 8 & 0xff] + lut[d0 >> 16 & 0xff] + lut[d0 >> 24 & 0xff] + '-' +
        lut[d1 & 0xff] + lut[d1 >> 8 & 0xff] + '-' + lut[d1 >> 16 & 0x0f | 0x40] + lut[d1 >> 24 & 0xff] + '-' +
        lut[d2 & 0x3f | 0x80] + lut[d2 >> 8 & 0xff] + '-' + lut[d2 >> 16 & 0xff] + lut[d2 >> 24 & 0xff] +
        lut[d3 & 0xff] + lut[d3 >> 8 & 0xff] + lut[d3 >> 16 & 0xff] + lut[d3 >> 24 & 0xff];
    }
    return {
      next: e7,
    }
  }());



  // 判断是否为json对象
  function isObject(data) {
    if (data != null && typeof data === "object" && !(data instanceof Array)) {
      return true;
    } else {
      return false;
    }
  }

  // 将两个object合并
  function mergeObject(origin, newData) {
    if (typeof(newData) == "string") {
      try {
        newData = JSON.parse(newData);
      } catch (e) {
        return;
      }
    }
    if (!isObject(newData)) {
      return;
    }
    for (var attr in newData) {
      JSBridge.config[attr] = newData[attr];
    }
  }


  // 创建假webview bridge
  // 针对mock webview bridge对外暴露的添加假app handler的方法
  var mockAppHandlers = {};
  var mockH5Handlers = {};
  var mockJsOnResultCallbacks = {};

  var jsOnResultCallbacks = {};

  // 存储js代码注册的handlername和function的映射关系
  // handlername => function
  var h5Handlers = {};

  // 对于mock测试使用的一些操作元语
  JSBridge.fn.extend({
    // 保存mock文件中，模拟的APP的handler
    addMockAppHander: function(handlerName, callback) {
      mockAppHandlers[handlerName] = callback;
    },
    // 模拟APP调用H5注册的接口
    mockCallH5Handler: function(handlerName, data, callback) {
      mockH5Handlers[handlerName](data, callback);
    },

    // H5调用模拟App注册的接口
    mockCallAppHandler: function(handlerName, data, callback) {
      console.log("mockCallAppHandler method:" + handlerName);
      console.log(mockAppHandlers);
      mockAppHandlers[handlerName](data, callback);
    },

    // 供mock使用，模拟设置config数据
    setConfig: function(otherConfig) {
      if (!JSBridge.config.connectApp) {
        // 添加新配置变量到JSBridge.config中
        mergeObject(JSBridge.config, otherConfig);
      }
    },
  });

  // 当没有连接真实的手机APP时，创建一个appBridge
  // 提供和原生的appBridge相同的操作元语：
  // callHandler，callResult，callHandlerForResult
  function initMockWebViewJavascriptBridge() {
    APPLog("initMockWebViewJavascriptBridge");
    appBridge = {
      callHandler: function(module, handlerName, data) {
        APPLog("MockWebViewJavascriptBridge callHandler:" + handlerName + ", data:" + data);
        if (mockAppHandlers[handlerName] != null) {
          var callback = mockAppHandlers[handlerName];
          callback(data, function(result) {
            console.log("xxx xxx " + result);
          });
        }
      },

      callResult: function(handlerId, resultData) {
        var callback = mockH5Handlers[handlerId];
        if (callback != null) {
          callback(resultData);
        }
      },

      //  对原生开发者暴露的方法
      callHandlerForResult: function(msgId, module, handlerName, data) {
        // H5Log('原生 调用 js');
        if (!isObject(data)) {
          data = JSON.parse(data);
        }
        // H5Log('原生传给js数据===' + msgId + module + handlerName + data);

        var callback = mockAppHandlers[handlerName];
        if (callback == null) {
          return;
        }

        callback(data, function(result) {
          return jsbridge.callResult(msgId, result);
        });
      },
    }; // end appBridge

    // 页面数据加载成功后的回调
    mockAppHandlers["onPageLoaded"] = function(param, callback) {
      // APPLog("call onPageLoaded");
    };
  }

  function setTimeoutForMockReadyCallback() {
    // 调用on ready事件
    if (JSBridge.config.mockReadyTimeout > 0) {
      setTimeout(function() {
        // appBridge = window.jsbridge;
        isWebViewJavascriptBridgeInited = true;
        doDefaultOnReady();
      }, JSBridge.config.mockReadyTimeout);
    }
  }



  var isWebViewJavascriptBridgeInited = true;
  var appBridge = null;


  JSBridge.config = {
    connectApp: true, //GlobalConfig.connectApp,
    mockReadyTimeout: 100,
  };

  // === 初始化主函数 ===
  // config参数格式需为json object
  var init = JSBridge.fn.init = function(config) {
    APPLog("JSBridge init!");
    // 如果是对象，添加到JSBridge.config 中
    mergeObject(JSBridge.config, config);
    APPLog("after merge " + JSON.stringify(JSBridge.config));

    // 如果不连接到APP，进行测试，由网页模拟创建一个提供
    // 和原生__jsbridge相同操作元语的js对象
    if (!JSBridge.config.connectApp) {
      initMockWebViewJavascriptBridge();
      return;
    }
    // 如果连接到APP，将appBridge指向原生创建的__jsbridge
    appBridge = __jsbridge;

    // 通知原生代码，html已加载jsbridge插件
    // 接下来，原生将会调用js initConfig
    appBridge.onJsBridgeInit();

    return this;
  };

  // Give the init function the JSBridge prototype for later instantiation
  init.prototype = JSBridge.fn;

  // 标记callOnReadyCallbacks是否已经被调用过
  var isOnReadyCallbacksCalled = false;
  var onReadyCallbacks = [];
  // 默认的当bridge初始化结束后要做的事
  function doDefaultOnReady() {
    // APPLog("doDefaultOnReady");

    // 如果是模拟链接APP，直接调用onready回调
    if (!JSBridge.config.connectApp) {
      callOnReadyCallbacks();
      return;
    }

    if (!isOnReadyCallbacksCalled) {
      isOnReadyCallbacksCalled = true;
      callOnReadyCallbacks();
    }
  }

  // 当bridge加载成功后的回调
  function callOnReadyCallbacks() {
    APPLog("callOnReadyCallbacks");
    for (var i = 0; i < onReadyCallbacks.length; i++) {
      var fn = onReadyCallbacks[i];
      fn(appBridge);
    }
    onReadyCallbacks = [];
  }

  // 提供jsbridge和原生代码进行交互的接口
  JSBridge.fn.extend({

    // 原生设置jsbridge的初始化参数
    initConfig: function(config) {
      // H5Log("initConfig");
      if (!isObject(config)) {
        config = JSON.parse(config);
      }
      //     H5Log(JSON.stringify(config));
      mergeObject(JSBridge.config, config);
      doDefaultOnReady();
      // callOnReadyCallbacks();
    },


    // 原生调用h5的handler
    callHandler: function(module, handlerName, data) {
       // H5Log("===="+data);
      if (!isObject(data)) {
        data = JSON.parse(data);
      }
       // H5Log("原生 调用 js callHandler");
      var callback = h5Handlers[handlerName];

      if (callback != null) {
        // H5Log("----- js callHandler");
        callback(data);
      }
    },

    // 原生调用h5的handler, 并要求js返回一个调用结果
    // 需要传入原生代码生成的msgId
    callHandlerForResult: function(msgId, module, handlerName, data) {
      ('原生 调用 js');
      if (!isObject(data)) {
        data = JSON.parse(data);
      }
      // H5Log('原生传给js数据===' + msgId + module + handlerName + data);
      var callback = h5Handlers[handlerName];

      if (callback == null) {
        return;
      }

      callback(data, function(result) {
        appBridge.callResult(msgId, JSON.stringify(result));
      });
    },


    // 原生代码通过调用此方法将调用结果返回给js
    callResult: function(handlerId, resultData) {
      // H5Log("-------------------" + resultData);
      var callback = jsOnResultCallbacks[handlerId];
      if (callback != null) {
        callback(resultData);
      }
    },

  });



  // 提供jsbridge和h5业务代码进行交互的接口
  JSBridge.fn.extend({
    // 获取config数据
    config: JSBridge.config,

    // js代码通知原生，页面已经完成数据加载
    pageReady: function() {
      if (!JSBridge.config.connectApp) {
        return;
      }
      // H5Log("JS加载完成");
      appBridge.onPageReady();
    },

    // js业务代码调用，转发给原生代码执行，要求返回一个调用结果
    callNativeForResult: function(module, handlerName, data, onResultCallback) {
      // H5Log("callNativeForResult ===========");

      var msgId = UUID.next();
      jsOnResultCallbacks[msgId] = onResultCallback;
      // H5Log('callHandlerForResult');
      appBridge.callHandlerForResult(msgId, module, handlerName, JSON.stringify(data));
    },

    // js业务代码调用，转发给原生代码执行，不需返回调用结果
    callNative: function(module, handlerName, data) {
      // H5Log("js 调 原生 callHandler" + module, handlerName, data);
      appBridge.callHandler(module, handlerName, JSON.stringify(data));
    },


    // 添加bridge加载成功后的事件
    // eg.
    // bridge.ready(function(){
    //   H5Log("on ready callback");
    // }
    ready: function(callback) {
      // 添加到js bridge ready之后的回调函数数组
      APPLog("add on ready callback");
      onReadyCallbacks.push(callback);
      // 如果onReady事件之前已经调用过，直接调用
      if (isOnReadyCallbacksCalled) {
        callback(appBridge);
      }

      if (!this.config.connectApp) {
        setTimeoutForMockReadyCallback();
      }
    },

    // 向APP注册一个函数
    // eg.
    // bridge.registerHandler(this, "newHandlerDemo", function(data, responseCallback) {
    //   APPLog("newHandlerDemo is called");
    //   var responseData = "newHandlerDemo finished";
    //   responseCallback(responseData);
    // }
    addHandler: function(context, module, handlerName, callback) {

      h5Handlers[handlerName] = callback;
    },
  });







  // for amd start
  if (typeof define === "function" && define.amd) {
    define("jsbridge", [], function() {
      return JSBridge;
    });
  }
  // Map over JSBridge in case of overwrite
  var _JSBridge = window.JSBridge;
  JSBridge.noConflict = function(deep) {
    if (deep && window.JSBridge === JSBridge) {
      window.JSBridge = _JSBridge;
    }
    return JSBridge;
  };
  if (typeof noGlobal === strundefined) {
    window.JSBridge = JSBridge;
  }
  // for amd end


  return JSBridge;

}));
