//
//  MIMView.h
//
//  Created by inigo mato


@interface NVNView : UIView < UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate >

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UITextField *textFieldName;
@property (nonatomic, strong) UITextField *textFieldAddress;
@property (nonatomic, strong) UITextField *textFieldPhone;
@property (nonatomic, strong) UILabel *labelStatus;
@property (nonatomic, strong) UIButton *buttonSave;
@property (nonatomic, strong) UIButton *buttonFind;


- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate;


@end
