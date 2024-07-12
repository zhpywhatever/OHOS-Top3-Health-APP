import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import picker from '@ohos.file.picker';
import { request } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';


@Extend(Text)
function descStyle() {
  .fontSize($r('app.float.default_28'))
  .fontWeight(Const.FONT_WEIGHT_400)
  .fontFamily($r('app.string.HarmonyHeiTi'))
  .fontColor("#FF35B2DD")
  .width(Const.FULL_WIDTH)
  .lineHeight($r('app.float.default_20'))
  .textAlign(TextAlign.Center)

}

@CustomDialog
export  struct AddAvatarDialog {

  controller: CustomDialogController = new CustomDialogController({ builder: '' });

  view: Function = () => {
  };
  change: Function = () => {
  };
  build() {
    Column(){

        Text($r('app.string.select_from_album'))
          .descStyle()
          .margin({ top: $r('app.float.default_16') })
          .onClick(() =>{
            this.change()
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
  @State passVarBool : boolean = true;
  @State picPath : string = "";

  build() {
    Column(){
      Image(this.passVarBool ? $r('app.media.ic_user'):this.picPath)
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
