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
+(NSString *)getDeviceType
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.model;
}


/**
 *  获取设备运行系统
 *
 *  @return 设备运行系统
 */
+(NSString *)getSysName
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.systemName;
}


/**
 *  获取设备系统版本
 *
 *  @return 设备系统版本
 */
+(NSString *)getSysVersion
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
+(NSString *)getNetType
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


/**
 *  获得当前的时间戳
 *
 *  @return 字符串
 */
+(NSString *)getCurDate
{
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}


// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
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
    kern_return_t kernReturn = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&taskInfo,&infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}



/**
 *  获取CPU占用率
 *
 *  @return 占用率
 */
- (float)cpu_usage
{
	kern_return_t			kr = { 0 };
	task_info_data_t		tinfo = { 0 };
	mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
	kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
	if ( KERN_SUCCESS != kr )
		return 0.0f;
    
	task_basic_info_t		basic_info = { 0 };
	thread_array_t			thread_list = { 0 };
	mach_msg_type_number_t	thread_count = { 0 };
    
	thread_info_data_t		thinfo = { 0 };
	thread_basic_info_t		basic_info_th = { 0 };
    
	basic_info = (task_basic_info_t)tinfo;
    
	// get threads in the task
	kr = task_threads( mach_task_self(), &thread_list, &thread_count );
	if ( KERN_SUCCESS != kr )
		return 0.0f;
    
	long	tot_sec = 0;
	long	tot_usec = 0;
	float	tot_cpu = 0;
    
	for ( int i = 0; i < thread_count; i++ )
 	{
 		mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
 		kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
 		if ( KERN_SUCCESS != kr )
 			return 0.0f;
        
		basic_info_th = (thread_basic_info_t)thinfo;
 		if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
		{
			tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
			tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
		}
	}
	kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
	if ( KERN_SUCCESS != kr )
		return 0.0f;
	return tot_cpu;
}


@end
