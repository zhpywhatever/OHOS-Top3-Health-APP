/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { router } from '@kit.ArkUI';
import {AddAvatarDialog} from './dialog/AddAvatarDialog';
import {ShowAvatarDialog} from './dialog/AddAvatarDialog';
import {getAvatarPath} from '../model/fileProcess';

import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import picker from '@ohos.file.picker';
import { request } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

@Entry
@Component
export struct UserBaseInfo {
  @Prop nickname: string = 'Top3';
  @Prop signature: string = '遥遥领先遥遥领先';
// <<<<<<< HEAD
//   @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";
//   @State CUR_USER_AVATAR: string = getAvatarPath(this.LAST_LOGIN);
// =======
  @State IsLocalFlag:boolean=true;
  @State html: string = "权限状态未知";
  @State  pic :string ="";

  private async openGallery() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    let info = await bundleManager.getBundleInfoForSelf(0);

    if (info && info.appInfo) {
      let result = atManager.verifyAccessTokenSync(info.appInfo.accessTokenId, "ohos.permission.READ_MEDIA");
      if (abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED == result) {
        console.log("has permission")
      }
    } else {
      atManager.requestPermissionsFromUser(context, ["ohos.permission.READ_MEDIA"], (error, result) => {
        if (result) {
          console.log("result: " + JSON.stringify(result));
          if (result.authResults[0] == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
            // 用户授予权限
            this.html = "用户已经授权";
            this.openGalleryInternal();
          } else {
            // 用户拒绝权限
            this.html = "用户拒绝授权";
            console.log("permission denied")
          }
        } else {
          this.html = "请求授权异常：" + JSON.stringify(error);
          console.log("error: " + JSON.stringify(error));
        }
      });
    }
  }

  private openGalleryInternal() {
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    }, (error, result) => {
      if (result) {
        // this.uploadImages(result.photoUris);
        this.pic = result.photoUris[0];
        if (this.pic) {
          this.IsLocalFlag = false;
        }

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
    request.uploadFile(getContext(),{
      url: "http://127.0.0.1:8080/c/pic",
      method: "POST",
      files: allFiles,
      header: {},
      data: [
        {
          name: "test",
          value: "value"
        }
      ]
    }, (error, response) => {
      if(response) {
        response.on('progress', (uploadedSize: number, totalSize: number) => {
          console.log("progress, uploadedSize: " + uploadedSize + ", totalSize: " + totalSize)
        })
      } else {
        console.log("upload failure: " + error)
      }
    });
  }
// >>>>>>> c1ac16dd01f58dd65f58f39b64bc42bdc4aa9f04

  controller: CustomDialogController = new CustomDialogController({
    builder: AddAvatarDialog({
      view: () => {
          this.viewAvatar()
      },
      change:() => {
          this.openGallery()
      }
    }),
    cancel: () => {
      console.log("cancel")
    },
    autoCancel: true,
    customStyle: true
  });

  showController: CustomDialogController = new CustomDialogController({
    builder: ShowAvatarDialog({
    passVarBool : this.IsLocalFlag,
    picPath : this.pic
    }),
    cancel: () => {
      console.log("cancel")
    },
    autoCancel: true,
    customStyle: true
  });

  viewAvatar(){
      this.showController.open()
  }



  build() {
    Column() {
      // userIcon
      Stack(){
        Image($r('app.media.user_image_frame'))
          .height($r('app.float.default_100'))
          .width($r('app.float.default_100'))
          .margin({ top: $r('app.float.default_71') })

        Image(this.IsLocalFlag ? $r('app.media.ic_user'):this.pic)
          .objectFit(ImageFit.Contain)
          .height($r('app.float.default_66'))
          .width($r('app.float.default_66'))
          .margin({ top: $r('app.float.default_71') })
          .borderRadius(100)
          .onClick(
            () => {
              this.controller.open()
            }
          )


      }

      Column() {
        Text('LV.7')
          .fontSize($r('app.float.default_12'))
          .fontWeight(FontWeight.Bolder)
          .fontColor($r('app.color.leveColor'))
      }
      .width($r('app.float.default_44'))
      .height($r('app.float.default_16'))
      .margin({ top: $r('app.float.default_n8') })
      .border({ radius: $r('app.float.default_5') })
      .backgroundColor($r('app.color.leveBgColor'))
      .justifyContent(FlexAlign.Center)

      // nickname
      Text(this.nickname)
        .fontSize($r('app.float.default_20'))
        .fontFamily($r('app.string.Helvetica'))
        .margin({ bottom: $r('app.float.default_6') })
        .fontWeight(FontWeight.Normal)
        .fontColor($r('app.color.black'))

      // signature
      Text(this.signature).fontSize($r('app.float.default_16')).fontWeight(FontWeight.Normal)
        .fontFamily($r('app.string.PingFangSC_Regular'))
        .fontColor($r('app.color.signatureColor'))
    }
  }
}