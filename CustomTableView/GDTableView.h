//
//  GDTableView.h
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDTableView;
@class GDTableViewCell;

@protocol GDTableViewDelegate <UIScrollViewDelegate>

@optional
- (CGFloat)tableView:(GDTableView*)tableView
        heightForRow:(NSInteger)row;
@end

@protocol GDTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInTableView:(GDTableView *)tableView;
- (GDTableViewCell*)tableView:(GDTableView *)tableView
                      cellForRow:(NSInteger)row;
@end

@interface GDTableView : UIScrollView

@property (nonatomic, assign) id<GDTableViewDataSource> dataSource;
@property (nonatomic, assign) id<GDTableViewDelegate> delegate;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat rowMargin;

- (GDTableViewCell *)dequeueReusableCellWithIdentifier:(NSString*)reuseIdentifier;

- (void) reloadData;

//- (void)row:(NSInteger)row changedHeight:(CGFloat)height;

- (NSIndexSet*)indexSetOfVisibleCells;

- (NSInteger)indexForRowAtY:(CGFloat)yPosition inRange:(NSRange)range;

@end
