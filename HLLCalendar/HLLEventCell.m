//
//  HLLEventCell.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLEventCell.h"
#import <Masonry.h>
#import "HLLEvent.h"
#import "UIColor+Common.h"

@interface HLLEventCell ()

@property (nonatomic ,strong) UILabel * titleLael;
@property (nonatomic ,strong) UILabel * dateLabel;
@property (nonatomic ,strong) UILabel * statusLabel;

@end

@implementation HLLEventCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLael = [UILabel new];
        self.titleLael.text = @"";
        self.titleLael.textAlignment = NSTextAlignmentCenter;
        self.titleLael.font = [UIFont systemFontOfSize:16];
        self.titleLael.textColor = [UIColor blackColor];
        self.titleLael.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLael];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.text = @"";
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.dateLabel];
        
        self.statusLabel = [UILabel new];
        self.statusLabel.text = @"";
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.statusLabel];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0).mas_offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
        //        make.height.mas_equalTo(40);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.titleLael.mas_left);
        make.right.mas_equalTo(self.titleLael.mas_right);
        //        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.titleLael.mas_bottom).mas_offset(5);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(20);
    }];
}

- (void)configCellWithData:(HLLEvent *)event{
    
    self.contentView.hidden = event.isEmpty;
    
    self.titleLael.text = event.title;
    self.dateLabel.text = event.dateString;
    
    self.statusLabel.text = event.statusText;
    self.statusLabel.backgroundColor = event.statusColor;
}

@end
