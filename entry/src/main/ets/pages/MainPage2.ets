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
import { common } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import Logger from '../common/utils/Logger';
import { ITaskItem } from '../model/TaskInitList';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { NavList, TabId } from '../model/NavItemModel';
import HomeIndex from '../view/HomeComponent2';
import { AchievementIndex } from '../view/AchievementComponent';
import { MineIndex } from './MinePage';
import { MomentsIndex } from './MomentsPage';
import { HomeStore } from '../viewmodel/HomeViewModel';
import GlobalInfoApi from '../common/database/tables/GlobalInfoApi';
import GlobalInfo from '../viewmodel/GlobalInfo';
import { GlobalContext } from '../common/utils/GlobalContext';
import { writeFile, readFile } from '../model/fileProcess';

@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Entry
@Component
struct Index {
  @State editedTaskInfo: ITaskItem = router.getParams() ? (router.getParams() as Record<string, Object>).editTask as ITaskItem : {
  } as ITaskItem;
  @State editedTaskID: string = '0';
  @State homeStore: HomeStore = new HomeStore(new Date());
  private tabController: TabsController = new TabsController();
  // @StorageProp('boolean') login_flag : boolean = AppStorage.get<boolean>('LOGIN_FLAG') ?? false;
  // @StorageLink('LOGIN_FLAG') LOGIN_FLAG: boolean = false;

  @Builder
  TabBuilder(index: number) {
    Column() {
      Image(index === 0 ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .objectFit(ImageFit.Contain)
        .offset({ y: (index === 0 ? -2 : 0) })
        .scale({x: (index === 0 ? 1.2 : 1), y: (index === 0 ? 1.2 : 1) })
        .animation({
          duration: 100,
          curve: Curve.Linear,
          iterations: 1,
          playMode: PlayMode.Normal
        });
      Text(NavList[index].text)
        .fontSize($r('app.float.default_10'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor(0 === index ? $r('app.color.blueColor') : $r('app.color.tabTitleColor'))
        .margin({ top: $r('app.float.default_4') })
    }.justifyContent(FlexAlign.Center).allSize()
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
      TabContent() {

          HomeIndex({ homeStore: $homeStore, editedTaskInfo: $editedTaskInfo })
            .borderWidth({ bottom: 1 })
            .borderColor($r('app.color.primaryBgColor'))

      }
      .tabBar(this.TabBuilder(TabId.HOME))
      .align(Alignment.Start)

      TabContent() {

          AchievementIndex()

      }
      .tabBar(this.TabBuilder(TabId.ACHIEVEMENT))

      TabContent() {

          MomentsIndex();

      }
      .tabBar(this.TabBuilder(TabId.MOMENTS));

      TabContent() {
        MineIndex()
          .borderWidth({ bottom: 1 })
          .borderColor($r('app.color.primaryBgColor'))
      }
      .tabBar(this.TabBuilder(TabId.MINE))
    }
    .scrollable(false)
    .allSize()
    .barWidth(Const.THOUSANDTH_940)
    .barMode(BarMode.Fixed)
    .vertical(false)

    // .animationDuration(100)
  }
}

export { Index };
