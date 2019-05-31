//
//  CarStewardCell1.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarStewardCell1.h"
#import "PopListVC.h"
#import "UIButtonImageWithLable.h"
@implementation CarStewardCell1 
{
    
    ///省简称数组
    NSArray *provinceArray;
    ///字母数组
    NSMutableArray *charArray;
    
    NSString * first;
    NSString * second;
    
    NSString * Carnum;
    NSString * Remarks;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
//     _appDlgt=GetAppDelegates;
//    [_regionButton setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:@"冀"  forState:UIControlStateNormal];
//    [_carNumberButton setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:@"A" forState:UIControlStateNormal];
    [_regionButton setTitle:@"冀" forState:UIControlStateNormal];
    [_carNumberButton setTitle:@"A" forState:UIControlStateNormal];
    
    _rightButton.layer.masksToBounds =YES;
    _rightButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _rightButton.layer.borderWidth = 1.0f;
    
    _rightButton.layer.cornerRadius = _rightButton.frame.size.height / 2;

    _iconImageView.layer.masksToBounds =YES;
    _iconImageView.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _iconImageView.layer.borderWidth = 1.0f;
    
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height / 2;
    
//    [_addButton setTitle:@"汽车管理-添加按钮.png" forState:UIControlStateNormal];
    self.backgroundColor = PURPLE_COLOR;
    
    
    [self createData];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)labelHidden {
    
    _showLabel.hidden = YES;
    _addButton.hidden = YES;
    _regionButton.hidden = NO;
    
    _regionButton.hidden = NO;
//    _carNumberFirst.hidden = NO;
    _carNumberButton.hidden = NO;
//    _regionBgView.hidden = NO;
    
    _iconImageView.hidden = NO;
    _carNumberLabel.hidden = NO;
    _rightButton.hidden = NO;
    
}
- (void)labelShow {
    
    _showLabel.hidden = NO;
    _addButton.hidden = NO;
//    _regionLabel.hidden = YES;
    
    _regionButton.hidden = YES;
//    _carNumberFirst.hidden = YES;
    _carNumberButton.hidden = YES;
//    _regionBgView.hidden = YES;
    _iconImageView.hidden = YES;
    _carNumberLabel.hidden = YES;
    _rightButton.hidden = YES;
}


//切换按钮
- (IBAction)rightButtonClick:(id)sender {
 
    
    
    
    
    
}
- (void)createData {
    
    
//    ///省简称
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
//    provinceArray = [NSArray arrayWithContentsOfFile:path];
//    ///26大写字母
//    charArray=[NSMutableArray new];
//    for (int i = 0; i < 26; i++) {
//        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
//        [charArray addObject:cityKey];
//    }
//    first=[provinceArray objectAtIndex:0];
//    second=[charArray objectAtIndex:0];
//    
//    AppDelegate * appDlt=GetAppDelegates;
//    if(![XYString isBlankString:appDlt.userData.carprefix]&&appDlt.userData.carprefix.length>=2)
//    {
//        NSString * tmp1=[appDlt.userData.carprefix substringToIndex:1];
//        NSRange range= NSMakeRange(1,1);
//        NSString * tmp2=[appDlt.userData.carprefix substringWithRange:range];
//        
//        first=tmp1;
//        second=tmp2;
//        
//        _regionLabel.text = tmp1;
//        _carNumberFirst.text = tmp2;
//        
//    }
//    
}


/**地区选择按钮*/
- (IBAction)regionButtonClick:(id)sender {
    
    
    
//    NSInteger heigth= [provinceArray count]>10?(SCREEN_HEIGHT/2):(provinceArray.count*50.0);
//    PopListVC * popList=[PopListVC getInstance];
//    popList.nsLay_TableHeigth.constant=heigth;
//    @WeakObj(popList);
//    [popList showVC:nil listData:provinceArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//        NSString *pstr =( NSString *)data;
//        [sender setTitle:pstr forState:UIControlStateNormal];
//        first=pstr;
//        [popListWeak dismissVC];
//        
//    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//        UITableViewCell * cell=(UITableViewCell *)view;
//        NSString *dic =( NSString *)data;
//        cell.textLabel.text=dic;
//        cell.textLabel.numberOfLines=0;
//    }];

    
    
}

/**车牌号首字母按钮*/
- (IBAction)numberFirstButtonClick:(id)sender {
    
//    NSInteger heigth= [charArray count]>10?(SCREEN_HEIGHT/2):(charArray.count*50.0);
//    PopListVC * popList=[PopListVC getInstance];
//    popList.nsLay_TableHeigth.constant=heigth;
//    @WeakObj(popList);
//    [popList showVC:nil listData:charArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//        NSString *pstr =( NSString *)data;
//        [sender setTitle:pstr forState:UIControlStateNormal];
//        second=pstr;
//        [popListWeak dismissVC];
//        
//    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//        UITableViewCell * cell=(UITableViewCell *)view;
//        NSString *dic =( NSString *)data;
//        cell.textLabel.text=dic;
//        cell.textLabel.numberOfLines=0;
//    }];
//
}


@end
