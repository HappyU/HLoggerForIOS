//
//  Logger.h
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-18.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ERR_LOG 1 /* 应用程序无法正常完成操作，比如网络断开，内存分配失败等 */
#define WARN_LOG 2 /* 进入一个异常分支，但并不会引起程序错误 */
#define INFO_LOG 3 /* 日常运行提示信息，比如登录、退出日志 */
#define OPERATE_LOG 4/* 用户的操作轨迹信息，比如开始时间，结束时间 */
#define DEBUG_LOG 5 /* 调试信息，打印比较频繁，打印内容较多的日志 */




//#define LOG_LEVEL_ERROR   (ERR_LOG)
//#define LOG_LEVEL_WARN    (ERR_LOG | WARN_LOG)
//#define LOG_LEVEL_INFO    (ERR_LOG | WARN_LOG | INFO_LOG)
//#define LOG_LEVEL_DEBUG   (ERR_LOG | WARN_LOG | INFO_LOG | DEBUG_LOG |OPERATE_LOG)
//#define LOG_LEVEL_OPERATE (ERR_LOG | WARN_LOG | OPERATE_LOG | INFO_LOG)



typedef NS_ENUM(NSInteger, Level) {
    LEVEL_ERROR = 0,
    LEVEL_WARN = 1,
    LEVEL_INFO  = 2,
    LEVEL_OPERATE  = 3,
    LEVEL_DEBUG  = 4
    
};

//0=error  1=warn  2=info 3=debug 4=opeate
#define LOG_LEVEL 4


#define HLOGERR(format,...) WriteLog(ERR_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGWARN(format,...) WriteLog(WARN_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGINFO(format,...) WriteLog(INFO_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGOPERATE(format,...) WriteLog(OPERATE_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGDEBUG(format,...) WriteLog(DEBUG_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)

void WriteLog(int ulErrorLevel, const char *func, int lineNumber, NSString *format, ...);

//void InfoLog(const char *func,NSString *format, ...);
//
//#define LOGINFO(format,...) InfoLog(__FUNCTION__,format);


#define SAVE_USER(dic) \
NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];\
for (id str in dic.allKeys){\
[userDefault setObject:[dic objectForKey:str] forKey:str];\
}\
[userDefault synchronize];

#define GET_USER(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]


@interface Logger : NSObject

@end
