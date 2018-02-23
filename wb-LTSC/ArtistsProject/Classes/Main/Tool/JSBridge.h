//
//  JSBridge.h
//  iOS-WebView-JavaScript
//
//  Created by T on 16/11/3.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//--changed   typedef id(^callBackResultBlock)(NSString *);  typedef void(^callBackBlock)(NSString *);
typedef void(^callBackBlock)(id data);
typedef void(^callBackResultBlock)(id data, callBackBlock);


//typedef void (^WVJBResponseCallback)(id responseData);
//typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@class JSBridge;
@protocol ModuleProtocol
-(void)registerHandlers:(JSBridge *)jsbridge;
@end

@protocol JSBridgeDelegate <NSObject>
@optional
- (void)onJsBridgeInit;
-(void)onWebPageReady;
@end

@protocol JSBridgeExport <JSExport>
- (void)onJsBridgeInit;
- (void)onPageReady;
//--changed  data:(NSString *)data
JSExportAs
(callHandlerForResult,
 - (void)callHandlerForResult:(NSString *)msgId module:(NSString *)module handlerName:(NSString *)handlerName data:(id)data
 );
//--changed  data:(NSString *)data
JSExportAs
(callResult,
 - (void)callResult:(NSString *)msgId data:(id)data
 );
//--changed  data:(NSString *)data
JSExportAs
(callHandler,
 - (void)callHandler:(NSString *)module handlerName:(NSString *)handlerName data:(id)data
 );
@end

@interface JSBridge : NSObject<JSBridgeExport>
@property (nonatomic, weak) id<JSBridgeDelegate> delegate;
@property (nonatomic, weak) UIWebView  *webview;

#pragma mark - 注册handler
- (void)registerHandlerForResult:(UIViewController *)vc module:(NSString *)module handlerName:(NSString *)handlerName callbackResult:(callBackResultBlock)callbackResult;
- (void)registerHandler:(NSString *)module handlerName:(NSString *)handlerName callback:(callBackBlock)callback;

//- (void)registerHandlerForResult:(UIViewController *)vc module:(NSString *)module handlerName:(NSString *)handlerName handler:(WVJBHandler)handler;

#pragma mark - native
-(void)nativeCallH5HandlerForResult:(NSString*)module handlerName:(NSString *)handlerName data:(NSString *)data callback:(callBackBlock)callback ;
-(void)nativeCallH5Handler:(NSString*)module handlerName:(NSString *)handlerName data:(NSString *)data;
- (void)nativeCallJsInitConfig:(NSString *)data;

#pragma mark - module 注册
- (void)registerModule:(NSObject *)module;
- (void)unregisterModuleName:(NSString *)moduleName;
@end

