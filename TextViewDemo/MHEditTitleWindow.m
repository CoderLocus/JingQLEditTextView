//
//  MHEditTitleWindow.m
//  TextViewDemo
//
//  Created by 井庆林 on 16/8/2.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "MHEditTitleWindow.h"
#import "Masonry.h"

@interface MHEditTitleWindow() <UITextFieldDelegate>
{
    CancelBlock _cancelBlock;
    ConfirmBlock _confirmBlock;
}
@property (nonatomic) UIView *alertView;

@end

@implementation MHEditTitleWindow

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10;
        [self.alertView.layer masksToBounds];
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@245);
            make.height.equalTo(@(150));
            make.top.equalTo(self).offset(130);
            make.centerX.equalTo(self);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.textColor = TEXT_LEVEL1_COLOR;
        titleLabel.text = @"图片标题";
        [self.alertView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).offset(20);
            make.centerX.equalTo(self.alertView);
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:(17)];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.alertView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@(40));
            make.leading.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView);
        }];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:(17)];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.alertView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@(40));
            make.trailing.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView);
        }];
        
        UILabel *topBorder = [[UILabel alloc] init];
        topBorder.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:topBorder];
        [topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.alertView);
            make.height.equalTo(@1);
            make.top.equalTo(cancelButton.mas_top);
            make.centerX.equalTo(self.alertView);
        }];
        UILabel *splitBorder = [[UILabel alloc] init];
        splitBorder.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:splitBorder];
        [splitBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.height.equalTo(cancelButton);
            make.top.equalTo(cancelButton.mas_top);
            make.centerX.equalTo(self.alertView);
        }];
        
        self.textField = [[UITextField alloc] init];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.layer.cornerRadius = 3;
        [self.textField.layer masksToBounds];
        self.textField.font = [UIFont systemFontOfSize:(15)];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        [self.alertView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(30));
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.leading.equalTo(self.alertView).offset(20);
            make.trailing.equalTo(self.alertView).offset(-20);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _textField.text = title;
}

- (void)setAlertCancelBlock:(CancelBlock)cancelBlock ConfirmBlock:(ConfirmBlock)confirmBlock {
    _cancelBlock = cancelBlock;
    _confirmBlock = confirmBlock;
}

- (void)cancelButtonClick {
    [self hiddenKeyBoard];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)confirmButtonClick {
    [self hiddenKeyBoard];
    if (_confirmBlock) {
        _confirmBlock(_textField.text);
    }
}

- (void)show {
    [self.textField becomeFirstResponder];
    if (self.alpha == 0) {
        self.alpha = 1.0;
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    self.alpha = 0.0;
}

- (void)textFieldResignFirstResponder {
    [self hiddenKeyBoard];
    self.textField.text = @"";
}

- (void)hiddenKeyBoard {
    [self.alertView endEditing:YES];
    [self dismiss];
}
@end
