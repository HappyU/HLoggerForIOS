//
//  LogFile.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-22.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "LogFile.h"






//0=doc  1=cache  2=temp
#define LOG_PATH 0
//文件大小设置
#define FILE_VALIDITY_SIZE
//文件输出级别设置
#define LOG_LEVEL 

//文件产生策略 1=每天生成，
#define LOG_TACTICS 0
//文件上传策略

#define LOG_CUR_PATH @"savePath"


@implementation LogFile

//获取存放路径（Doc，Cache，Temp）
-(NSString *)getFolderPath
{
    NSString *path = @"";
    if (LOG_PATH == TypeDoc)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
    }
    else if (LOG_PATH == TypeCache)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
    }
    else if (LOG_PATH == TypeTemp)
    {
        path = NSTemporaryDirectory();
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths objectAtIndex:0];
    }
    path = [path stringByAppendingPathComponent:@"logs"];
    return path;
}

//创建日志文件
-(void)createLogFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:[self getFolderPath] isDirectory:&isDir];
    if(!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:[self getFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];


        NSString *logPath = [self readLogPath];
        if (logPath == nil || [logPath isEqualToString:@""])
        {
            [self createFile];
        }
        else
        {
            if (LOG_TACTICS == TacticsDay)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"YYYYMMdd"];
                NSString *curDate = [formatter stringFromDate:[NSDate date]];
                NSString *logDate = [logPath substringToIndex:[logPath rangeOfString:@"_"].location];
                if (![curDate isEqualToString:logDate])
                {
                    [self createFile];
                }
            }
        }
    }
}

//创建文件
-(void)createFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *logName = [self createLogName];
    NSString *path = [self getFolderPath];
    NSString *filePath = [path stringByAppendingPathComponent:logName];
    if (![fileManager fileExistsAtPath:filePath])
    {
        BOOL isCreate = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (isCreate)
        {
            [self writeLogPath:filePath];
        }
    }
}

//创建日志名称
-(NSString *)createLogName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYYMMdd_HHmmss"];
    NSString *stringDate = [formatter stringFromDate:[NSDate date]];
    stringDate = [NSString stringWithFormat:@"%@.log",stringDate];
    return stringDate;
}

//验证文件大小
-(void)validitySize:(NSString *)fileName
{
    
}

//往文件中插入内容
-(void)writeContent:(NSData *)contentData withLocation:(Location) location
{
    NSString *logPath = [self readLogPath];
    NSFileHandle *writeFile = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (location == LocationBegin)
    {
        [writeFile seekToFileOffset:0];
    }
    else
    {
        [writeFile seekToEndOfFile];
    }
    [writeFile writeData:contentData];
    [writeFile closeFile];
}

//读取日志的路径信息
-(NSString *)readLogPath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *logPath = [userDefault objectForKey:LOG_CUR_PATH];
    return logPath;
}

//写入日志的路径信息
-(void)writeLogPath:(NSString *)filePath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:filePath forKey:LOG_CUR_PATH];
    [userDefault synchronize];
}


@end
