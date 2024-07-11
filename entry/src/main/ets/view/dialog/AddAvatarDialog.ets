import { CommonConstants as Const } from '../../common/constants/CommonConstants';

@Extend(Text)
function descStyle() {
  .fontSize($r('app.float.default_28'))
  .fontWeight(Const.FONT_WEIGHT_400)
  .fontFamily($r('app.string.HarmonyHeiTi'))
  .fontColor(Color.Blue)
  .width(Const.FULL_WIDTH)
  .lineHeight($r('app.float.default_20'))
  .textAlign(TextAlign.Center)

}

@CustomDialog
export  struct AddAvatarDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: '' });

  view: Function = () => {
  };
  build() {
    Column(){

        Text($r('app.string.select_from_album'))
          .descStyle()
          .margin({ top: $r('app.float.default_16') })

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