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
import HealthText from './HealthTextComponent';
import AddBtn from '../view/home/AddBtnComponent';
import { TaskCard } from '../view/home//TaskCardComponent';
import HomeTopView from '../view/home/HomeTopComponent';
import { CustomDialogView, CustomDialogCallback } from '../view/dialog/CustomDialogView';
import TaskInfo from '../viewmodel/TaskInfo';
import TaskInfoApi from '../common/database/tables/TaskInfoApi'
import { HomeStore } from '../viewmodel/HomeViewModel';
import { ITaskItem, TaskMapById } from '../model/TaskInitList';
import { HealthDataSrcMgr } from '../common/utils/HealthDataSrcMgr';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import AchievementInfo from '../viewmodel/AchievementInfo';
import { writeFile } from '../model/fileProcess';

// import { promptAction } from '@kit.ArkUI';

const WHITE_COLOR_0X = 255;

@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Extend(Text)
function titleTextStyle() {
  .fontSize($r('app.float.default_16'))
  .fontWeight(Const.FONT_WEIGHT_500)
  .width(Const.THOUSANDTH_1000)
  .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
  .fontColor($r(`app.element.color.titleColor`))
  .padding({
    top: Const.THOUSANDTH_15,
    bottom: Const.THOUSANDTH_15,
    left: Const.THOUSANDTH_33
  })
}

@Component
export default struct HomeIndex {
  @State naviAlpha: number = 0;
  @Link homeStore: HomeStore;
  @Link editedTaskInfo: ITaskItem;
  @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";
  // @StorageLink('PASS_TUTOR') PASS_TUTOR: boolean = false;
  private scroller: Scroller = new Scroller();
  private yOffset: number = 0;


  build() {
    Stack() {
      Scroll(this.scroller) {
        Column() {
          HomeTopView({ homeStore: $homeStore })
          Text($r('app.string.task_list')).titleTextStyle()
          if (this.homeStore.getTaskListOfDay().length > 0) {
            Column({ space: Const.DEFAULT_8 }) {
              ForEach(this.homeStore.getTaskListOfDay(), (item: TaskInfo) => {
                TaskCard({
                  taskInfoStr: JSON.stringify(item),
                  deleteTask: () => {
                    // Execute deletion
                    item.isOpen = false;
// <<<<<<< HEAD
//
// =======
// >>>>>>> 70dab8b598e74d14cdfcb0e2072174ab167c5fd8
                    // Remove daily task
                    // this.homeStore.updateTask(item);
                    // Remove global task list
                    item.date = 'global'
                    this.homeStore.updateTask(item);
                    // Update daily goal and task number
                    this.editedTaskInfo.taskID = item.taskID;
                    this.editedTaskInfo.isOpen = false;

                  }
                })
                  .margin({ bottom: Const.DEFAULT_12})
                  .height($r('app.float.default_64'))
              }, (item: TaskInfo) => JSON.stringify(item))
            }
            .onAppear(() => {
              this.scroller.scrollTo({ xOffset: 0, yOffset: this.yOffset });
            })
            .padding({
              top: Const.THOUSANDTH_15,
              left: Const.THOUSANDTH_33,
              right: Const.THOUSANDTH_33
            })
            .width(Const.THOUSANDTH_1000)
          } else {
            Column({ space: Const.DEFAULT_8 }) {
              Image($r('app.media.ic_no_data'))
                .width($r('app.float.default_132'))
                .height($r('app.float.default_100'));
              HealthText({ title: '', titleResource: $r('app.string.no_task'), fontSize: $r('app.float.default_14') })
                .opacity(Const.OPACITY_4)
            }
            .margin({ top: Const.DEFAULT_48 })
          }
        }
      }
      .scrollBar(BarState.Off)
      .allSize()
      .align(Alignment.TopStart)

      AddBtn({
        clickAction: () => {

        }
      })
      //.id('test')

      Row() {
        Text(`你好, 欢迎登陆`)
          .titleTextStyle()
          .fontSize($r('app.float.default_24'))
          .padding({ left: Const.THOUSANDTH_66 })
      }
      .width(Const.THOUSANDTH_1000)
      .height(Const.DEFAULT_56)
      .position({ x: 0, y: 0 })
      .backgroundColor(`rgba(${WHITE_COLOR_0X},${WHITE_COLOR_0X},${WHITE_COLOR_0X},${this.naviAlpha})`)


    }
    .allSize()
    .backgroundColor($r('app.color.primaryBgColor'))
  }
}

