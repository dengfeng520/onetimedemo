//
//  OneTimeClass.h
//  OneTimeDemo
//
//  Created by rp.wang on 2018/1/30.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneTimeClass : NSObject

///获取使用实例
+(OneTimeClass *)sharedOneTimeClass;
///


@end
