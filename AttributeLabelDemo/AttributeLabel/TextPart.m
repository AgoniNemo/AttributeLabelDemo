//
//  TextPart.m
//  GMGAgent
//
//  Created by GMCC on 16/1/20.
//  Copyright © 2016年 GMG. All rights reserved.
//

#import "TextPart.h"

@implementation TextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
