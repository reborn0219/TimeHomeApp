//
//  KeyboardCollectionCell.m
//  CarManagerApp
//
//  Created by 优思科技 on 2017/4/17.
//  Copyright © 2017年 L.S.B. All rights reserved.
//

#import "PAKeyboardCollectionCell.h"

@implementation PAKeyboardCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColorFromRGB(0xaaaaaa).CGColor;
}

@end
