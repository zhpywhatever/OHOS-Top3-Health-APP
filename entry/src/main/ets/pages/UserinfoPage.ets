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
import { UserInfo, registerUser, userExists, hashPasswordToHex } from '../model/fileProcess';

@Entry
@Component
@Preview
export struct UserinfoIndex {
  @State nickname: string = "";
  @State password: string = "";
  @State password_again: string = "";
  @State signature: string = "";
  // @State isLoggedIn: boolean = false;
  // @StorageLink('LOGIN_FLAG') LOGIN_FLAG: Boolean = false;

  handleRegister(username : string, password :string, passwd_again: string, signiture: string){
    if (userExists(username)) {
      promptAction.showToast({
        message: '用户名已注册！'
      });
      router.back();
      return;
    }

    if (!(password === passwd_again)) {
      promptAction.showToast({
        message: '两次输入密码不一致，请重新注册！'
      });
      router.back();
      return;
    }

    hashPasswordToHex(password, (error, hashedPassword) => {
      if (error) {
        promptAction.showToast({
          message: '哈希也能出错 ? 写的什么破代码'
        });
        router.back();
        return;
      }

      if (hashedPassword) {
        let new_user: UserInfo = {
          password: hashedPassword,
          username: username,
          whatcanIsay: signiture
        };
        registerUser(new_user);
        promptAction.showToast({
          message: '注册成功,请登录'
        });
      } else {
        promptAction.showToast({
          message: '哈希也能出错 ? 写的什么破代码'
        });
        router.back();
        return;
      }
    });

    router.back();
  }

  @Builder UserinfoView() {
    Column() {
      UserBaseInfo({
        nickname: this.nickname,
        signature: this.signature
      });
      // Image($r('app.media.logo'))
      //   .width(100)
      //   .height(100)
      //   .margin({ top: 50, bottom: 20 })

      TextInput({ placeholder: '请输入用户名' })
        .width('80%')
        .height(40)
        .maxLength(20)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          this.nickname = value;
        })

      TextInput({ placeholder: '请输入密码' })
        .width('80%')
        .height(40)
        .maxLength(20)
        .type(InputType.Password)
        .margin({ bottom: 30 })
        .onChange((value: string) => {
          this.password = value;
        })

      TextInput({ placeholder: '请确认密码' })
        .width('80%')
        .height(40)
        .maxLength(20)
        .type(InputType.Password)
        .margin({ bottom: 30 })
        .onChange((value: string) => {
          this.password_again = value;
        })

      TextInput({ placeholder: '简单介绍一下自己吧，What can you say, man ?' })
        .width('80%')
        .height(40)
        .maxLength(20)
        .margin({ bottom: 30 })
        .onChange((value: string) => {
          this.signature = value;
        })

      Button('注册')
        .width('80%')
        .height(40)
        .onClick(() => {
          this.handleRegister(this.nickname, this.password, this.password_again, this.signature);
        })

    }
    .width('100%')
    .height('80%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      this.UserinfoView();
    }
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.mineBgColor'))
  }
}