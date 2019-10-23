//
//  CHKeychain.h
//  KeyChainDemo
//
//  Created by rp.wang on 2018/7/7.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deletedata:(NSString *)service;

@end
