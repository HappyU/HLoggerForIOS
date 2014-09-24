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

//0=error  1=warn  2=info 3=debug 4=opeate
#define LOG_LEVEL OPERATE_LOG


#define HLOGERR(format,...) WriteLog(ERR_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGWARN(format,...) WriteLog(WARN_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGINFO(format,...) WriteLog(INFO_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGOPERATE(format,...) WriteLog(OPERATE_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define HLOGDEBUG(format,...) WriteLog(DEBUG_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)

void WriteLog(int level, const char *func, int lineNumber, NSString *format, ...);


#define L_LEVEL @"level"
#define L_START @"eventStart"
#define L_END @"eventEnd"
#define L_IP @"IP"
#define L_USREID @"userID"
#define L_NETSTATE @"netstate"
#define L_EVENTID @"eventID"
#define L_EVENTCLASS @"eventClass"
#define L_EVENTCONTENT @"eventContent"
#define L_EVENTDESC @"eventDesc"



#define F_ERROR @"type,eventID,eventContent"
#define F_INFO @"type,eventID,eventContent,eventClass,userID"
#define F_OPERATE @"type,eventID,userID,eventStart,eventEnd,IP,netstate"


@interface Logger : NSObject

@end
