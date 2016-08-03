//
//  MHStringTableViewCell.m
//  TextViewDemo
//
//  Created by 井庆林 on 16/8/3.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "MHStringTableViewCell.h"
#import "Masonry.h"


@implementation MHStringTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(2, 5, 2, 5));
        }];
        self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
        self.contentView.layer.borderWidth = 1.0;
        
        _stringLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_stringLabel];
        [_stringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
