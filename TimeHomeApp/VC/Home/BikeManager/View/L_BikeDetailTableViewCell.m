//
//  L_BikeDetailTableViewCell.m
//  TimeHomeApp
//
//  Created by 李世博 on 16/9/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeDetailTableViewCell.h"

@interface L_BikeDetailTableViewCell()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UITextField *rightTextfield;

@end

@implementation L_BikeDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

    
    
}


@end
