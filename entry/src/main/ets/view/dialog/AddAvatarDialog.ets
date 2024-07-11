import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import picker from '@ohos.file.picker';
import { request } from '@kit.BasicServicesKit';


@Extend(Text)
function descStyle() {
  .fontSize($r('app.float.default_28'))
  .fontWeight(Const.FONT_WEIGHT_400)
  .fontFamily($r('app.string.HarmonyHeiTi'))
  .fontColor("#FF4955AC")
  .width(Const.FULL_WIDTH)
  .lineHeight($r('app.float.default_20'))
  .textAlign(TextAlign.Center)

}

@CustomDialog
export  struct AddAvatarDialog {

  private requestMediaPermission() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, ["ohos.permission.READ_MEDIA"], (error, result) => {
      if (result) {
        console.log("result: " + JSON.stringify(result));
      } else {
        console.log("error: " + JSON.stringify(error));
      }
    });
  }
  private openGallery() {
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    }, (error, result) => {
      if (result) {
        result.photoUris.forEach((url) => {
          console.log("url: " + url);
        })
      }
    });
  }


  controller: CustomDialogController = new CustomDialogController({ builder: '' });

  view: Function = () => {
  };
  build() {
    Column(){

        Text($r('app.string.select_from_album'))
          .descStyle()
          .margin({ top: $r('app.float.default_16') })
          .onClick(() =>{
            this.requestMediaPermission()
            this.openGallery()
          })

      Text()
        .size({width: "2px", height: "3%"})
        .backgroundColor("#bebbc1")

        Text($r('app.string.view_avatar'))
          .descStyle()
          .margin({ bottom: $r('app.float.default_6') })
          .onClick(() =>{
          this.view()
        })
    }
    .backgroundColor("#e6ffffff")
    .borderRadius(20)
  }
}

@CustomDialog
export  struct ShowAvatarDialog {

  controller: CustomDialogController = new CustomDialogController({ builder: '' });

  build() {
    Column(){
      Image($r('app.media.ic_user'))
        .objectFit(ImageFit.Fill)
        .height($r('app.float.default_316'))
        .width($r('app.float.default_316'))
      // .margin({ top: $r('app.float.default_71') })
    }

  }
}

function requestMediaPermission() {
  throw new Error('Function not implemented.');
}

function openGallery() {
  throw new Error('Function not implemented.');
}
