//
//  LogFile.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-22.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "LogFile.h"

@implementation LogFile

//获取存放路径
-(NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"logs"];
    return cachePath;
}

-(void)readSetInfo
{
    NSString *cachePath = [self getCachePath];
}

//文件是否存在
-(BOOL)isExistFile:(NSString *)fileName
{
    
    return NO;
}



@end
