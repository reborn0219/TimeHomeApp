//
//  PACarportRentTableViewCell.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRentTableViewCell.h"
#import "MMDateView.h"

@interface PACarSpaceRentTableViewCell ()<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong)UILabel * rentTitleLabel;
@property (nonatomic, strong)UITextField * inputTextField;
@property (nonatomic, strong)UIButton * addressButton;

@end

@implementation PACarSpaceRentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createSubviews{
    [self.contentView addSubview:self.rentTitleLabel];
    [self.contentView addSubview:self.inputTextField];
    [self.contentView addSubview:self.addressButton];
    
    [self.rentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(18);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@70);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(114);
        make.right.equalTo(self.contentView).with.offset(-44);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-17);
    }];
    
    UIView * style = [[UIView alloc]init];
    style.backgroundColor = UIColorHex(0xE8E8E8);
    [self.contentView addSubview:style];
    
    [style mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.left.equalTo(self.contentView).with.offset(14);
        make.right.equalTo(self.contentView).with.offset(-14);
    }];
}

- (UILabel *)rentTitleLabel{
    if (!_rentTitleLabel) {
        _rentTitleLabel = [[UILabel alloc]init];
        _rentTitleLabel.textColor = UIColorHex(0x4A4A4A);
        _rentTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _rentTitleLabel;
}
- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.textColor =UIColorHex(0x4A4A4A);
        _inputTextField.font = [UIFont systemFontOfSize:16];
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}
- (UIButton *)addressButton{
    if (!_addressButton) {
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setImage:[UIImage imageNamed:@"cwcz_button_txl_n"]
                        forState:UIControlStateNormal];
        [_addressButton addTarget:self
                           action:@selector(addressBookClick:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressButton;
}



#pragma mark - Custom Accessors

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.rentTitleLabel.text = _titleString;
}

- (void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    self.inputTextField.placeholder = _placeString;
}

- (void)showAddreBook:(BOOL)show{
    self.addressButton.hidden = !show;
}

- (void)addressBookClick:(UIButton *)sender{
    if (self.addressBlock) {
        self.addressBlock(nil, nil, nil);
    }
}


- (void)setResponseType:(CarportResponseType)responseType{
    _responseType = responseType;
    if (_responseType == SelectTime) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectTime)];
        [self.inputTextField addGestureRecognizer:tap];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
     if (self.responseType == SelectTime || self.responseType == UnableEdit){
       // [self showSelectTime];
        return NO;
    }
    return YES;
}

- (void)showSelectTime{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
    MMDateView *dateView = [[MMDateView alloc]init];
    dateView.titleLabel.text=@"出租日期";
    dateView.datePicker.minimumDate = [NSDate date];
    NSString * maxDateString = [self.maxPickerDate stringByAppendingString:@" 00:00:00"];
    NSDate *maxinumDate = [NSDate dateWithString:maxDateString format:@"yyyy-MM-dd HH:mm:ss"];
    
    dateView.datePicker.maximumDate =maxinumDate;
    [dateView show];
    dateView.confirm = ^(NSString *dataString) {
        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",dataString] withFormat:@"yyyy/MM/dd"];
        
        NSString * selectDate = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
        //[sender setTitle:selectDate forState:UIControlStateNormal];
        //self.inputTextField.text = selectDate;
        self.contentString = selectDate;
    };
}

- (void)setContentString:(NSString *)contentString{
    
    self.inputTextField.text = contentString;

}

- (NSString *)contentString{
    return self.inputTextField.text;
}

@end
