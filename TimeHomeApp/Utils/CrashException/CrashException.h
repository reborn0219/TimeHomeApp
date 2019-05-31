//
//  CrashException.h
//  CrashKit
//
//  Created by us on 15/10/27.
//
//
/**
 异常捕获类，用于收集错误
 **/
#import <Foundation/Foundation.h>
extern NSString *const UncaughtExceptionHandlerSignalKey;
extern NSString *const SingalExceptionHandlerAddressesKey;
extern NSString *const ExceptionHandlerAddressesKey;

@protocol CrashSaveDelegate
- (void)onCrash:(NSDictionary *)infos;
@end

@interface CrashException : NSObject

@property (nonatomic, assign) id <CrashSaveDelegate> delegate;
@property BOOL finishPump;//结束标志


- (void)pumpRunLoop;//保持运行
- (void)installExceptionHandler;//注册异常捕获
- (NSArray *)backtrace;//获取堆栈信息

+ (CrashException*)sharedInstance;//单例

- (void)handleSignal:(NSDictionary*)userInfo;//unix信号错误
- (void)handleNSException:(NSDictionary*)userInfo;//object-c错误
@end
