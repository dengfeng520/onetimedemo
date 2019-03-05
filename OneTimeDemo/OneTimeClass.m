//
//  OneTimeClass.m
//  OneTimeDemo
//
//  Created by rp.wang on 2018/1/30.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import "OneTimeClass.h"

static OneTimeClass *__onetimeClass;

@implementation OneTimeClass

///在整个文件被加载到运行时，在main函数调用之前调用
+(void)load
{
    printf("\nOneTimeClass load()");
}


//第一次调用该类时调用
+(void)initialize
{
    printf("\nOneTimeClass initialize()\n\n\n");
}



//获取使用实例
+(OneTimeClass *)sharedOneTimeClass
{
    
//    @synchronized(self){
//
//        if (__onetimeClass == nil) {
//
//            __onetimeClass = [[OneTimeClass alloc]  init];
//        }
//    }
    static dispatch_once_t oneToken;

    dispatch_once(&oneToken, ^{

        __onetimeClass = [[OneTimeClass alloc]init];

    });
    
    return __onetimeClass;
}


+ (instancetype)alloc
{
//     NSCAssert(__onetimeClass, @"OneTimeClass类只能初始化一次");
     //如果已经初始化了
    if(__onetimeClass)
    {
//        NSException *exception = [NSException exceptionWithName:@"报错" reason:@"OneTimeClass类只能初始化一次" userInfo:nil];
//        [exception raise];

        return  __onetimeClass;
    }

    return [super alloc];
}



@end
