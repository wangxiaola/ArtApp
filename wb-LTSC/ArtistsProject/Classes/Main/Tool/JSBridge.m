//
//  JSBridge.m
//  iOS-WebView-JavaScript
//
//  Created by T on 16/11/3.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "JSBridge.h"

@interface JSBridge ()
@property(nonatomic,strong) NSMutableDictionary *nativeHandlers;
@property(nonatomic,strong) NSMutableDictionary *nativeCallHandlers;
@end

@implementation JSBridge

- (void)onJsBridgeInit{
    __block __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onJsBridgeInit)]) {
            [weakSelf.delegate onJsBridgeInit];
        }
    });
}

- (void)onPageReady{
    __block __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onWebPageReady)]) {
            [weakSelf.delegate onWebPageReady];
        }
    });
}

/**
 * js调用原生 需要返回结果
 */
- (void)callHandlerForResult:(NSString *)msgId module:(NSString *)module handlerName:(NSString *)handlerName data:(id)data{
     __block __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msgId==nil||msgId.length == 0) return;
        if (module==nil||module.length == 0) return;
        if (handlerName==nil||handlerName.length == 0) return;
        
//        callBackResultBlock callbackResult = [self.nativeHandlers objectForKey:[module stringByAppendingString:handlerName]];
//        if (callbackResult==nil) return;
//        
//        id resultData = callbackResult(data);
//        
//        [weakSelf.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsbridge.callResult('%@', '%@');", msgId, resultData]];
        
        callBackResultBlock handler = [self.nativeHandlers objectForKey:[module stringByAppendingString:handlerName]];
        if (handler == nil) {
            return;
        }
        handler([weakSelf dictionaryWithJsonString:data], ^(id resultData){
            NSLog(@"resultData %@", resultData);
             [weakSelf.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsbridge.callResult('%@', '%@');", msgId, resultData]];
        });
    });
    
}

/**
 * js调用原生 无返回结果
 */
- (void)callHandler:(NSString *)module handlerName:(NSString *)handlerName data:(id)data{
    __block __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (module==nil||module.length == 0) return;
        if (handlerName==nil||handlerName.length == 0) return;
        
        callBackBlock callback =  [self.nativeHandlers objectForKey:[module stringByAppendingString:handlerName]];
        if (callback==nil) return;
        callback([weakSelf dictionaryWithJsonString:data]);
    });
    
}

/**
 * js调用原生 返回native需要的结果
 */
- (void)callResult:(NSString *)msgId data:(id)data{
    __block __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
            if (msgId==nil||msgId.length == 0) return;
            callBackBlock callback = self.nativeCallHandlers[msgId];
            if (callback != nil) {
                callback([weakSelf dictionaryWithJsonString:data]);
            }
    });
}

/**
 * native注册需要返回结果的 handler
 */
- (void)registerHandlerForResult:(UIViewController *)vc module:(NSString *)module handlerName:(NSString *)handlerName callbackResult:(callBackResultBlock)callbackResult{
    if (module==nil || module.length == 0) return;
    if (handlerName==nil || handlerName.length == 0) return;
    if (callbackResult==nil) return;
    
    [self.nativeHandlers setObject:callbackResult forKey:[module stringByAppendingString:handlerName]];
}

/**
 * native注册需要无返回结果的 handler
 */
- (void)registerHandler:(NSString *)module handlerName:(NSString *)handlerName callback:(callBackBlock)callback{
    if (module==nil || module.length == 0) return;
    if (handlerName==nil || handlerName.length == 0) return;
    if (callback==nil) return;
    
    [self.nativeHandlers setObject:callback forKey:[module stringByAppendingString:handlerName]];
}

/****************/
//- (void)registerHandlerForResult:(UIViewController *)vc module:(NSString *)module handlerName:(NSString *)handlerName handler:(WVJBHandler)handler{
//    if (module==nil || module.length == 0) return;
//    if (handlerName==nil || handlerName.length == 0) return;
//    if (handler==nil) return;
//    
//     [self.nativeHandlers setObject:handler forKey:[module stringByAppendingString:handlerName]];
//}


/****************/

/**
 * nattive调用js 需要返回结果
 */
- (void)nativeCallH5HandlerForResult:(NSString *)module handlerName:(NSString *)handlerName data:(NSString *)data callback:(callBackBlock)callback{
    if (module==nil || module.length == 0) return;
    if (handlerName==nil || handlerName.length == 0) return;
    if (callback==nil) return;
    
    NSString *msgId = [self uuid];
    [self.nativeCallHandlers setObject:callback forKey:msgId];
    
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsbridge.callHandlerForResult('%@', '%@', '%@', '%@');", msgId, module, handlerName, data]];
}

/**
 * nattive调用js 不需要返回结果
 */
- (void)nativeCallH5Handler:(NSString *)module handlerName:(NSString *)handlerName data:(NSString *)data{
    if (module==nil || module.length == 0) return;
    if (handlerName==nil || handlerName.length == 0) return;
    
     [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsbridge.callHandler('%@', '%@', '%@');", module, handlerName, data]];
}

/**
 * nattive调用js initConfig
 */
- (void)nativeCallJsInitConfig:(NSString *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", data);
        [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsbridge.initConfig(%@);", data]];
    });
}

- (void)registerModule:(id<ModuleProtocol>)module{
    [module registerHandlers:self];
}

- (void)unregisterModuleName:(NSString *)moduleName{
    for (NSString *key in self.nativeHandlers.allKeys) {
        if ([key containsString:moduleName] ) {
            [self.nativeHandlers removeObjectForKey:key];
        }
    }
}

- (NSString *)uuid{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (NSMutableDictionary *)nativeHandlers{
    if (!_nativeHandlers) {
        _nativeHandlers = [NSMutableDictionary dictionary];
    }
    return _nativeHandlers;
}

- (NSMutableDictionary *)nativeCallHandlers{
    if (!_nativeCallHandlers) {
        _nativeCallHandlers = [NSMutableDictionary dictionary];
    }
    return _nativeCallHandlers;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:0
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}

- (void)dealloc{
    NSLog(@"===JSBridge dealloc");
}
@end
