//
//  LogFile.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-22.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "LogFile.h"


typedef NS_ENUM(NSInteger, Type) {
    TypeDoc = 0,
    TypeCache = 1,
    TypeTemp = 2
};

//0=doc  1=cache  2=temp
#define LOG_PATH 0
//文件失效时间设置
#define FILE_VALIDITY_DATE
//文件大小设置
#define FILE_VALIDITY_SIZE
//文件输出级别设置
#define LOG_LEVEL 




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

//验证文件有效时间
-(BOOL)validityDate:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir = [fileManager enumeratorAtPath:[self getFolderPath]];
    NSString *file;
    while (file = [dir nextObject]) {

        NSLog(@"%@",file);
//        if ([[file lastPathComponent] isEqualToString:fileName] )
//        {
//            
//        }
    }
    
    return NO;
}

//创建日志文件
-(void)createLogFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *logName = [self createLogName];
    NSString *path = [self getFolderPath];
    NSString *filePath = [path stringByAppendingPathComponent:logName];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}

//创建日志名称
-(NSString *)createLogName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYYMMdd_HH:mm:ss"];
    NSString *stringDate = [formatter stringFromDate:[NSDate date]];
    stringDate = [NSString stringWithFormat:@"log%@.txt",stringDate];
    return stringDate;
}

//验证文件大小
-(void)validitySize:(NSString *)fileName
{
    
}

-(void)readSetInfo
{
    NSString *cachePath = [self getFolderPath];
}

//文件是否存在
-(BOOL)isExistFile:(NSString *)fileName
{
    
    return NO;
}



@end
