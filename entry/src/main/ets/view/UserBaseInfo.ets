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

@Entry
@Component
export struct UserBaseInfo {
  @Prop nickname: string = 'Top3';
  @Prop signature: string = '遥遥领先遥遥领先';

  controller: CustomDialogController = new CustomDialogController({
    builder: AddAvatarDialog({
      view: () => {
          this.viewAvatar()
      }
    }),
    cancel: () => {
      console.log("cancel")
    },
    autoCancel: true,
    customStyle: true
  });

  showController: CustomDialogController = new CustomDialogController({
    builder: ShowAvatarDialog(),
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

        Image($r('app.media.ic_user'))
          .objectFit(ImageFit.Contain)
          .height($r('app.float.default_66'))
          .width($r('app.float.default_66'))
          .margin({ top: $r('app.float.default_71') })
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