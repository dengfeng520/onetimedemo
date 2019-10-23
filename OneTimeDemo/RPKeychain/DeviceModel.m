//
//  DeviceModel.m
//  OneTimeDemo
//
//  Created by rp.wang on 2019/10/23.
//  Copyright © 2019 兰州北科维拓科技股份有限公司. All rights reserved.
//

#import "DeviceModel.h"
#import <sys/utsname.h>
#import "RPKeychain.h"

static NSString * const KEY_OABINDING_DEVICE = @"com.boxkj.BluetoothUUID";
static NSString * const KEY_DEVEICE = @"com.boxkj.deveice";
static NSString * const KEY_USERID = @"10008611";

@implementation DeviceModel
//MARK: - 查询用户是否绑定了当前设备
- (BOOL)isBindingdevice {
    NSString *deviceStr = [NSString stringWithFormat:@"%@",[RPKeychain load:KEY_OABINDING_DEVICE]];
    if ([self isCharNullString:deviceStr]) {
        return false;
    } else {
        return true;
    }
}

- (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
 
    return deviceModel;
}

- (BOOL)isCharNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

//MARK: - 生成设备码 (时间戳 + 设备型号 + 用户ID + 一个随机数)
- (NSString *)detchDevicenumber {
    NSString *deviceStr =  [[NSString alloc]init];
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[RPKeychain load:KEY_OABINDING_DEVICE];
    NSString *devicechar = [usernamepasswordKVPairs objectForKey:KEY_DEVEICE];
    
    //先查一次 本地是否已经生成了设备码
    if ([self isCharNullString:devicechar]) {
        NSString *randomstr = [NSString stringWithFormat:@"%d",[self fetchRandomNumber:1 tonumber:10000]];
        
        NSString *systemtime = [NSString stringWithFormat:@"%@",[self currentTimeStr]];
        
        deviceStr = [NSString stringWithFormat:@"%@%@%@%@",systemtime,[self deviceModelName],KEY_USERID,randomstr];
    } else {
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[RPKeychain load:KEY_OABINDING_DEVICE];
        deviceStr = [usernamepasswordKVPairs objectForKey:KEY_DEVEICE];
    }
    return deviceStr;
}

// MARK: - 获取当前时间戳
- (NSString *)currentTimeStr {
    //获取当前时间0秒后的时间
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    // 精确到秒
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}

// MARK: - 生成随机数
- (int)fetchRandomNumber:(int)from tonumber:(int)tonumber {
    return (from + (arc4random() % (tonumber - from + 1)));
}

// MARK: - 保存到 Keychain中
- (void)saveBindingDeviceWtihString:(NSString *)deviceChar {
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:deviceChar forKey:KEY_DEVEICE];
    [RPKeychain save:KEY_OABINDING_DEVICE data:usernamepasswordKVPairs];
}

// MARK: - 从Keychain中读取
- (NSString *)loadDeviceData {
   return [RPKeychain load:KEY_OABINDING_DEVICE];
}
@end
