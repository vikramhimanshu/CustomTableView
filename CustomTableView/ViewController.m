//
//  ViewController.m
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "ViewController.h"
#import "GDTableViewCell.h"
#import "GDTableView.h"

@interface ViewController () <GDTableViewDataSource, GDTableViewDelegate>

@property (nonatomic, retain) NSArray* tableRows;
@property (nonatomic, retain) GDTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"GDTableView";

    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:@"TableViewData"
                                             withExtension:@"plist"];
    self.tableRows = [NSArray arrayWithContentsOfURL:fileURL];

    self.tableView = (GDTableView*)self.view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor grayColor];
    [self.tableView reloadData];
}


#pragma mark - PGTableView dataSource and delegate methods

-(NSInteger)numberOfRowsInTableView:(GDTableView *)tableView
{
    return [self.tableRows count];
}

-(CGFloat)tableView:(GDTableView *)tableView heightForRow:(NSInteger)row
{
    NSString *text = [self.tableRows objectAtIndex: row];
    return CGRectGetHeight([self rectForString:text]);
}

-(GDTableViewCell *)tableView:(GDTableView *)tableView cellForRow:(NSInteger)row
{
    NSString *text = [self.tableRows objectAtIndex: row];
    GDTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell)
    {
        cell = [[GDTableViewCell alloc] initWithReuseIdentifier:@"cell"];
        UILabel *lbl = [[UILabel alloc] initWithFrame:[self rectForString:text]];
        lbl.numberOfLines = 0;
        lbl.text = text;
        lbl.font = [UIFont systemFontOfSize:12];
        [cell addSubview:lbl];
    }
    return cell;
}

- (CGRect)rectForString:(NSString *)string
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGRect lblRect = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
    return lblRect;
}

@end
