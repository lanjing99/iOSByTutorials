//
//  CENoteEditorControllerViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "Note.h"

@interface NoteEditorViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteEditorViewController
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = self.note.contents;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // copy the updated note text to the underlying model.
    self.note.contents = textView.text;
}

-(void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
