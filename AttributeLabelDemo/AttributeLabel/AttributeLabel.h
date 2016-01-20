//
//  AttributeLabel.h
//  GMGClient
//
//  Created by GMCC on 15/11/18.
//  Copyright © 2015年 GMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttributeLabelDelegate <NSObject>

@optional
/** 特殊文字的点击方法 */
-(void)attributeLabelWithSpecialTextClick;

@end

@interface AttributeLabel : UITextView

/** 全文 */
@property (nonatomic,copy) NSString *attributeString;

/** 规则 */
@property (nonatomic,copy) NSString *rulesText;

/** 正常文字颜色 */
@property (nonatomic,strong) UIColor *otherTextColor;

/** 特殊文字颜色 */
@property (nonatomic,strong) UIColor *rulesTextColor;

/** 文字大小 */
@property (nonatomic,strong) UIFont *fontLabel;

/** 代理 */
@property (nonatomic,weak) id<AttributeLabelDelegate> attributeDelegate;

@end
