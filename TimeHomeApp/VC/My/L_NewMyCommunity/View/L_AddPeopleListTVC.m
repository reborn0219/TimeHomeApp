//
//  L_PeopleListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AddPeopleListTVC.h"

@interface L_AddPeopleListTVC ()

@property (nonatomic, strong) UIImageView *deleteImage;
@property (nonatomic, strong) UILabel *deleteLabel;

@end

@implementation L_AddPeopleListTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [[UILabel alloc] init];
        _deleteLabel.textColor = [UIColor whiteColor];
        _deleteLabel.font = DEFAULT_BOLDFONT(15);
        _deleteLabel.text = @"删 除";
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deleteLabel;
}
- (UIImageView *)deleteImage {
    if (!_deleteImage) {
        _deleteImage = [[UIImageView alloc] init];
        _deleteImage.image = [UIImage imageNamed:@"家人列表-删除图标"];
    }
    return _deleteImage;
}

- (void)layoutSubviews {
    
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            // 拿到subView之后再获取子控件
            
            // 因为上面删除按钮是第二个加的所以下标是1
            UIView *deleteConfirmationView = subView.subviews[0];
            //改背景颜色
            deleteConfirmationView.backgroundColor = kNewRedColor;
            for (UIView *deleteView in deleteConfirmationView.subviews) {
                NSLog(@"%@",deleteConfirmationView.subviews);

                [deleteView addSubview:self.deleteImage];
                _deleteImage.frame = CGRectMake((deleteView.frame.size.width-20)/2., -20, 20, 26);

                [deleteView addSubview:self.deleteLabel];
                _deleteLabel.frame = CGRectMake((deleteView.frame.size.width-80)/2., 20, 80, 20);

            }

        }
    }
    
}

@end
