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

import { router, Scale } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import Logger from '../common/utils/Logger';
import { ITaskItem } from '../model/TaskInitList';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { NavList, TabId } from '../model/NavItemModel';
import HomeIndex from '../view/HomeComponent';
import { AchievementIndex } from '../view/AchievementComponent';
import { MineIndex } from './MinePage';
import { MomentsIndex } from './MomentsPage';
import { HomeStore } from '../viewmodel/HomeViewModel';
import GlobalInfoApi from '../common/database/tables/GlobalInfoApi';
import GlobalInfo from '../viewmodel/GlobalInfo';
import { GlobalContext } from '../common/utils/GlobalContext';
import { promptAction } from '@kit.ArkUI';
import { writeFile, readFile, UserInfo } from '../model/fileProcess';
import { HighLightGuideBuilder, HighLightGuideComponent, Controller, GuidePage, HighLightShape, RectF } from '@ohos/high_light_guide';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

const EXPAND_FLOOR_INTERVAL_TIME: number = 50;
const PACK_FLOOR_INTERVAL_TIME: number = 10;
const FLING_FACTOR: number = 1.0;
const OFFSET_STEP: number = 30;
const TRIGGER_HEIGHT: number = 200;
const MINI_SHOW_DISTANCE: number = 3;

@Entry
@Component
struct Index {
  @State currentPage: number = 0;
  @State editedTaskInfo: ITaskItem = router.getParams() ? (router.getParams() as Record<string, Object>).editTask as ITaskItem : {
  } as ITaskItem;
  @State editedTaskID: string = '0';
  @State homeStore: HomeStore = new HomeStore(new Date());
  private tabController: TabsController = new TabsController();
  // @StorageProp('boolean') login_flag : boolean = AppStorage.get<boolean>('LOGIN_FLAG') ?? false;
  @StorageLink('LOGIN_FLAG') LOGIN_FLAG: boolean = false;
  @StorageLink('CUR_USER_INFO') CUR_USER_INFO: UserInfo = {username: "", password: "", whatcanIsay: ""};
  @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";
  @StorageLink('CUR_USER_AVATAR') CUR_USER_AVATAR: string = "";

  @State displaySecondFloor: boolean = false;
  private expandFloorTriggerDistance: number = 180;
  private packUpFloorTriggerDistance: number = 100;
  @State dragging: boolean = false;
  private lastY: number = 0;
  @State immediatelyScale: Scale = { x: 0, y: 0 };
  @State roundSize: number = 0;
  @State onShow: boolean = false;
  @State animationXLeft: number = 60;
  @State animationXRight: number = -60;
  private floorHeight: number = 715;
  @State offsetY: number = -this.floorHeight;
  @State miniAppScale: Scale = { x: 0, y: 0 };
  @State checkInDates: number = 0;
  @State footsteps: number = 0;

  private LastX: number = 0;
  private LastY: number = 0;
  private LastZ: number = 0;
  private LastTime: number = 0;

  private Shake() {
    try {
      sensor.on(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
        this.handleShake(data);
      }, { interval: 100000000 });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
  }
  private handleShake(data: sensor.AccelerometerResponse) {

    const currentTime = new Date().getTime();
    const timeDifference = currentTime - this.LastTime;

    if (timeDifference > 100) {
      const deltaX = data.x - this.LastX;
      const deltaY = data.y - this.LastY;
      const deltaZ = data.z - this.LastZ;

      this.LastX = data.x;
      this.LastY = data.y;
      this.LastZ = data.z;
      this.LastTime = currentTime;

      const shakeThreshold = 3; // 摇动阈值，根据需要调整

      if (deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ > shakeThreshold * shakeThreshold) {
        this.footsteps += 1;
      }
    }
  }

  aboutToAppear() {
    this.Shake();

    let tmp_my_value: number = Number(readFile("MY_VALUE_FILE"));
    let tmp_login_flag: boolean = readFile("LOGIN_FLAG_FILE").toLowerCase() === 'true';
    let tmp_pass_tutor: string = readFile("PASS_TUTOR_FILE");

    if (!tmp_my_value) {
      AppStorage.setOrCreate('MY_VALUE', 0);
    } else if (tmp_my_value != 0) {
      AppStorage.SetOrCreate('MY_VALUE', tmp_my_value);
    }

    if (!tmp_login_flag) {
      AppStorage.setOrCreate('LOGIN_FLAG', false);
    } else {
      AppStorage.SetOrCreate('LOGIN_FLAG', tmp_login_flag);
      AppStorage.SetOrCreate('LAST_LOGIN', readFile("LAST_LOGIN_FILE"));
      this.CUR_USER_INFO.username = this.LAST_LOGIN;
      this.CUR_USER_AVATAR = readFile("CUR_USER_AVATAR_FILE");

      if (tmp_pass_tutor) {
        AppStorage.SetOrCreate('PASS_TUTOR', tmp_pass_tutor);
      }

    }

    notificationManager.requestEnableNotification().then(() => {
      Logger.info('onPageShow', `requestEnableNotification success`);
    }).catch((err: Error) => {
      Logger.error('onPageShow', `requestEnableNotification failed, message is ${err.message}`);
    });
  }

  onPageShow() {
    Logger.info('onPageShow', JSON.stringify(router.getParams()));
    let params = (router.getParams() ? router.getParams() : {}) as Record<string, Object>;
    let result = params.editTask ? params.editTask as string : '{}';
    this.editedTaskInfo = JSON.parse(result);
    this.editedTaskID = JSON.stringify(this.editedTaskInfo);
    if ((GlobalContext.getContext().getObject('isForeground') as boolean)) {
      GlobalContext.getContext().setObject('isForeground', false);
      if (this.homeStore.currentDate.getDate() !== (new Date()).getDate()) {
        GlobalContext.getContext().setObject('taskListChange', true);
        this.homeStore = new HomeStore(new Date());
      }
      this.checkCurrentTime();

      // let tmp_login_flag : boolean= AppStorage.get('LOGIN_FLAG') ?? false;
      // if (!tmp_login_flag) {
      //   promptAction.showToast({
      //     message: '请先登录！'
      //   });
      //   router.pushUrl( {url: 'pages/MinePage' });
      // }
    }
  }

  private expandSecondFloor(): void {
    this.checkCurrentTime();
    if (this.offsetY < 0) {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut,
        iterations: 1,
        playMode: PlayMode.Normal,
        finishCallbackType: FinishCallbackType.REMOVED,
        onFinish: () => {
          this.onShow = false;
        }
      }, () => {
        this.offsetY = 0;
        // 在Y轴为达到0的时候缩放比例为正常显示
        this.miniAppScale = { x: 1, y: 1 };
        this.displaySecondFloor = true;
      });
    }
  }

  private packUpSecondFloor(): void {
    if(this.offsetY !== -this.floorHeight) {
      let intervalId = setInterval(() => {
        if (this.offsetY <= -this.floorHeight) {
          this.offsetY = -this.floorHeight;
          clearInterval(intervalId);
        } else {
          // 相当于回弹的速度
          this.offsetY = (this.offsetY - OFFSET_STEP >= -this.floorHeight)? this.offsetY - OFFSET_STEP : -this.floorHeight;
        }
      }, PACK_FLOOR_INTERVAL_TIME)
      this.displaySecondFloor = false;
    }
  }

  private scrollByTop(): void {
    // 坐标位置不等于二楼高度进入判断
    if (this.offsetY !== -this.floorHeight) {
      let intervalId = setInterval(() => {
        if (this.offsetY <= -this.floorHeight) {
          this.offsetY = -this.floorHeight;
          clearInterval(intervalId);
        } else {
          // 相当于回弹的速度
          this.offsetY = ((this.offsetY - OFFSET_STEP) < -this.floorHeight) ? (-this.floorHeight) : (this.offsetY - OFFSET_STEP);
        }
        if (((this.floorHeight - Math.abs(this.offsetY)) <= TRIGGER_HEIGHT) && (this.floorHeight - Math.abs(this.offsetY)) >= 60) {
          this.animationXLeft = 60;
          this.animationXRight = -60;
          // this.totalY / TRIGGER_HEIGHT
          this.animationXLeft = this.animationXLeft - ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT) * 60;
          this.animationXRight = this.animationXRight + ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT) * 60;
          this.immediatelyScale = {
            x: ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT),
            y: ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT)
          };
        } else if (((this.floorHeight - Math.abs(this.offsetY)) < 60)) {
          this.roundSize = 0;
          this.roundSize = 20 * ((this.floorHeight - Math.abs(this.offsetY)) / 60);
          this.immediatelyScale = {
            x: 0,
            y: 0
          };
        } else {
          this.roundSize = 20;
          this.immediatelyScale = { x: 1, y: 1 };
          this.animationXLeft = 0;
          this.animationXRight = 0;
        }
      }, EXPAND_FLOOR_INTERVAL_TIME);
    } else {
      Logger.debug("scrollByTop(): already scrolled to top edge")
    }
  }

  checkCurrentTime() {
    GlobalInfoApi.query((result: GlobalInfo) => {
      let predate = new Date(result.lastDate);
      let date = new Date();
      if (result && date.getTime() < predate.getTime()) {
        AlertDialog.show(
          {
            title: $r('app.string.alert'),
            message: $r('app.string.alert_message'),
            autoCancel: false,
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -20 },
            gridCount: 3,
            confirm: {
              value: $r('app.string.alert_button'),
              action: () => {
                (getContext(this) as common.UIAbilityContext).terminateSelf();
                console.info('Button-clicking callback');
              }
            },
            cancel: () => {
              console.info('Closed callbacks');
            }
          });
      } else {
        this.homeStore.initData();
      }
      this.checkInDates = result?.checkInDays;
    });
  }

  @Builder
  TabBuilder(index: number) {
    Column() {
      Image(index === this.currentPage ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .objectFit(ImageFit.Contain)
        .offset({ y: (index === this.currentPage ? -2 : 0) })
        .scale({x: (index === this.currentPage ? 1.2 : 1), y: (index === this.currentPage ? 1.2 : 1) })
        .animation({
          duration: 100,
          curve: Curve.Linear,
          iterations: 1,
          playMode: PlayMode.Normal
        });
      Text(NavList[index].text)
        .fontSize($r('app.float.default_10'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor(this.currentPage === index ? $r('app.color.blueColor') : $r('app.color.tabTitleColor'))
        .margin({ top: $r('app.float.default_4') })
    }.justifyContent(FlexAlign.Center).allSize()
  }

  @Builder
  FloorBuilder() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
      TabContent() {
        if(this.LOGIN_FLAG){
          HomeIndex({ homeStore: $homeStore, editedTaskInfo: $editedTaskInfo, editedTaskID: $editedTaskID })
            .borderWidth({ bottom: 1 })
            .borderColor($r('app.color.primaryBgColor'))
        }
        else{
          MineIndex()
            .borderWidth({ bottom: 1 })
            .borderColor($r('app.color.primaryBgColor'))
        }
      }
      .tabBar(this.TabBuilder(TabId.HOME))
      .align(Alignment.Start)

      TabContent() {
        if(this.LOGIN_FLAG){
          AchievementIndex()
        }
        else{
          MineIndex()
            .borderWidth({ bottom: 1 })
            .borderColor($r('app.color.primaryBgColor'))
        }
      }
      .tabBar(this.TabBuilder(TabId.ACHIEVEMENT))

      TabContent() {
        if(this.LOGIN_FLAG) {
          MomentsIndex();
        }
        else{
          MineIndex()
            .borderWidth({ bottom: 1 })
            .borderColor($r('app.color.primaryBgColor'))
        }
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
    .onChange((index) => {
      this.currentPage = index;
    })
    // .animationDuration(100)
  }

  @Builder
  SecondFloorBuilder() {
    Column(){
      Stack() {
        Image($r('app.media.tree_background'))
          .height('100%')
        Column(){
          if(this.checkInDates > 0 && this.checkInDates <= 3) {
            Image($r('app.media.sapling'))
              .height('10%')
              .margin({top: '103%', left: '-3%'})
          } else if(this.checkInDates > 3) {
            Image($r('app.media.tree'))
              .height('45%')
              .margin({top: '37%', left: '-3%'})
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        Row(){
          Text('今日步数：' + this.footsteps)
            .font({
              size: 25,
              weight: FontWeight.Medium
            })
            .opacity(1)
        }
        .height('70')
        .width('100%')
        .position({y: '29%'})
        .backgroundColor(Color.White)
        .opacity(0.85)
        .justifyContent(FlexAlign.Center)
        Row(){
          Text('我已经保持健康生活 ' + this.checkInDates + ' 天啦')
            .font({
              size: 25,
              weight: FontWeight.Medium
            })
            .opacity(1)
        }
        .height('70')
        .width('100%')
        .position({y: '20%'})
        .backgroundColor(Color.White)
        .opacity(0.85)
        .justifyContent(FlexAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .position({y: -56})
    .border({
      width: {bottom: 1},
      color: Color.Green,
      style: BorderStyle.Dashed
    })
  }

  build() {
    Column() {
      Column() {
        Column() {
          // 二楼页面
          this.SecondFloorBuilder();
          // 三点动效布局
          if (this.onShow) {
            Row() {
              // this.floorHeight - Math.abs(this.offsetY)为下拉距离，下拉距离超过MINI_SHOW_DISTANCE（动效最小展示距离）且小于TRIGGER_HEIGHT（触发动画高度或者动效消失高度）展示动画
              if ((this.floorHeight - Math.abs(this.offsetY)) > MINI_SHOW_DISTANCE &&
                (this.floorHeight - Math.abs(this.offsetY)) <= TRIGGER_HEIGHT) {
                Row() {
                  // 向左偏移圆
                  Blank()
                    .width(this.roundSize)
                    .height(this.roundSize)
                    .borderRadius($r('app.float.default_5'))
                    .scale(this.immediatelyScale)
                    .backgroundColor(Color.Black)
                    .translate({ x: this.animationXLeft })
                    .opacity(((this.floorHeight - Math.abs(this.offsetY)) / this.floorHeight)) // 使用下拉距离除以二楼高度获得圆的透明度
                  // 中心加载点
                  Blank()
                    .width(this.roundSize)
                    .height(this.roundSize)
                    .borderRadius($r('app.float.default_5'))
                    .margin({
                      left: $r('app.float.default_20'),
                      right: $r('app.float.default_20')
                    })
                    .backgroundColor(Color.Black)
                    .opacity(((this.floorHeight - Math.abs(this.offsetY)) / this.floorHeight))
                  // 向右偏移圆
                  Blank()
                    .width(this.roundSize)
                    .height(this.roundSize)
                    .borderRadius($r('app.float.default_5'))
                    .scale(this.immediatelyScale)
                    .backgroundColor(Color.Black)
                    .translate({ x: this.animationXRight })
                    .opacity(((this.floorHeight - Math.abs(this.offsetY)) / this.floorHeight))
                }
              }
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .height(this.floorHeight - Math.abs(this.offsetY))
            .backgroundColor(Color.Gray)
            // 当动效高度超过200的时候，背景色透明度开始改变，Math.abs(this.offsetY)除以(this.floorHeight - TRIGGER_HEIGHT)获取到的是超过动效高度的百分比可以来显示透明度，由于透明度小于0.6后蒙层效果不明显，所以当值小于0.6时固定为0.6
            .opacity(Math.abs(this.offsetY) / (this.floorHeight - TRIGGER_HEIGHT) >= 0.6 ||
              Math.abs(this.offsetY) / (this.floorHeight - TRIGGER_HEIGHT) === 0 ?
              Math.abs(this.offsetY) / (this.floorHeight - TRIGGER_HEIGHT) : 0.6)
          }
        }

        // 一楼页面
        Column() {
          this.FloorBuilder();
        }
        .width('100%')
        .layoutWeight(1)
        .position({
          x: 0,
          y: this.offsetY + this.floorHeight
        })
      }
      .clip(true)
      .width('100%')
      .height('100%')
      .onTouch((event) => {
        switch (event.type) {
          case TouchType.Down:
          // onTouchDown
            this.lastY = event.touches[0].windowY;
            this.onShow = true;
            this.dragging = false;
            break;
          case TouchType.Up:
          case TouchType.Cancel:
            if (this.dragging && !this.displaySecondFloor) {
              // 二楼自身的高度减去向下Y轴的位移的绝对值大于触发值进入二楼，否则回弹
              if ((this.floorHeight - Math.abs(this.offsetY)) > this.expandFloorTriggerDistance) {
                // 进入二楼
                this.expandSecondFloor();
              } else {
                // 未达到触发距离回弹
                this.scrollByTop();
              }
            }
            else if(this.dragging && this.displaySecondFloor) {
              if(Math.abs(this.offsetY) >= this.packUpFloorTriggerDistance) {
                // 收回二楼
                this.packUpSecondFloor();
              } else {
                // 回弹
                this.expandSecondFloor();
              }
            }
            break;
          case TouchType.Move:
            // onTouchMove
            this.onShow = true;
            let currentY = event.touches[0].windowY;
            let deltaY = currentY - this.lastY;
            if (this.dragging) {
              if (((this.floorHeight - Math.abs(this.offsetY)) <= TRIGGER_HEIGHT) && (this.floorHeight - Math.abs(this.offsetY)) >= 60) {
                this.roundSize = 20;
                this.animationXLeft = 60;
                this.animationXRight = -60;
                this.animationXLeft = this.animationXLeft - ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT) * 60;
                this.animationXRight = this.animationXRight + ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT) * 60;
                this.immediatelyScale = {
                  x: ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT),
                  y: ((this.floorHeight - Math.abs(this.offsetY)) / TRIGGER_HEIGHT)
                };
              } else if ((this.floorHeight - Math.abs(this.offsetY)) < 40) {
                this.roundSize = 0;
                this.roundSize = 20 * ((this.floorHeight - Math.abs(this.offsetY)) / 60);
                this.immediatelyScale = {
                  x: 0,
                  y: 0
                };
              } else {
                // 设置当二楼回收显示一楼时，三个圆属于加载成功状态
                this.roundSize = 0;
                this.immediatelyScale = { x: 1, y: 1 };
                this.animationXLeft = 0;
                this.animationXRight = 0;
              }

              // 在Y轴为达到0的之前使用1 - (Math.abs(this.offsetY) / this.floorHeight)来控制二楼页面缩放
              this.miniAppScale = {
                x: 1 - (Math.abs(this.offsetY) / this.floorHeight),
                y: 1 - (Math.abs(this.offsetY) / this.floorHeight)
              };

              // 拖动过程中向上拖动
              if (deltaY < 0) {
                if (this.offsetY > -this.floorHeight) {
                  // 往回拖动一楼漏出高度
                  this.offsetY = this.offsetY + px2vp(deltaY) * FLING_FACTOR;
                } else {
                  this.offsetY = -this.floorHeight;
                }
              } else if (this.offsetY < 0){
                // 向下拖动二楼漏出高度
                this.offsetY = this.offsetY + px2vp(deltaY) * FLING_FACTOR;
              }
              this.lastY = currentY;
            } else {
                this.dragging = true;
                this.lastY = currentY;
            }
            break;
        }
        event.stopPropagation(); // 阻止冒泡
      })
    }
  }
}

export { Index };