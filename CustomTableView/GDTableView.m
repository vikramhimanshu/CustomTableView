//
//  GDTableView.m
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "GDTableView.h"
#import "GDTableViewCell.h"
#import "GDTableViewCellInternal.h"

@interface GDTableView ()

@property (nonatomic, retain) NSMutableArray *tableViewCellPrameters;
@property (nonatomic, retain) NSMutableSet *reusableCells;
@property (nonatomic, retain) NSMutableIndexSet *visibleCells;

@end

@implementation GDTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.rowHeight = 40;
        self.rowMargin = 1.0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rowHeight = 40;
        self.rowMargin = 1.0;
    }
    return self;
}

#pragma mark - public methods

-(GDTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    GDTableViewCell* reusableCell = nil;
    
    for (GDTableViewCell *tableViewCell in self.reusableCells)
    {
        if ([tableViewCell.reuseIdentifier isEqualToString:reuseIdentifier])
        {
            reusableCell = tableViewCell;
            break;
        }
    }
    
    if (reusableCell)
    {
        [self.reusableCells removeObject:reusableCell];
    }
    else
    {
        reusableCell = [[GDTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    
    return reusableCell;
}

- (void) reloadData
{
    [self resetVisibleCells: nil];
    [self calculateCellFrame];
    [self layoutTableViewCells];
}

- (NSIndexSet*)indexSetOfVisibleCells
{
    return [self.visibleCells copy];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self layoutTableViewCells];
}

- (void)layoutTableViewCells
{
    CGFloat currentStartY = [self contentOffset].y;
    CGFloat currentEndY = currentStartY + [self frame].size.height;
    
    NSInteger rowToDisplay = [self indexForRowAtY:currentStartY
                                             inRange: NSMakeRange(0, [self.tableViewCellPrameters count])];
    
    NSMutableIndexSet *newVisibleRows = [[NSMutableIndexSet alloc] init];
    
    CGFloat yOrigin;
    CGFloat rowHeight;
    do
    {
        [newVisibleRows addIndex:rowToDisplay];
        
        yOrigin = [self originYForRowAtIndex:rowToDisplay];
        rowHeight = [self heightForRowAtIndex:rowToDisplay];
        
        GDTableViewCell *cell = [self cachedCellForRowAtIndex: rowToDisplay];
        
        if (!cell)
        {
            cell = [self.dataSource tableView:self cellForRow:rowToDisplay];
            [self setCachedCell:cell forRowAtIndex:rowToDisplay];
            
            [cell setFrame: CGRectMake(0.0, yOrigin, [self bounds].size.width, rowHeight - _rowMargin)];
            [self addSubview: cell];
        }
        
        rowToDisplay++;
    }
    while (yOrigin + rowHeight < currentEndY && rowToDisplay < [[self tableViewCellPrameters] count]);

    [self resetVisibleCells:newVisibleRows];
}

- (void)resetVisibleCells:(NSMutableIndexSet*)currentVisibleRows
{
    [self.visibleCells removeIndexes:currentVisibleRows];
    [self.visibleCells enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop)
    {
         GDTableViewCell* tableViewCell = [self cachedCellForRowAtIndex:index];
         if (tableViewCell)
         {
             [self.reusableCells addObject:tableViewCell];
             [tableViewCell removeFromSuperview];
             [self setCachedCell:nil forRowAtIndex:index];
         }
    }];
    [self setVisibleCells:currentVisibleRows];
}

- (void)calculateCellFrame
{
    CGFloat currentTotalHeight = 0.0;
    
    NSMutableArray *cellParamsArray = [NSMutableArray array];
    
    NSInteger numberOfRows = [self.dataSource numberOfRowsInTableView:self];
    
    for (NSInteger row = 0; row<numberOfRows; row++)
    {
        GDTableViewCellInternal *cellParam = [[GDTableViewCellInternal alloc] init];
        CGFloat rowHeight = [self rowHeight];
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRow:)]) {
            rowHeight = [self.delegate tableView:self heightForRow:row];
        }
        cellParam.height = rowHeight + _rowMargin;
        cellParam.y = currentTotalHeight + _rowMargin;
        [cellParamsArray insertObject:cellParam atIndex:row];
        
        currentTotalHeight += rowHeight + _rowMargin;
    }
    self.tableViewCellPrameters = cellParamsArray;
    
    [self setContentSize:CGSizeMake(CGRectGetWidth(self.bounds), currentTotalHeight)];
}

- (NSInteger)indexForRowAtY:(CGFloat)yPosition inRange:(NSRange)range
{
    if ([[self tableViewCellPrameters] count] == 0) return 0;
    
    GDTableViewCellInternal *cellParam = [[GDTableViewCellInternal alloc] init];
    cellParam.y = yPosition;
    
    NSInteger returnValue = [[self tableViewCellPrameters] indexOfObject:cellParam
       inSortedRange: NSMakeRange(0, [[self tableViewCellPrameters] count])
             options: NSBinarySearchingInsertionIndex
     usingComparator: ^NSComparisonResult(GDTableViewCellInternal *cellParam1, GDTableViewCellInternal *cellParam2)
    {
         if (cellParam1.y < cellParam2.y) return NSOrderedAscending;
         return NSOrderedDescending;
    }];
    if (returnValue == 0) return 0;
    return returnValue-1;
}

- (CGFloat)originYForRowAtIndex:(NSInteger)rowIndex
{
    return ((GDTableViewCellInternal *)[self.tableViewCellPrameters objectAtIndex:rowIndex]).y;
}

- (CGFloat)heightForRowAtIndex:(NSInteger)rowIndex
{
    return ((GDTableViewCellInternal *)[self.tableViewCellPrameters objectAtIndex:rowIndex]).height;
}

- (GDTableViewCell*)cachedCellForRowAtIndex:(NSInteger)rowIndex
{
    return ((GDTableViewCellInternal *)[self.tableViewCellPrameters objectAtIndex:rowIndex]).cachedCell;
}

- (void)setCachedCell:(GDTableViewCell *)cell forRowAtIndex:(NSInteger)rowIndex
{
    ((GDTableViewCellInternal *)[self.tableViewCellPrameters objectAtIndex:rowIndex]).cachedCell = cell;
}

- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil) {
        _reusableCells = [[NSMutableSet alloc] init];
    }
    return _reusableCells;
}

- (NSMutableIndexSet *)visibleCells
{
    if (_visibleCells == nil) {
        _visibleCells = [[NSMutableIndexSet alloc] init];
    }
    return _visibleCells;
}

@end

