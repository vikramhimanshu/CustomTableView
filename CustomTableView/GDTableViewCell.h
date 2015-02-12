//
//  GDTableViewCell.h
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDTableViewCell : UIView

@property (nonatomic, strong, readonly) NSString* reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
