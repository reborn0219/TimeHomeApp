//
//  ChangAreaCell.m
//  TimeHomeApp
//
//  Created by us on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ChangAreaCell.h"

@implementation ChangAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  点击单选事件处理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_Selected:(UIButton *)sender {
    if(self.cellSelectCallBack)
    {
        self.cellSelectCallBack(nil,sender,self.indexPath);
    }
}

/**
 *  设置列表数据
 */
-(void)setCityModel:(CityCommunityModel *)cityModel
{
    self.lab_AreaName.text = cityModel.name;
    self.lab_Addrs.text = cityModel.address;
    
    
    if(cityModel.isSelect) {
        [self.btn_Selected setImage:[UIImage imageNamed:@"单选_选中"] forState:UIControlStateNormal];
    }else {
        [self.btn_Selected setImage:[UIImage imageNamed:@"单选_未选中"] forState:UIControlStateNormal];
    }
    
}

@end
