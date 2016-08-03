//
//  MHImageTableViewCell.m
//  TextViewDemo
//
//  Created by 井庆林 on 16/8/3.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "MHImageTableViewCell.h"
#import "Masonry.h"

@implementation MHImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(2, 5, 2, 5));
        }];
        self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
        self.contentView.layer.borderWidth = 1.0;
        
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        [self.contentView addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
