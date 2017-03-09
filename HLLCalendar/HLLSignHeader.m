//
//  HLLSignHeader.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLSignHeader.h"
#import "UIColor+Common.h"
#import <Masonry.h>
#import "NSDate+Common.h"

@interface HLLSignHeader ()

@property (nonatomic ,strong) UIView * leftSepLineView;
@property (nonatomic ,strong) UIView * rightSepLineView;

@property (nonatomic ,strong) UILabel * monthLabel;
@property (nonatomic ,strong) UILabel * amLabel;
@property (nonatomic ,strong) UILabel * pmLabel;

@property (nonatomic ,strong) UIView * bottomSepLineView;
@end
@implementation HLLSignHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"53B1D9"];
        
        self.monthLabel = [UILabel new];
        self.monthLabel.text = [NSString stringWithFormat:@"%ld月",(long)[[NSDate date] getMonth]];
        self.monthLabel.font = [UIFont systemFontOfSize:17];
        self.monthLabel.textColor = [UIColor whiteColor];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.monthLabel];
        
        self.leftSepLineView = [[UIView alloc] init];
        self.leftSepLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftSepLineView];
        
        self.amLabel = [UILabel new];
        self.amLabel.text = @"上午";
        self.amLabel.font = [UIFont systemFontOfSize:17];
        self.amLabel.textColor = [UIColor whiteColor];
        self.amLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.amLabel];
        
        self.rightSepLineView = [[UIView alloc] init];
        self.rightSepLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.rightSepLineView];
        
        self.pmLabel = [UILabel new];
        self.pmLabel.text = @"下午";
        self.pmLabel.font = [UIFont systemFontOfSize:17];
        self.pmLabel.textColor = [UIColor whiteColor];
        self.pmLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.pmLabel];
        
        self.bottomSepLineView = [[UIView alloc] init];
        self.bottomSepLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomSepLineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat monthWidth = 120; // 😱hard code😱
    CGFloat apmWidth = ([UIScreen mainScreen].bounds.size.width - monthWidth) / 2 ;
    
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(monthWidth);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.bottomSepLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.leftSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthLabel.mas_right);
        make.top.mas_equalTo(self.monthLabel.mas_top);
        make.width.mas_equalTo(self.bottomSepLineView.mas_height);
        make.bottom.mas_equalTo(self.monthLabel.mas_bottom);
    }];
    
    [self.amLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.monthLabel.mas_right);
        make.top.mas_equalTo(self.monthLabel.mas_top);
        make.bottom.mas_equalTo(self.monthLabel.mas_bottom);
        make.width.mas_equalTo(apmWidth);
    }];
    
    [self.rightSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amLabel.mas_right);
        make.top.mas_equalTo(self.amLabel.mas_top).mas_offset(20);
        make.width.mas_equalTo(self.leftSepLineView.mas_width);
        make.bottom.mas_equalTo(self.amLabel.mas_bottom).mas_offset(-20);
    }];
    
    [self.pmLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.amLabel.mas_right);
        make.top.mas_equalTo(self.amLabel.mas_top);
        make.bottom.mas_equalTo(self.amLabel.mas_bottom);
        make.width.mas_equalTo(apmWidth);
    }];
}

@end
