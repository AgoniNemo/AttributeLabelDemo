//
//  AttributeLabel.m
//  GMGClient
//
//  Created by GMCC on 15/11/18.
//  Copyright © 2015年 GMG. All rights reserved.
//

#import "AttributeLabel.h"
#import "RegexKitLite.h"
#import "TextPart.h"

@interface AttributeLabel ()
@property (nonatomic,assign) NSRange range;
@end

@implementation AttributeLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.scrollEnabled = NO;
        self.editable = NO;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.font = self.fontLabel ? self.fontLabel :[UIFont systemFontOfSize:16];
}
-(void)setAttributeString:(NSString *)attributeString
{
    _attributeString = attributeString;
    
    [self attributeText:attributeString];
}
-(void)attributeText:(NSString *)attributeString{

    if (self.rulesText.length <= 0) {
        return;
    }
    UIColor *attributeStringColor = self.otherTextColor ? self.otherTextColor : [UIColor lightGrayColor];
    UIColor *unAttributeStringColor = self.rulesTextColor ? self.rulesTextColor : [UIColor redColor];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSMutableArray *parts = [NSMutableArray array];
    
    [attributeString enumerateStringsSeparatedByRegex:self.rulesText usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
        
    }];
    
    [attributeString enumerateStringsMatchedByRegex:self.rulesText usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
        
        self.range = *capturedRanges;
    }];
    
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(TextPart *part1, TextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = _fontLabel ? _fontLabel : [UIFont systemFontOfSize:16];
    
    for (TextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.special) { // 特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : attributeStringColor}];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : unAttributeStringColor}];
        }
        [attributedText appendAttributedString:substr];
    }

    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    self.attributedText = attributedText;

}
-(void)setRulesText:(NSString *)rulesText
{
    _rulesText = rulesText;
    [self attributeText:self.attributeString];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // 触摸点
    CGPoint point = [touch locationInView:self];
     BOOL contains = NO;
    
    self.selectedRange = self.range;
    // 获得选中范围的矩形框
    NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
    self.selectedRange = NSMakeRange(0, 0);
    
    for (UITextSelectionRect *selectionRect in rects) {
        CGRect rect = selectionRect.rect;
        if (rect.size.width == 0 || rect.size.height == 0) continue;
        
        if (CGRectContainsPoint(rect, point)) { // 点中了某个特殊字符串
            contains = YES;
            break;
        }
    }
    if (contains) {
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            if ([self.attributeDelegate respondsToSelector:@selector(attributedText)]) {
                [self.attributeDelegate attributeLabelWithSpecialTextClick];
            }
        }
        
    }
}

@end
