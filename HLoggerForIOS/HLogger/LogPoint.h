//
//  LogPoint.h
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-16.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogPoint : NSObject


/**
 *  获取App应用名称
 *
 *  @return App应用名称
 */
+(NSString *)getAppName;

/**
 *  获取App应用版本
 *
 *  @return App应用版本
 */
+(NSString *)getAppVersion;

/**
 *  获取设备类别
 *
 *  @return 设备类别
 */
+(NSString *)getDeviceType;

/**
 *  获取设备运行系统
 *
 *  @return 设备运行系统
 */
+(NSString *)getSysName;

/**
 *  获取设备系统版本
 *
 *  @return 设备系统版本
 */
+(NSString *)getSysVersion;

/**
 *  获取设备ID
 *
 *  @return 设备ID
 */
+(NSString *)getDeviceID;

/**
 *  获取当前网络状态
 *
 *  @return 当前网络状态
 */
+(NSString *)getNetType;

/**
 *  获得当前的时间戳
 *
 *  @return 字符串
 */
+(NSString *)getCurDate;
@end
