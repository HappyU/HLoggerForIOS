//
//  Logger.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-18.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "Logger.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@interface LogPoint:NSObject

//获取App应用名称
+(NSString *)getAppName;
//获取App应用版本
+(NSString *)getAppVersion;
//获取设备类别
+(NSString *)getDeviceType;
//获取设备运行系统
+(NSString *)getSysName;
//获取设备系统版本
+(NSString *)getSysVersion;
//获取设备的ID
+(NSString *)getDeviceID;
//获取当前网络状态
+(NSString *)getNetType;
//获得当前的时间戳
+(NSString *)getCurDate;

@end

@implementation LogPoint



+(NSString *)getAppName
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    return strAppName;
}

+(NSString *)getAppVersion
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return strAppVersion;
}

+(NSString *)getDeviceType
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.model;
}

+(NSString *)getSysName
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.systemName;
}

+(NSString *)getSysVersion
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.systemVersion;
}

+(NSString *)getDeviceID
{
    UIDevice *device = [[UIDevice alloc] init];
    return device.identifierForVendor.UUIDString;
}

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

+(NSString *)getCurDate
{
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

// 获取当前设备可用内存(单位：MB）
+(double)availableMemory
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
+(double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&taskInfo,&infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

//获取CPU占用率
+(float)cpu_usage
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



@implementation Logger



void WriteLog(int level,const char *func, int lineNumber, NSString *format, ...)
{

    if(level > LOG_LEVEL)
    {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    
    
    NSString *classAndMethodStr = [NSString stringWithFormat:@"%s",func];
    NSArray *classAndMethodArr = [classAndMethodStr componentsSeparatedByString:@" "];
    NSString *className = nil;
    NSString *methodName = nil;
    if (classAndMethodArr.count == 2)
    {
        NSString *tempClassName = [classAndMethodArr objectAtIndex:0];
        className = [tempClassName substringFromIndex:2];
        NSString *tempMethodName = [classAndMethodArr objectAtIndex:1];
        methodName = [tempMethodName substringToIndex:(tempMethodName.length - 1)];
    }

    switch (level)
    {
        case ERR_LOG:
            [Logger printfErrorWithString:string];
            break;
        case WARN_LOG:
            break;
        case INFO_LOG:
            [Logger printfInfoWithClassName:className andMethodName:methodName];
            break;
        case OPERATE_LOG:
            [Logger printfOpertaionWithClassName:className andMethodName:methodName andString:nil];
            break;
        case DEBUG_LOG:
            strErrorLevel = @"Debug";
            break;
        default:
            break;
    }

}


/**
 *  打印info信息
 *
 *  @param className  类名
 *  @param methodName 方法名
 */
+(void)printfInfoWithClassName:(NSString *)className andMethodName:(NSString*)methodName
{
    NSString *eventContentString = [NSString stringWithFormat:@"%@+%@+%@",[LogPoint getAppName],className,methodName];
    
    
    //    NSString *userID = GET_USER(@"userID");
    NSString *userID = @"admin";

//    if(LOG_LEVEL == LEVEL_INFO || LOG_LEVEL == LEVEL_DEBUG || LOG_LEVEL == LEVEL_OPERATE)
//    {
//         NSLog(@"<log type =\"info\"><eventID></eventID><eventDesc></eventDesc><eventContent>%@/eventClass><userID>%@</userID></log>",eventContentString,userID);
//    }
    
             NSLog(@"<log type =\"info\"><eventID></eventID><eventDesc></eventDesc><eventContent>%@/eventClass><userID>%@</userID></log>",eventContentString,userID);
   
}


/**
 *  打印Opertaion信息
 *
 *  @param className  类名
 *  @param methodName 方法名
 */
+(void)printfOpertaionWithClassName:(NSString *)className andMethodName:(NSString*)methodName andString:(NSString *)string
{

//    if(LOG_LEVEL == LEVEL_INFO || LOG_LEVEL == LEVEL_DEBUG || LOG_LEVEL == LEVEL_OPERATE )
//    {
//        //    NSString *userID = GET_USER(@"userID");
//        NSString *userID = @"admin";
//        NSLog(@"<log type=\"opertaion\"><eventID></eventID><eventDesc></eventDesc><userID>%@</userID><eventStart></eventStart><eventEnd></eventEnd><IP></IP><netstate>%@</netstate></log>",userID,[LogPoint getNetType]);
//    }
    
}



/**
 *  打印Error信息
 *
 *  @param className  类名
 *  @param methodName 方法名
 */
+(void)printfErrorWithString:(NSString *)string
{
   
    NSLog(@"<log type=\"error\"><eventID></eventID><eventDesc></eventDesc><eventContent>%@</eventContent></log>",string);
}



@end
