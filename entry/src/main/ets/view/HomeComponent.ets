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
import { BroadCast, BroadCastType } from '../common/utils/BroadCast';
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
  @Provide broadCast: BroadCast = HealthDataSrcMgr.getInstance().getBroadCast();
  @State naviAlpha: number = 0;
  @Link homeStore: HomeStore;
  @Link editedTaskInfo: ITaskItem;
  @Link @Watch('taskChange') editedTaskID: string;
  @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";
  // @StorageLink('PASS_TUTOR') PASS_TUTOR: boolean = false;
  private scroller: Scroller = new Scroller();
  private yOffset: number = 0;
  ClickTitle: Function = () => {}

  taskChange() {
    this.homeStore.updateTaskInfoList(this.editedTaskInfo);
  }

  taskItemAction(item: TaskInfo, isClick: boolean): void {
    if (!this.homeStore.checkCurrentDay()) {
      return;
    }
    if (isClick) {
      // click to clock
      let callback: CustomDialogCallback = {
        confirmCallback: (taskTemp: TaskInfo) => {
          this.onConfirm(taskTemp)
        }, cancelCallback: () => {
        }
      };
      this.broadCast.emit(BroadCastType.SHOW_TASK_DETAIL_DIALOG, [item, callback]);
    } else {
      // edit task
      let editTaskStr: string = JSON.stringify(TaskMapById[item.taskID - 1]);
      let editTask: ITaskItem = JSON.parse(editTaskStr);
      editTask.targetValue = item?.targetValue;
      editTask.isAlarm = item.isAlarm;
      editTask.startTime = item.startTime;
      editTask.frequency = item.frequency;
      editTask.isOpen = item.isOpen;
      router.pushUrl({ url: 'pages/TaskEditPage', params: { params: JSON.stringify(editTask) } });
    }
  }

  //confirm clockL
  onConfirm(task: TaskInfo) {

    // promptAction.showToast({
    //   message: '仅供测试用'
    // });
    // this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, 1);

    this.homeStore.taskClock(task).then((res: AchievementInfo) => {
      if (res.showAchievement) {
        let achievementLevel = res.achievementLevel;
        if (achievementLevel) {
          this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, achievementLevel);
        } else {
          this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG);
        }
      }
    })
  }

  // change navigator alpha when scrolling the Scroll component
  onScrollAction() {
    this.yOffset = this.scroller.currentOffset().yOffset;
    if (this.yOffset > Const.DEFAULT_56) {
      this.naviAlpha = 1;
    } else {
      this.naviAlpha = this.yOffset / Const.DEFAULT_56;
    }
  }

  editTaskAction() {
    if (this.homeStore.checkCurrentDay()) {
      router.pushUrl({ url: 'pages/TaskListPage' });
      //router.pushUrl({ url: 'pages/highlight' });

      // if (!this.PASS_TUTOR) {
      //   router.pushUrl({ url: 'pages/highlight' });
      //   this.PASS_TUTOR = true;
      //   writeFile("PASS_TUTOR_FILE", this.PASS_TUTOR.toString());
      // } else {
      //   router.pushUrl({ url: 'pages/TaskListPage' });
      // }
    }
  }

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
                  clickAction: (isClick: boolean) => this.taskItemAction(item, isClick),
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
                    this.taskChange();
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
      .onScroll(() => {
        this.onScrollAction();
      })
      .align(Alignment.TopStart)

      AddBtn({
        clickAction: () => {
          this.editTaskAction();
        }
      })
      // .id('test')

      Row() {
        Text(`你好, ${this.LAST_LOGIN}`)
          .titleTextStyle()
          .fontSize($r('app.float.default_24'))
          .padding({ left: Const.THOUSANDTH_66 })
      }
      .width(Const.THOUSANDTH_1000)
      .height(Const.DEFAULT_56)
      .position({ x: 0, y: 0 })
      .backgroundColor(`rgba(${WHITE_COLOR_0X},${WHITE_COLOR_0X},${WHITE_COLOR_0X},${this.naviAlpha})`)
      .onClick(() => this.ClickTitle())

      CustomDialogView()
    }
    .allSize()
    .backgroundColor($r('app.color.primaryBgColor'))
  }
}

