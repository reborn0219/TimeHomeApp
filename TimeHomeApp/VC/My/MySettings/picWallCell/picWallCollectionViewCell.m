//
//  picWallCollectionViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "picWallCollectionViewCell.h"

@implementation picWallCollectionViewCell

#pragma mark - extend method

-(void)setModel:(UserPhotoWall *)model{
    
    NSURL *url = [NSURL URLWithString:model.fileurl];
    
    if ([XYString isBlankString:model.fileurl]) {
        
        self.picWall.image = model.image;
    }else {
        [self.picWall sd_setImageWithURL:url placeholderImage:PLACEHOLDER_IMAGE];
        
    }
    
    if (model.isSelected) {
        
        self.canelButton.hidden = YES;
        self.picWall.contentMode = UIViewContentModeCenter;
    }else{
        
        self.canelButton.hidden = NO;
        self.picWall.contentMode = UIViewContentModeScaleToFill;
    }
    
    if ([self.top isEqualToString:@"0"]) {
        
        self.headerLal.hidden = NO;
    }else{
        
        self.headerLal.hidden = YES;
    }
}

- (IBAction)canelClick:(id)sender {
    
    if (self.deleteButtonDidClickBlock) {
        self.deleteButtonDidClickBlock(0);
    }
}

#pragma mark - life cycle method

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
