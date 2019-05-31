//
//  GarageAddCarHeardView.m
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageAddCarHeardView.h"
#import "PopListVC.h"
#import "RegularUtils.h"

@implementation GarageAddCarHeardView
{
    ///省简称数组
    NSArray *provinceArray;
    ///字母数组
    NSMutableArray *charArray;
    
    
    NSString *first;
    NSString * second;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initView];
}
#pragma mark -------初始化--------------


-(void)initView
{
    self.btn_CarNumFirstChar.layer.borderWidth = 1;
    [self.btn_CarNumFirstChar.layer setMasksToBounds:YES];
    self.btn_CarNumFirstChar.layer.borderColor = [UIColorFromRGB(0xa6a6a6) CGColor];
    
    self.btn_CarNumSecondChar.layer.borderWidth = 1;
    [self.btn_CarNumSecondChar.layer setMasksToBounds:YES];
    self.btn_CarNumSecondChar.layer.borderColor = [UIColorFromRGB(0xa6a6a6) CGColor];
    
    self.TF_CarNumText.layer.borderWidth = 1;
    [self.TF_CarNumText.layer setMasksToBounds:YES];
    self.TF_CarNumText.layer.borderColor = [UIColorFromRGB(0xa6a6a6) CGColor];
    [self setTextFieldLeftPadding:self.TF_CarNumText forWidth:6];
    
    self.TF_CarOwnerName.layer.borderWidth = 1;
    [self.TF_CarOwnerName.layer setMasksToBounds:YES];
    self.TF_CarOwnerName.layer.borderColor = [UIColorFromRGB(0xa6a6a6) CGColor];
    [self setTextFieldLeftPadding:self.TF_CarOwnerName forWidth:6];
 
    ///省简称
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    provinceArray = [NSArray arrayWithContentsOfFile:path];
    ///26大写字母
    charArray=[NSMutableArray new];
    for (int i = 0; i < 26; i++) {
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [charArray addObject:cityKey];
    }
    first=[provinceArray objectAtIndex:0];
    second=[charArray objectAtIndex:0];
    
    AppDelegate * appDlt=GetAppDelegates;
    
    if(![XYString isBlankString:appDlt.userData.carprefix]&&appDlt.userData.carprefix.length>=2)
    {
        NSString * tmp1=[appDlt.userData.carprefix substringToIndex:1];
        NSRange range= NSMakeRange(1,1);
        NSString * tmp2=[appDlt.userData.carprefix substringWithRange:range];
        first=tmp1;
        second=tmp2;
        [self.btn_CarNumFirstChar setTitle:tmp1 forState:UIControlStateNormal];
        [self.btn_CarNumSecondChar setTitle:tmp2 forState:UIControlStateNormal];
    }

    
}

/**
 *  获取实例
 *
 *  @return
 */
+(GarageAddCarHeardView *)getInstanceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"GarageAddCarHeardView" owner:nil options:nil];
    return (GarageAddCarHeardView *)[nibView objectAtIndex:0];
}

#pragma mark -----------------事件处理---------------------
/**
*  确认事件
*
*  @param sender sender description
*/
- (IBAction)btn_OkClike:(UIButton *)sender {
    NSString * carNum=[NSString stringWithFormat:@"%@%@%@",first,second,self.TF_CarNumText.text];
    NSLog(@"carNum===%@",carNum);
    if(![RegularUtils isCarNum:carNum])//验证手机号正确
    {
        [self.viewController showToastMsg:@"请输入5/6位车牌号" Duration:5.0];
        return;
    }
    
    if(self.eventCallBack)
    {
        NSDictionary *dic=@{@"carNum":carNum,@"remark":self.TF_CarOwnerName.text};
        self.eventCallBack(dic,sender,ADDCAR_OK);
    }


}
/**
 *  第一位选择事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_FristCharClike:(UIButton *)sender {
    NSInteger heigth= [provinceArray count]>10?(SCREEN_HEIGHT/2):(provinceArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self.viewController listData:provinceArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSString *pstr =( NSString *)data;
        [sender setTitle:pstr forState:UIControlStateNormal];
        first=pstr;
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];

}
/**
 *  第二位选择事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_SecondCharClike:(UIButton *)sender {
    NSInteger heigth= [charArray count]>10?(SCREEN_HEIGHT/2):(charArray.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self.viewController listData:charArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSString *pstr =( NSString *)data;
        [sender setTitle:pstr forState:UIControlStateNormal];
        second=pstr;
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSString *dic =( NSString *)data;
        cell.textLabel.text=dic;
        cell.textLabel.numberOfLines=0;
    }];
}
#pragma mark -----------------输入处理---------------------

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
CGRect frame = textField.frame;
frame.size.width = leftWidth;
UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
/**
 *  车牌号输入变化
 *
 *  @param sender sender description
 */
- (IBAction)TF_CarNumChanged:(UITextField *)sender {
    
    
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
        if(sender.text.length>6)
        {
            sender.text=[sender.text substringToIndex:6];
        }else{
            
            NSString *infoText = sender.text;
            if (infoText.length > 0) {
             infoText = [infoText substringFromIndex:infoText.length - 1];   
            }
            if ([infoText isEqualToString:@"o"] || [infoText isEqualToString:@"i"] || [infoText isEqualToString:@"O"] || [infoText isEqualToString:@"I"]) {
                
                sender.text = [sender.text substringToIndex:sender.text.length - 1];
                
                [AppDelegate showToastMsg:@"根据国家法律法规，车牌号不允许添加O 或者 I" Duration:3.0];
            }
        }
    }

}
/**
 *  车主姓名输入变化
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_OwnerNameChanged:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>10)
        {
            sender.text=[sender.text substringToIndex:10];
        }
    }
}
@end
