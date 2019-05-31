//
//  PAVersionModel.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVersionModel.h"
#import "PAIPAddressManager.h"

@implementation PAVersionvalidIPModel
//IP字符串转32位int数
unsigned int IPStrToInt(const char *ip)
{        
    unsigned uResult = 0;
    int nShift = 24;
    int temp = 0;
    const char *pStart = ip;
    const char *pEnd = ip;
    
    while (*pEnd != '\0')
    {
        while (*pEnd!='.' && *pEnd!='\0')
        {
            pEnd++;
        }
        temp = 0;
        for (pStart; pStart!=pEnd; ++pStart)
        {
            temp = temp * 10 + *pStart - '0';
        }
        
        uResult += temp<<nShift;
        nShift -= 8;
        
        if (*pEnd == '\0')
            break;
        pStart = pEnd + 1;
        pEnd++;
    }
    
    return uResult;
}

/**
 OC IP string to Int

 @param address IP地址
 @return IP int类型
 */
- (int )IPAddressToInt:(NSString *)address {

    int IP = IPStrToInt([address UTF8String]);
    return IP;
}

/**
 获取是否在IP范围内

 @return YES 合法
 */
- (BOOL)conformIP{
    
    return YES;
    //formIP
    int form = [self IPAddressToInt:self.fromIP];
    int to = [self IPAddressToInt:self.toIP];
    
    int current = [self getCurrentIPAddress];
    
    if (form <=current && to>= current) {
        
        return YES;
    }
    return NO;
}

/**
 获取本机当前IP地址

 @return IP地址 int类型
 */
- (int)getCurrentIPAddress{
 
    NSString * address = [[PAIPAddressManager Instance]getIPAddress:YES];
    
    /*
    // 取出en0/ipv4 地址字符串
    NSArray * ipArray = [address componentsSeparatedByString:@","];
    
    NSString * result;
    for (NSString *ip in ipArray) {
        if ([ip rangeOfString:@"en0/ipv4"].location == NSNotFound) {
            NSLog(@"string 不存在 en0/ipv4");
        } else {
            NSLog(@"string 包含 en0/ipv4");
            result = [[ip componentsSeparatedByString:@"="]lastObject];
        }
    }
     */
    return [self IPAddressToInt:address];
}
@end

@implementation PAVersionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"validIP":[PAVersionvalidIPModel class]};
}

- (BOOL)needUpdate{
    // 版本号校验
    // 获取当前版本号做比对
    if ([self.version isEqualToString:kCurrentVersion]) {
        return NO;
    }
    
    // 灰度校验
    if (self.validIP.conformIP) {
        return YES;
    }
    return NO;
}



@end
