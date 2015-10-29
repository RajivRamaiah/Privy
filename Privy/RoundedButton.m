//
//  RoundedButton.m
//  Privy
//
//  Created by Kellen Pierson on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.layer.cornerRadius = 4;
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
