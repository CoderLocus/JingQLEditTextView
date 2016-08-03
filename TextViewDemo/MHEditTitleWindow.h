//
//  MHEditTitleWindow.h
//  TextViewDemo
//
//  Created by 井庆林 on 16/8/2.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();
typedef void(^ConfirmBlock)(NSString *title);

@interface MHEditTitleWindow : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UITextField *textField;

- (void)setAlertCancelBlock:(CancelBlock)cancelBlock ConfirmBlock:(ConfirmBlock)confirmBlock;
- (void)show;
- (void)dismiss;

@end
