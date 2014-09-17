//
//  HLog.m
//  HLoggerForIOS
//
//  Created by 刘博 on 14-9-17.
//  Copyright (c) 2014年 hirisun. All rights reserved.
//

#import "HLog.h"
#import <objc/runtime.h>
@implementation HLog



-(void)getName
{
    NSDictionary *dTmp=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"log" ofType:@"plist"]];
    
    

}

+ (NSArray *)getAllProperties
{
    
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++)
        
    {
        
        const char* propertyName =property_getName(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        
    }
    
    free(properties);
    
    return propertiesArray;  
    
}

@end
