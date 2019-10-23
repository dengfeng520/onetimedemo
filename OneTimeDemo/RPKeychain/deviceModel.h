//
//  deviceModel.h
//  KeyChainDemo
//
//  Created by rp.wang on 2018/7/7.
//  Copyright © 2018年 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//设备唯一标识码
#import "RPKeychain.h"

@interface deviceModel : NSObject

/// 查询用户是否已经绑定了当前设备
- (BOOL)isBindingdevice;
- (void)saveBindingStringWtihDevice;

@end
