//
//  CETableViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NotesListViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "NoteEditorViewController.h"

@interface NotesListViewController ()

@end

@implementation NotesListViewController

- (NSMutableArray*) notes
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.notes;
}

- (void)viewDidAppear:(BOOL)animated {
    // Whenever this view controller appears, reload the table. This allows it to reflect any changes
    // made whilst editing notes.
    [self.tableView reloadData];
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self notes].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UILabel* label; if (!label) {
        label = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
        label.text = @"test"; }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [label sizeToFit];
    return ceilf(label.frame.size.height * 1.7);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Note* note = [self notes][indexPath.row];
    cell.textLabel.text = note.title;
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UIColor* textColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
    NSDictionary *attrs =
        @{
          NSForegroundColorAttributeName : textColor,
         NSFontAttributeName : font,
         NSTextEffectAttributeName : NSTextEffectLetterpressStyle
        };
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:note.title
                                                                     attributes:attrs];
    cell.textLabel.attributedText = attrString;
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NoteEditorViewController* editorVC = (NoteEditorViewController*)segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"CellSelected"]) {
        // if the cell selected segue was fired, edit the selected note
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        editorVC.note = [self notes][path.row];
    }
    
    if ([segue.identifier isEqualToString:@"AddNewNote"]) {
        // if the add new note segue was fired, create a new note, and edit it
        editorVC.note = [Note noteWithText:@" "];
        // also, add this note to the collection
        [[self notes] addObject:editorVC.note];
    }
}

-(void)preferredContentSizeChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

@end
