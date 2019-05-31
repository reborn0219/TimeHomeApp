//
//  L_MySellSectionHeader.m
//  TimeHomeApp
//
//  Created by 李世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MySellSectionHeader.h"

@implementation L_MySellSectionHeader

+ (L_MySellSectionHeader *)instanceSectionHeader {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"L_MySellSectionHeader" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
