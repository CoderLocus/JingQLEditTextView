//
//  JQLImageView.m
//  TextViewDemo
//
//  Created by 井庆林 on 16/7/29.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "JQLImageView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface JQLImageView()

@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIButton *moveButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation JQLImageView

- (instancetype)initWithDataSourece:(id<JQLImageViewDataSource>)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
        
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.height.equalTo(_imageView.mas_width);
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(5);
            make.centerX.equalTo(self);
        }];
        
        UIImageView *moveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XCylbj"]];
        moveImageView.userInteractionEnabled = YES;
        [self addSubview:moveImageView];
        [moveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@35);
            make.height.equalTo(moveImageView.mas_width);
            make.top.equalTo(self).offset(20);
            make.trailing.equalTo(self).offset(-20);
        }];
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        _longPress.minimumPressDuration = 0.5;
        [moveImageView addGestureRecognizer:_longPress];
        
//        _moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_moveButton setBackgroundImage:[UIImage imageNamed:@"XCylsc"] forState:UIControlStateNormal];
//        [_moveButton setBackgroundImage:[UIImage imageNamed:@"XCylsc"] forState:UIControlStateHighlighted];
//        [_moveButton addTarget:self action:@selector(move) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:_moveButton];
//        [_moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@35);
//            make.height.equalTo(_moveButton.mas_width);
//            make.top.equalTo(self).offset(20);
//            make.trailing.equalTo(self).offset(-20);
//        }];
        
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setBackgroundImage:[UIImage imageNamed:@"XCylsc"] forState:UIControlStateNormal];
        [_showButton setBackgroundImage:[UIImage imageNamed:@"XCylbj"] forState:UIControlStateSelected];
        [_showButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showButton];
        [_showButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(moveImageView.mas_width);
            make.height.equalTo(moveImageView.mas_height);
            make.bottom.equalTo(_imageView).offset(-20);
            make.trailing.equalTo(self).offset(-20);
        }];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = !_showButton.selected;
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"XCylsc"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(moveImageView.mas_width);
            make.height.equalTo(moveImageView.mas_height);
            make.bottom.equalTo(_imageView).offset(-20);
            make.trailing.equalTo(_showButton).offset(-50);
        }];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.hidden = !_showButton.selected;
        [_editButton setBackgroundImage:[UIImage imageNamed:@"XCylbj"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editButton];
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(moveImageView.mas_width);
            make.height.equalTo(moveImageView.mas_height);
            make.bottom.equalTo(_imageView).offset(-20);
            make.trailing.equalTo(_showButton).offset(-100);
        }];
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        self.title = @"";
    }
    return self;
}

- (void)setImage:(id)image {
    _image = image;
    if ([image isKindOfClass:[UIImage class]]) {
        _imageView.image = image;
    } else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _image = image;
        }];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)show {
    _deleteButton.hidden = _showButton.selected;
    _editButton.hidden   = _showButton.selected;
    _showButton.selected = !_showButton.selected;
}

- (void)delete {
    if (self.deleteBlock) self.deleteBlock(self);
}

- (void)move:(UILongPressGestureRecognizer *)longPress {
    if (self.moveBlock) self.moveBlock(self, longPress);
}

- (void)edit {
    if (self.editBlock) self.editBlock(self);
}

@end
