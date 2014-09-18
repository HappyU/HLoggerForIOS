//
//  Logger.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-18.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "Logger.h"

@implementation Logger

void WriteLog(int ulErrorLevel, const char *func, int lineNumber, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    
    NSString *strFormat = [NSString stringWithFormat:@"%@%s, %@%i, %@%@",@"Function: ",func,@"Line: ",lineNumber, @"Format: ",string];
    
    NSString * strModelName = @"WriteLogTest"; //模块名
    
    NSString *strErrorLevel = [[NSString alloc] init];
    switch (ulErrorLevel) {
        case ERR_LOG:
            strErrorLevel = @"Error";
            break;
        case WARN_LOG:
            strErrorLevel = @"Warning";
            break;
        case NOTICE_LOG:
            strErrorLevel = @"Notice";
            break;
        case DEBUG_LOG:
            strErrorLevel = @"Debug";
            break;
        default:
            break;
    }
    NSLog(@"ModalName: %@, ErrorLevel: %@, %@.",strModelName, strErrorLevel, strFormat);
}

@end
