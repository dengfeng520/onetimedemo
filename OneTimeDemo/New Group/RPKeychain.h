//
//  CHKeychain.h
//  KeyChainDemo
//
//  Created by rp.wang on 2018/7/7.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const KEY_OABINDING_DEVICE = @"com.vito.oa.usernamepassword";
static NSString * const KEY_DEVEICE = @"com.vito.oa.deveice";
static NSString * const KEY_USERID = @"10008611";


@interface RPKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deletedata:(NSString *)service;

@end
