//
//  AppDelegate.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-16.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "AppDelegate.h"
#import "Logger.h"
#import "LogFile.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>

// 系统信号截获处理方法
void signalHandler(int signal);
// 异常截获处理方法
void exceptionHandler(NSException *exception);
const int32_t _uncaughtExceptionMaximum = 10;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    installExceptionHandler();
    
//    [self redirectNSLogToDocumentFolder];
    
    HLOGINFO(@"3333%@,%@",@"ddddsf",@"mmmmm");
    
    const char *func = __FUNCTION__;
    NSString *classAndMethodStr = [NSString stringWithFormat:@"%s",func];
    NSLog(@"classAndMethod = %@",classAndMethodStr);
    
    NSArray *arr = [NSArray arrayWithObject:@"11"];
    
    NSString *aa = [arr objectAtIndex:10];

    LogFile *logFile = [[LogFile alloc] init];
    [logFile createLogFile];
    
    
    NSData *abc = [@"456" dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData *data = [[NSMutableData alloc]initWithData:abc];
    NSMutableData *data = [NSMutableData dataWithData:abc];
    [logFile writeContent:data withLocation:LocationBegin];


    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void signalHandler(int signal)
{
    
    volatile int32_t _uncaughtExceptionCount = 0;
    int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
    if (exceptionCount > _uncaughtExceptionMaximum) // 如果太多不用处理
    {
        return;
    }
    
    // 获取信息
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:@"UncaughtExceptionHandlerSignalKey"];
    
    NSArray *callStack = [AppDelegate backtrace];
    [userInfo  setObject:callStack  forKey:@"SingalExceptionHandlerAddressesKey"];
    
    // 现在就可以保存信息到本地［］
}

void exceptionHandler(NSException *exception)
{
    /*
     volatile int32_t _uncaughtExceptionCount = 0;
     int32_t exceptionCount = OSAtomicIncrement32(&_uncaughtExceptionCount);
     if (exceptionCount > _uncaughtExceptionMaximum) // 如果太多不用处理
     {
     return;
     }
     
     NSArray *callStack = [UncaughtExceptionHandler backtrace];
     NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
     [userInfo setObject:callStack forKey:@"ExceptionHandlerAddressesKey"];
     
     // 现在就可以保存信息到本地［］
     */
    
    NSArray *callStackSymbols = [exception callStackSymbols];
    NSString *callStackSymbolStr = [callStackSymbols componentsJoinedByString:@"\n"];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
//    DDLogError(@"异常 >>");
//    DDLogError(@"异常名称：%@",name);
//    DDLogError(@"异常原因：%@",reason);
//    DDLogError(@"堆栈标志：%@",callStackSymbolStr);
    
    NSString *string = [NSString stringWithFormat:@"%@+%@+%@",name,reason,callStackSymbols];
    
    
    HLOGERR(string);
    
}

//获取调用堆栈
+(NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0;i<frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

// 注册崩溃拦截
void installExceptionHandler()
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

- (void)redirectNSLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    
}



@end
