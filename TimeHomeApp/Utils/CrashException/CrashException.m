//
//  CrashException.m
//  CrashKit
//
//  Created by us on 15/10/27.
//
//

#import "CrashException.h"
#import "SysPresenter.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
NSString *const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString *const SingalExceptionHandlerAddressesKey = @"SingalExceptionHandlerAddressesKey";
NSString *const ExceptionHandlerAddressesKey = @"ExceptionHandlerAddressesKey";

const int32_t _uncaughtExceptionMaximum = 20;

// 系统信号截获处理方法
void signalHandler(int signal);

// 异常截获处理方法
void exceptionHandler(NSException *exception);

void signalHandler(int signal)
{
    volatile int32_t _uncaughtExceptionCount = 0;
    int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
    
    // 如果太多不用处理
    if (exceptionCount > _uncaughtExceptionMaximum) {
        return;
    }
    CrashException *crash = [CrashException sharedInstance];
    // 获取信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [crash backtrace];
    [userInfo  setObject:callStack  forKey:SingalExceptionHandlerAddressesKey];
//    NSLog(@"=signalHandler==%@",userInfo);
    // 现在就可以保存信息到本地［］
    
    [crash performSelectorOnMainThread:@selector(handleSignal:) withObject:userInfo waitUntilDone:YES];
    
}

void exceptionHandler(NSException *exception)
{
    volatile int32_t _uncaughtExceptionCount = 0;
    int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
    
    // 如果太多不用处理
    if (exceptionCount > _uncaughtExceptionMaximum) {
        return;
    }
    CrashException *crash = [CrashException sharedInstance];
    NSArray *callStack = [crash backtrace];
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:ExceptionHandlerAddressesKey];
    [userInfo setObject:arr forKey:@"callStackSymbols"];
    [userInfo setObject:exception.name forKey:@"name"];
    [userInfo setObject:exception.reason forKey:@"reason"];
//    NSLog(@"Exception Invoked: %@", userInfo);
//    NSLog(@"=exceptionHandler==%@",exception);
    // 现在就可以保存信息到本地［］
    
    [crash performSelectorOnMainThread:@selector(handleNSException:) withObject:userInfo waitUntilDone:YES];

    
}

static CrashException *sharedInstance = nil;
@implementation CrashException

+ (CrashException*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[CrashException alloc] init];
        
    }
    return sharedInstance;
}

- (void)pumpRunLoop
{
    self.finishPump = NO;
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef runLoopModesRef = CFRunLoopCopyAllModes(runLoop);
    NSArray * runLoopModes = (__bridge NSArray*)runLoopModesRef;
    
    while (self.finishPump == NO)
    {
        for (NSString *mode in runLoopModes)
        {
            CFStringRef modeRef = (__bridge CFStringRef)mode;
            CFRunLoopRunInMode(modeRef, 1.0f/120.0f, false);  // Pump the loop at 120 FPS
        }
    }
    
    CFRelease(runLoopModesRef);
}

//获取调用堆栈
- (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0;i<frames;i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


// 注册崩溃拦截
- (void)installExceptionHandler
{
    NSSetUncaughtExceptionHandler(&exceptionHandler);
    signal(SIGHUP, signalHandler);
    signal(SIGINT, signalHandler);
    signal(SIGQUIT, signalHandler);
    signal(SIGABRT, signalHandler);
    signal(SIGILL, signalHandler);
    signal(SIGSEGV, signalHandler);
    signal(SIGFPE, signalHandler);
    signal(SIGBUS, signalHandler);
    signal(SIGPIPE, signalHandler);
}

- (void)handleSignal:(NSDictionary*)userInfo
{
    
    NSLog(@"%@",userInfo);
    
    if (self.delegate)
        [self.delegate onCrash:userInfo];
   
    SysPresenter * sysPresenter=[[SysPresenter alloc]init];
    [sysPresenter saveAppError:[NSString stringWithFormat:@"%@",userInfo]];
//      [self pumpRunLoop];
}

- (void)handleNSException:(NSDictionary*)userInfo
{
    
    NSLog(@"%@",userInfo);

    if (self.delegate)
        [self.delegate onCrash:userInfo];
    SysPresenter * sysPresenter=[[SysPresenter alloc]init];
    [sysPresenter saveAppError:[NSString stringWithFormat:@"%@",userInfo]];
//    [self pumpRunLoop];
    

}


@end
