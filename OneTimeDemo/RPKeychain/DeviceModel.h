//
//  DeviceModel.h
//  OneTimeDemo
//
//  Created by rp.wang on 2019/10/23.
//  Copyright © 2019 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : NSObject
- (BOOL)isBindingdevice;
- (void)saveBindingDeviceWtihString:(NSString *)deviceChar;
- (NSString *)loadDeviceData;
- (NSString *)detchDevicenumber;
@end

NS_ASSUME_NONNULL_END
