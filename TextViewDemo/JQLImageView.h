//
//  JQLImageView.h
//  TextViewDemo
//
//  Created by 井庆林 on 16/7/29.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "YYAnimatedImageView.h"
@class JQLImageView;

typedef void(^JQLImageViewEditBlock)(JQLImageView *imageView);
typedef void(^JQLImageViewMoveBlock)(JQLImageView *imageView, UILongPressGestureRecognizer *longPress);
typedef void(^JQLImageViewDeleteBlock)(JQLImageView *imageView);

@protocol JQLImageViewDataSource <NSObject>

- (void)p_longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress;

@end

@interface JQLImageView : UIView

@property (nonatomic, strong) id image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, copy) JQLImageViewEditBlock editBlock;
@property (nonatomic, copy) JQLImageViewMoveBlock moveBlock;
@property (nonatomic, copy) JQLImageViewDeleteBlock deleteBlock;
@property (nonatomic, copy) id<JQLImageViewDataSource> dataSource;

- (instancetype)initWithDataSourece:(id<JQLImageViewDataSource>)dataSource;

@end
