//
//  MMPickerView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MMPickerView.h"
#import "MMPopupItem.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"

@interface MMPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation MMPickerView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        self.btnCancel.titleLabel.font = DEFAULT_FONT(14);
        [self.btnCancel setTitle:@"取    消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        self.btnConfirm.titleLabel.font = DEFAULT_FONT(14);
        [self.btnConfirm setTitle:@"确    定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:kNewRedColor forState:UIControlStateNormal];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = TITLE_TEXT_COLOR;
        _titleLabel.font = DEFAULT_BOLDFONT(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.btnCancel.mas_centerY);
            make.height.equalTo(@20);
        }];
        
        self.pickerView = [[UIPickerView alloc]init];

        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
        
    }
    
    return self;
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    _titleLabel.text = titleString;
}

- (void)actionButton:(UIButton*)btn
{
    [self hide];
    if (self.confirm) {
        self.confirm(_selectStr);
    }
}
- (void)actionHide
{
    [self hide];
}
/**
 *  显示
 *
 *  @param parent 
 */
//-(void)showPickView:(UIViewController *) parent pickData:(NSArray *)data
//{
//    pickerData = data;
//    NSInteger index=[pickerData indexOfObject:_selectStr];
//    [_pickerView selectRow:index inComponent:0 animated:NO];
//
//}
- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    if ([XYString isBlankString:_selectStr]) {
        return;
    }
    NSInteger index = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        if ([_dataArray[i] isEqualToString:_selectStr]) {
            index = i;
            break;
        }
    }
//    NSInteger index = [_dataArray indexOfObject:_selectStr];
    NSLog(@"index=====%ld",(long)index);
    [_pickerView selectRow:index inComponent:0 animated:NO];
    
}


#pragma mark ----------------UIPickerViewDataSource,UIPickerViewDelegate的实现-------------
/**
 *  选 中选择框第row行时执行的代码
 */
-(void)pickerView: (UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectStr=[_dataArray objectAtIndex:row];
}
/**
 *  显示出来的每行的文本
 *
 */
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [_dataArray objectAtIndex:row];
}
/**
 *  给选择框设置视图格式选项，可以是UIView以 及UIView的子类
 这个方法可以设置自定义的视图来取代默认的显示每行的样式
 *
 */
//- (UIView*)pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row forComponent: (NSInteger)component reusingView:(UIView *)view
//{
//
//    return view;
//}
/**
 *  设置行高 度
 *
 */
-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
/**
 *  设置行宽度
 *
 */
//-(CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger) component
//{
//    return  SCREEN_WIDTH;
//}

/**
 *  设置选择框中可供选择的行数
 一般都是一个，也可以同时选择两个或更多
 类似于选择时间的 那种，左右有两个轴同时进行选择。
 *
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/**
 *  设置行数
 */
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataArray count];
}

@end
