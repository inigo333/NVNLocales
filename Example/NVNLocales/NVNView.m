//
//  MIMView.m
//
//  Created by inigo mato


#import "NVNView.h"
#import <NVNLocales/NVNLocales-umbrella.h>

@interface NVNView ()



@end

@implementation NVNView

/////////////////////////////////////////////////
#pragma mark - Initialization
/////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = YES;
        self.delegate = delegate;
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];

        [self addSubview:self.label];
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:self.imageView];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self addSubview:self.pickerView];
       
        [self updateLocalisedStrings];
    }
    
    return self;
}

/////////////////////////////////////////////////
#pragma mark - Subview layout
/////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20.0, 50.0, self.label.frame.size.width, 20.0);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-[imageView]"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:nil
                                                                   views:@{@"label":self.label,@"imageView":self.imageView}]];
    
    self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-180, [UIScreen mainScreen].bounds.size.width, 180);
    NSInteger lang = [[[NVNLocalisationManager sharedInstance] allJSONFileNamesArray] indexOfObject:[NSString stringWithFormat:@"%@.json",[[NVNLocalisationManager sharedInstance] languageIdentifierStored]]];
    [self.pickerView selectRow:lang
                   inComponent:0
                      animated:NO];
}


/////////////////////////////////////////////////
#pragma mark - Localisation
/////////////////////////////////////////////////
- (void)updateLocalisedStrings
{
    NSString *stringToTranslate = MIMTranslate(@"USERREG_L-1_FIRSTNAME_LABEL");
    self.label.text = [NSString stringWithFormat:@"Text to localise: %@", stringToTranslate];
    self.labelStatus.text = @"abcdefghijklmnopqrstuvwxyz";
    [self setNeedsLayout];
}

/////////////////////////////////////////////////
#pragma mark - UIPickerView delegate methods
/////////////////////////////////////////////////
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Change Language to the selected one
    NSString *languageIdentifier = [[[[NVNLocalisationManager sharedInstance] allJSONFileNamesArray] objectAtIndex:row] substringToIndex:2];
    [[NVNLocalisationManager sharedInstance] updateLanguageIdentifier:languageIdentifier
                                                                  completionHandler:^
     {
         [self updateLocalisedStrings];
     }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[NVNLocalisationManager sharedInstance] allJSONFileNamesArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[[NVNLocalisationManager sharedInstance] allJSONFileNamesArray] objectAtIndex:row];
}

/////////////////////////////////////////////////
#pragma mark - UITextField delegate methods
/////////////////////////////////////////////////
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.labelStatus.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

/////////////////////////////////////////////////
#pragma mark - UIButton actions methods
/////////////////////////////////////////////////
- (void)button1SavePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(button1SavePressed:)])
    {
        [self.delegate performSelector:@selector(button1SavePressed:)
                            withObject:sender];
    }
}

- (void)button2FindPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(button2FindPressed:)])
    {
        [self.delegate performSelector:@selector(button2FindPressed:)
                            withObject:sender];
    }
}

@end
