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
  .fontColor(Color.Blue)
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
  private uploadImages(paths: string[]) {
    let allFiles = Array<request.File>()
    for (let i = 0; i <paths.length; i++) {
      let path = paths[i]
      console.log("path: " + path)
      allFiles[i] = {
        name: "image" + i + ".jpg",
        filename: "image" + i + ".jpg",
        uri: path,
        type: "image"
      }
    }
    // request.upload({
    //   url: "http://192.168.1.5:8080/java_0101_fileupload_war_exploded/uploadServlet",
    //   method: "POST",
    //   files: allFiles,
    //   header: {},
    //   data: [
    //     {
    //       name: "test",
    //       value: "value"
    //     }
    //   ]
    // }, (error, response) => {
    //   if(response) {
    //     response.on('progress', (uploadedSize: number, totalSize: number) => {
    //       console.log("progress, uploadedSize: " + uploadedSize + ", totalSize: " + totalSize)
    //     })
    //   } else {
    //     console.log("upload failure: " + error)
    //   }
    // });
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
