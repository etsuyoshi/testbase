//
//  BSEditItemViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "BSItemAdminViewController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"


@interface BSEditItemViewController : GAITrackedViewController <UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>{
    
    
    //ローディング画像
    UIImageView *loadView;
    
    //写真
    UIImage *takePicture1;
    UIImage *takePicture2;
    UIImage *takePicture3;
    UIImage *takePicture4;
    UIImage *takePicture5;
    
    //写真ビュー
    UIButton *empButton1;
    UIButton *empButton2;
    UIButton *empButton3;
    UIButton *empButton4;
    UIButton *empButton5;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
    UIImageView *imageView5;
    
    //削除ボタン
    UIButton *deleteButton1;
    UIButton *deleteButton2;
    UIButton *deleteButton3;
    UIButton *deleteButton4;
    UIButton *deleteButton5;
    
    //写真撮影ボタン
    UIButton *pictureButton1;
    UIButton *pictureButton2;
    UIButton *pictureButton3;
    UIButton *pictureButton4;
    UIButton *pictureButton5;
    
    
    UIButton *takePictureButton1;
    UIButton *takePictureButton2;
    UIButton *takePictureButton3;
    UIButton *takePictureButton4;
    UIButton *takePictureButton5;
    
    
    //写真ボタンの情報
    UIButton *btnInf;
        
    //入力フォーム
    UITextField *itemName;
    UITextField *price;
    UITextView *detail;
    
    //在庫テーブル
    UITableView *stockTable;
    int stock1;
    UILabel *stockLabel1;
    
    //数量のピッカー
    UIPickerView *stockPicker;
    UIActionSheet *stockActionSheet;
    BOOL firstButton;
    int buttonTag;
    
    
    //バリエーションテーブル
    UITableView *variationTable1;
    UITableView *variationTable2;
    UITableView *variationTable3;
    UITableView *variationTable4;
    UITableView *variationTable5;
    
    //バリエーション追加ボタン
    UIButton *varyBtn;
    UILabel *varyLabel;
    UILabel *varyLabel2;
    UIButton *varyBtn2;
    UILabel *varyLabel3;
    UIButton *varyBtn3;
    UILabel *varyLabel4;
    UIButton *varyBtn4;
    UILabel *varyLabel5;
    UIButton *varyBtn5;
    UILabel *varyLabel6;
    UIButton *varyBtn6;
    int stock2;
    int stock3;
    int stock4;
    int stock5;
    int stock6;
    UILabel *stockLabel2;
    UILabel *stockLabel3;
    UILabel *stockLabel4;
    UILabel *stockLabel5;
    UILabel *stockLabel6;
    
    
    //バリエーションボタンの押された回数
    int varyPushCount;
    
    //公開テーブル
    UITableView *openTable;
    int visible;
    //公開スイッチ
    UISwitch *openSwitch;
    
    
    //保存ボタン
    UIButton *submitButton;
    UILabel *submitLabel;
    //キャンセルボタン
    UIButton *cancelButton;
    UILabel *cancelLabel;
    
    //テキストフィールドにフォーカスした時の座標
    CGPoint svos;
    
    
    //通信のデータ
    NSMutableData *receivedData;
    
    //１回のみ座標を変える
    BOOL oneMove;
    
    //getで在庫数を送るか、バリエーションを送るか
    int incVariation;
    
    //バリエーションが表示されているか
    int visibleVary1;
    int visibleVary2;
    int visibleVary3;
    int visibleVary4;
    int visibleVary5;
    
    //横線
    UIView *line1;
    UIView *line2;
    UIView *line3;
    UIView *line4;
    UIView *line5;
    UIView *line6;
    UIView *line7;
    UIView *line8;
    UIView *line9;
    UIView *line10;
    
    //複数の画像アップロード
    int tookPictures;
    
    //画像が二列表示か
    BOOL twoLine;
    
    //バリエーションがあるか
    int incVariation1;
    
    //バリエーションフィールド
    NSMutableArray *variationFieldArray;
    
    
    
    //取得した在庫数
    NSString *jsonStock;
    
    //
    NSMutableArray *importImageArray;
    
    //imageViewの画像を一度取得
    BOOL getImageDone;
    
    //バリデーションチェック
    BOOL validation;
    
    //画像アップロード
    int upTimes;
    NSString *jsonItemId;
    BOOL postConnect;
    
    //アップロード画像
    NSMutableArray *uploadImageArray;
    
    
    
    
}
- (IBAction)deleteItem:(id)sender;

//バリエーションのテキストフィールド
@property (retain, nonatomic) UITextField *varyField1;
@property (retain, nonatomic) UITextField *varyField2;
@property (retain, nonatomic) UITextField *varyField3;
@property (retain, nonatomic) UITextField *varyField4;
@property (retain, nonatomic) UITextField *varyField5;

//数量変更ボタン

@property (nonatomic,copy) NSString *importId;


@end
