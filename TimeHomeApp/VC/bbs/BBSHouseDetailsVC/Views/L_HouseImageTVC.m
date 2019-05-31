//
//  L_HouseImageTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseImageTVC.h"
#import "SDCycleScrollView.h"

@interface L_HouseImageTVC ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation L_HouseImageTVC

- (void)setModel:(L_HouseDetailModel *)model {
    
    _model = model;
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = width / 640 * 370.;

    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in model.piclist) {
//        if (![XYString isBlankString:dict[@"picurl"]]) {
            [mutableArr addObject:dict[@"picurl"]];
//        }
    }
    
    NSArray *array = [mutableArr copy];
    
    if (!_cycleScrollView) {
    
        if (model.piclist.count == 0) {
            
            NSArray *images = @[
                                @"车位默认图片.png"
                                ];
            
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, height) imageNamesGroup:images];
            _cycleScrollView.placeholderImage = PLACEHOLDER_IMAGE;
            _cycleScrollView.backgroundColor = BLACKGROUND_COLOR;
            _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
            _cycleScrollView.infiniteLoop = NO;
            _cycleScrollView.autoScroll = NO;
            _cycleScrollView.autoScrollTimeInterval = 0.0;
            _cycleScrollView.delegate = self;
            _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            [self.contentView addSubview:_cycleScrollView];
            
            _cycleScrollView.scrollViewPageCallBack = ^(NSInteger index){
                
            };
            
        }else {
            
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, height) imageURLStringsGroup:array];
            _cycleScrollView.placeholderImage = PLACEHOLDER_IMAGE;
            _cycleScrollView.backgroundColor = BLACKGROUND_COLOR;
            _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

            _cycleScrollView.infiniteLoop = YES;
            _cycleScrollView.autoScroll = YES;
            _cycleScrollView.autoScrollTimeInterval = 4.0;
            _cycleScrollView.delegate = self;
            _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;

            [self.contentView addSubview:_cycleScrollView];
            
            _cycleScrollView.scrollViewPageCallBack = ^(NSInteger index){
                
            };
            
        }

    }else {
        
        if (model.piclist.count == 0) {
            
            NSArray *images = @[
                                @"车位默认图片.png"
                                ];
            
            _cycleScrollView.localizationImageNamesGroup = images;
            _cycleScrollView.infiniteLoop = NO;
            _cycleScrollView.autoScroll = NO;
            _cycleScrollView.autoScrollTimeInterval = 0.0;
            _cycleScrollView.placeholderImage = PLACEHOLDER_IMAGE;
            _cycleScrollView.backgroundColor = BLACKGROUND_COLOR;
            _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

        }else {
            
            _cycleScrollView.imageURLStringsGroup = array;
            _cycleScrollView.infiniteLoop = YES;
            _cycleScrollView.autoScroll = YES;
            _cycleScrollView.autoScrollTimeInterval = 4.0;
            _cycleScrollView.placeholderImage = PLACEHOLDER_IMAGE;
            _cycleScrollView.backgroundColor = BLACKGROUND_COLOR;
            _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

        }
        
    }

    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.imageDidBlock) {
        self.imageDidBlock(index);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
