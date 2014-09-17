//
//  LogPoint.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-16.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "LogPoint.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
@implementation LogPoint


/**
 *  获取App应用名称
 *
 *  @return App应用名称
 */
+(NSString *)getAppName
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    return strAppName;
}

/**
 *  获取App应用版本
 *
 *  @return App应用版本
 */
+(NSString *)getAppVersion
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return strAppVersion;
}


/**
 *  获取设备类别
 *
 *  @return 设备类别
 */
+(NSString *)getDeviceModel
{
    UIDevice *device = [[UIDevice alloc] init];
    
    return device.model;
}


/**
 *  获取设备运行系统
 *
 *  @return 设备运行系统
 */
+(NSString *)getDeviceSystemName
{
    UIDevice *device = [[UIDevice alloc] init];
    
    return device.systemName;
}


/**
 *  获取设备系统版本
 *
 *  @return 设备系统版本
 */
+(NSString *)getDeviceSystemVersion
{
    UIDevice *device = [[UIDevice alloc] init];
    
    return device.systemVersion;
}


/**
 *  获取设备ID
 *
 *  @return 设备ID
 */
+(NSString *)getDeviceID
{
    UIDevice *device = [[UIDevice alloc] init];
    
    return device.identifierForVendor.UUIDString;
}


/**
 *  获取当前网络状态
 *
 *  @return 当前网络状态
 */
+(NSString *)getNetWorkType
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    
    NSNumber *dataNetWorkItemView = nil;
    
    for (id subView in subviews) {
        
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            
            dataNetWorkItemView = subView;
            
            break;
            
        }
        
    }
    
    NSString *networkType;
    
    switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"]integerValue]) {
            
        case 0:
            
            networkType = @"无网络";
            
            break;
            
            
            
        case 1:
            
            networkType = @"2G";
            
            break;
            
            
            
        case 2:
            
            networkType = @"3G";
            
            break;
            
        case 3:
            
            networkType = @"4G";
            
            break;
            
            
            
        default:
            
            networkType = @"wifi";
            
            break;
            
    }
    
    return networkType;

}



+(NSString *)getSystemTime
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd%20hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    return date;
}


// 获取当前设备可用内存(单位：MB）

- (double)availableMemory

{
    
    vm_statistics_data_t vmStats;
    
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               
                                               HOST_VM_INFO,
                                               
                                               (host_info_t)&vmStats,
                                               
                                               &infoCount);
    
    
    
    if (kernReturn != KERN_SUCCESS) {
        
        return NSNotFound;
        
    }
    
    
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
    
}


// 获取当前任务所占用的内存（单位：MB）

- (double)usedMemory

{
    
    task_basic_info_data_t taskInfo;
    
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         
                                         TASK_BASIC_INFO,
                                         
                                         (task_info_t)&taskInfo,
                                         
                                         &infoCount);
    
    
    
    if (kernReturn != KERN_SUCCESS
        
        ) {
        
        return NSNotFound;
        
    }
    
    
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
    
}


@end
