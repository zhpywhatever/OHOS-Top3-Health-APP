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
import { CommonConstants as Const } from '../common/constants/CommonConstants';
// import App from '@system.app';
import { router } from '@kit.ArkUI';
import { checkLogin, UserInfo, getUserInfo, writeFile } from '../model/fileProcess';
import { promptAction } from '@kit.ArkUI';
import {getAvatarPath} from '../model/fileProcess';

@Entry
@Component
@Preview
export struct MineIndex {
  @State nickname: string = Const.NICK_NAME;
  @State password: string = "";
  @State signature: string = Const.SIGNATURE;
  @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";
  @State CUR_USER_AVATAR: string = "";
  // @State isLoggedIn: boolean = false;
  @StorageLink('LOGIN_FLAG') LOGIN_FLAG: Boolean = false;
  @StorageLink('PASS_TUTOR') PASS_TUTOR: string = "";
  @StorageLink('CUR_USER_INFO') CUR_USER_INFO: UserInfo = {username: "", password: "", whatcanIsay: ""};

  handleLogin(username: string, password: string) {
    let userInfo : UserInfo = {
      username: username,
      password: password,
    };
    checkLogin(userInfo).then((LOGIN_FLAG) => {
      if (LOGIN_FLAG) {
        console.log("登录成功");
        this.nickname = username;
        let storedInfo = getUserInfo(this.nickname);
        if (storedInfo && storedInfo.whatcanIsay) {
          this.signature = storedInfo.whatcanIsay;
        }
        this.LAST_LOGIN = this.nickname;
        this.LOGIN_FLAG = true;
        this.CUR_USER_INFO.username = this.LAST_LOGIN;
        this.CUR_USER_INFO.password = this.password;
        this.CUR_USER_INFO.whatcanIsay = this.signature;
        writeFile("LAST_LOGIN_FILE", this.LAST_LOGIN);
        writeFile("LOGIN_FLAG_FILE", this.LOGIN_FLAG.toString());

        promptAction.showToast({
          message: '欢迎登录!'
        });

        if (this.LOGIN_FLAG && !(this.PASS_TUTOR)) {
          router.pushUrl({ url: 'pages/highlight' });
          this.PASS_TUTOR = this.LAST_LOGIN;
          writeFile("PASS_TUTOR_FILE", this.PASS_TUTOR);
        }
      } else {
        console.log("登录失败");
        promptAction.showToast({
          message: '登录失败'
        });
      }
    })
    let test = router.getState();
    if (!(test.name === "MainPage")) {
      router.back();
    }
  }

  async handleRegister() {
    try {
      await router.pushUrl({ url: 'pages/RegisterPage' });
      console.log('Navigate to register page');
    } catch (err) {
      console.error(`Failed to navigate: ${err.message}`);
    }
  }

  @Builder LoginView() {
    Column() {
      Image($r('app.media.logo'))
        .width(100)
        .height(100)
        .margin({ top: 50, bottom: 20 })

      TextInput({ placeholder: '用户名' })
        .width('80%')
        .height(40)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          this.nickname = value;
        })

      TextInput({ placeholder: '密码' })
        .width('80%')
        .height(40)
        .type(InputType.Password)
        .margin({ bottom: 30 })
        .onChange((value: string) => {
          this.password = value;
        })

      Button('登录')
        .width('80%')
        .height(40)
        .onClick(() => {
          this.handleLogin(this.nickname, this.password);
        })

      Text('注册新账号')
        .fontColor(Color.Blue)
        .margin({ top: 20 })
        .onClick(() => this.handleRegister())
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear() {
    if (this.LOGIN_FLAG && this.LAST_LOGIN) {
      this.nickname = this.LAST_LOGIN;
      let storedInfo = getUserInfo(this.nickname);
      if (storedInfo?.whatcanIsay) {
        this.signature = storedInfo?.whatcanIsay;
      }
    }
  }

  build() {
    Column() {
      if (this.LOGIN_FLAG) {
        // 登录视图
        UserBaseInfo({
          nickname: this.CUR_USER_INFO.username,
          signature: this.CUR_USER_INFO.whatcanIsay
        });
        ListInfo();
      } else {
        this.LoginView();
      }
    }
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.mineBgColor'))
  }
}