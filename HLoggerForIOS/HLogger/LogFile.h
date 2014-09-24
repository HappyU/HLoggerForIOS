//
//  LogFile.h
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-22.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//
typedef NS_ENUM(NSInteger, Type) {
    TypeDoc = 0,
    TypeCache = 1,
    TypeTemp = 2
};

typedef NS_ENUM(NSInteger, Location) {
    LocationEnd = 0,
    LocationBegin = 1
};

typedef NS_ENUM(NSInteger, Tactics){
    TacticsDay = 0,
    TacticsEveryUpload = 1
};

typedef  void(^packageInfo)();


@interface LogFile : NSObject

//单例
+(LogFile *)getInstance;

//往文件中插入内容
-(void)writeContent:(NSMutableData *)contentData withLocation:(Location) location;

//往文件中插入内容，并判断文件的大小
-(void)writeContent:(NSMutableData *)contentData withLocation:(Location) location withOverSize:(packageInfo)packageBlock;

@end
