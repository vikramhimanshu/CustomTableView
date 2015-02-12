//
//  GDTableViewCell.m
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "GDTableViewCell.h"

@interface GDTableViewCell ()

@property (nonatomic, strong, readwrite) NSString* reuseIdentifier;

@end

@implementation GDTableViewCell

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
