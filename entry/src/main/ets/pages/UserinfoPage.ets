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

import { ListInfo } from '../view/ListInfo';
import { UserBaseInfo } from '../view/UserBaseInfo';
import App from '@system.app';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { UserInfo, registerUser, userExists, hashPasswordToHex, updateUserInfo } from '../model/fileProcess';

@Entry
@Component
@Preview
export struct UserinfoIndex {
  @State nickname: string = "";
  @State password: string = "";
  @State password_again: string = "";
  @State signature: string = "";
  // @State isLoggedIn: boolean = false;
  @StorageLink('LAST_LOGIN') LAST_LOGIN : string = "";
  @StorageLink('CUR_USER_INFO') CUR_USER_INFO: UserInfo = {username: "", password: "", whatcanIsay: ""};

  handleSaveSignature(sig: string) {
    updateUserInfo(this.LAST_LOGIN, {whatcanIsay : sig});
    this.CUR_USER_INFO.whatcanIsay = sig;
    router.back();
  }

  @Builder UserinfoView() {
    Column() {
      UserBaseInfo({
        nickname: "",
        signature: ""
      })
        .width(100)
        .height(100)
        .margin({ top: 20, bottom: 40 })

      // Image($r('app.media.logo'))
      //   .width(100)
      //   .height(100)
      //   .margin({ top: 20, bottom: 20 })
      //   .borderRadius(50)

      // 用户昵称显示
      Text(this.LAST_LOGIN)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      TextInput({
        placeholder: '简单介绍一下自己吧，What can you say, man ?',
        text: this.signature
      })
        .width('80%')
        .height(80)
        .maxLength(100)
        .margin({ bottom: 30 })
        .borderColor("#689d6a")
        .borderWidth(1)
        .borderRadius(8)
        .padding(10)
        .onChange((value: string) => {
          this.signature = value;
        })

      Button('保存')
        .width('80%')
        .height(40)
        .backgroundColor("#689d6a")
        .fontColor($r('app.color.white'))
        .borderRadius(20)
        .onClick(() => {
          this.handleSaveSignature(this.signature);
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor("0000ff")
  }

  build() {
    Column() {
      this.UserinfoView();
    }
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.mineBgColor'))
  }
}