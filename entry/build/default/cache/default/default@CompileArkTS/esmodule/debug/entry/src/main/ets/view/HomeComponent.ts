if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HomeIndex_Params {
    broadCast?: BroadCast;
    naviAlpha?: number;
    homeStore?: HomeStore;
    editedTaskInfo?: ITaskItem;
    editedTaskID?: string;
    scroller?: Scroller;
    yOffset?: number;
}
import router from "@ohos:router";
import HealthText from "@bundle:com.example.healthy_life/entry/ets/view/HealthTextComponent";
import AddBtn from "@bundle:com.example.healthy_life/entry/ets/view/home/AddBtnComponent";
import { TaskCard } from "@bundle:com.example.healthy_life/entry/ets/view/home/TaskCardComponent";
import HomeTopView from "@bundle:com.example.healthy_life/entry/ets/view/home/HomeTopComponent";
import { CustomDialogView } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/CustomDialogView";
import type { CustomDialogCallback } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/CustomDialogView";
import type TaskInfo from '../viewmodel/TaskInfo';
import type { HomeStore } from '../viewmodel/HomeViewModel';
import { TaskMapById } from "@bundle:com.example.healthy_life/entry/ets/model/TaskInitList";
import type { ITaskItem } from "@bundle:com.example.healthy_life/entry/ets/model/TaskInitList";
import { HealthDataSrcMgr } from "@bundle:com.example.healthy_life/entry/ets/common/utils/HealthDataSrcMgr";
import { BroadCastType } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import type { BroadCast } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import type AchievementInfo from '../viewmodel/AchievementInfo';
const WHITE_COLOR_0X = 255;
function __Text__titleTextStyle(): void {
    Text.fontSize({ "id": 16777307, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
    Text.fontWeight(Const.FONT_WEIGHT_500);
    Text.width(Const.THOUSANDTH_1000);
    Text.fontFamily({ "id": 16777224, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
    Text.fontColor({ "id": -1, "type": -1, params: [`app.element.color.titleColor`], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
    Text.padding({
        top: Const.THOUSANDTH_15,
        bottom: Const.THOUSANDTH_15,
        left: Const.THOUSANDTH_33
    });
}
export default class HomeIndex extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__broadCast = new ObservedPropertyObjectPU(HealthDataSrcMgr.getInstance().getBroadCast(), this, "broadCast");
        this.addProvidedVar("broadCast", this.__broadCast, false);
        this.__naviAlpha = new ObservedPropertySimplePU(0, this, "naviAlpha");
        this.__homeStore = new SynchedPropertyObjectTwoWayPU(params.homeStore, this, "homeStore");
        this.__editedTaskInfo = new SynchedPropertyObjectTwoWayPU(params.editedTaskInfo, this, "editedTaskInfo");
        this.__editedTaskID = new SynchedPropertySimpleTwoWayPU(params.editedTaskID, this, "editedTaskID");
        this.scroller = new Scroller();
        this.yOffset = 0;
        this.setInitiallyProvidedValue(params);
        this.declareWatch("editedTaskID", this.taskChange);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HomeIndex_Params) {
        if (params.broadCast !== undefined) {
            this.broadCast = params.broadCast;
        }
        if (params.naviAlpha !== undefined) {
            this.naviAlpha = params.naviAlpha;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.yOffset !== undefined) {
            this.yOffset = params.yOffset;
        }
    }
    updateStateVars(params: HomeIndex_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__broadCast.purgeDependencyOnElmtId(rmElmtId);
        this.__naviAlpha.purgeDependencyOnElmtId(rmElmtId);
        this.__homeStore.purgeDependencyOnElmtId(rmElmtId);
        this.__editedTaskInfo.purgeDependencyOnElmtId(rmElmtId);
        this.__editedTaskID.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__broadCast.aboutToBeDeleted();
        this.__naviAlpha.aboutToBeDeleted();
        this.__homeStore.aboutToBeDeleted();
        this.__editedTaskInfo.aboutToBeDeleted();
        this.__editedTaskID.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __broadCast: ObservedPropertyObjectPU<BroadCast>;
    get broadCast() {
        return this.__broadCast.get();
    }
    set broadCast(newValue: BroadCast) {
        this.__broadCast.set(newValue);
    }
    private __naviAlpha: ObservedPropertySimplePU<number>;
    get naviAlpha() {
        return this.__naviAlpha.get();
    }
    set naviAlpha(newValue: number) {
        this.__naviAlpha.set(newValue);
    }
    private __homeStore: SynchedPropertySimpleOneWayPU<HomeStore>;
    get homeStore() {
        return this.__homeStore.get();
    }
    set homeStore(newValue: HomeStore) {
        this.__homeStore.set(newValue);
    }
    private __editedTaskInfo: SynchedPropertySimpleOneWayPU<ITaskItem>;
    get editedTaskInfo() {
        return this.__editedTaskInfo.get();
    }
    set editedTaskInfo(newValue: ITaskItem) {
        this.__editedTaskInfo.set(newValue);
    }
    private __editedTaskID: SynchedPropertySimpleTwoWayPU<string>;
    get editedTaskID() {
        return this.__editedTaskID.get();
    }
    set editedTaskID(newValue: string) {
        this.__editedTaskID.set(newValue);
    }
    private scroller: Scroller;
    private yOffset: number;
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
                    this.onConfirm(taskTemp);
                }, cancelCallback: () => {
                }
            };
            this.broadCast.emit(BroadCastType.SHOW_TASK_DETAIL_DIALOG, [item, callback]);
        }
        else {
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
        this.homeStore.taskClock(task).then((res: AchievementInfo) => {
            if (res.showAchievement) {
                let achievementLevel = res.achievementLevel;
                if (achievementLevel) {
                    this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, achievementLevel);
                }
                else {
                    this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG);
                }
            }
        });
    }
    // change navigator alpha when scrolling the Scroll component
    onScrollAction() {
        this.yOffset = this.scroller.currentOffset().yOffset;
        if (this.yOffset > Const.DEFAULT_56) {
            this.naviAlpha = 1;
        }
        else {
            this.naviAlpha = this.yOffset / Const.DEFAULT_56;
        }
    }
    editTaskAction() {
        if (this.homeStore.checkCurrentDay()) {
            router.pushUrl({ url: 'pages/TaskListPage' });
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width(Const.THOUSANDTH_1000);
            Stack.height(Const.THOUSANDTH_1000);
            Stack.backgroundColor({ "id": 16777281, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.scrollBar(BarState.Off);
            Scroll.width(Const.THOUSANDTH_1000);
            Scroll.height(Const.THOUSANDTH_1000);
            Scroll.onScroll(() => {
                this.onScrollAction();
            });
            Scroll.align(Alignment.TopStart);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new HomeTopView(this, { homeStore: this.__homeStore }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/HomeComponent.ets", line: 126 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            homeStore: this.homeStore
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "HomeTopView" });
        }
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777261, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            __Text__titleTextStyle();
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.homeStore.getTaskListOfDay().length > 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create({ space: Const.DEFAULT_8 });
                        Column.onAppear(() => {
                            this.scroller.scrollTo({ xOffset: 0, yOffset: this.yOffset });
                        });
                        Column.padding({
                            top: Const.THOUSANDTH_15,
                            left: Const.THOUSANDTH_33,
                            right: Const.THOUSANDTH_33
                        });
                        Column.width(Const.THOUSANDTH_1000);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = _item => {
                            const item = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                __Common__.create();
                                __Common__.margin({ bottom: Const.DEFAULT_12 });
                                __Common__.height({ "id": 16777327, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                            }, __Common__);
                            {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    if (isInitialRender) {
                                        let componentCall = new TaskCard(this, {
                                            taskInfoStr: JSON.stringify(item),
                                            clickAction: (isClick: boolean) => this.taskItemAction(item, isClick)
                                        }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/HomeComponent.ets", line: 131 });
                                        ViewPU.create(componentCall);
                                        let paramsLambda = () => {
                                            return {
                                                taskInfoStr: JSON.stringify(item),
                                                clickAction: (isClick: boolean) => this.taskItemAction(item, isClick)
                                            };
                                        };
                                        componentCall.paramsGenerator_ = paramsLambda;
                                    }
                                    else {
                                        this.updateStateVarsOfChildByElmtId(elmtId, {
                                            taskInfoStr: JSON.stringify(item)
                                        });
                                    }
                                }, { name: "TaskCard" });
                            }
                            __Common__.pop();
                        };
                        this.forEachUpdateFunction(elmtId, this.homeStore.getTaskListOfDay(), forEachItemGenFunction, (item: TaskInfo) => JSON.stringify(item), false, false);
                    }, ForEach);
                    ForEach.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create({ space: Const.DEFAULT_8 });
                        Column.margin({ top: Const.DEFAULT_48 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 16777379, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Image.width({ "id": 16777305, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Image.height({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                    }, Image);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        __Common__.create();
                        __Common__.opacity(Const.OPACITY_4);
                    }, __Common__);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new HealthText(this, { title: '', titleResource: { "id": 16777245, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }, fontSize: { "id": 16777306, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/HomeComponent.ets", line: 153 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        title: '',
                                        titleResource: { "id": 16777245, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
                                        fontSize: { "id": 16777306, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                    title: ''
                                });
                            }
                        }, { name: "HealthText" });
                    }
                    __Common__.pop();
                    Column.pop();
                });
            }
        }, If);
        If.pop();
        Column.pop();
        Scroll.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new AddBtn(this, {
                        clickAction: () => {
                            this.editTaskAction();
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/HomeComponent.ets", line: 167 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            clickAction: () => {
                                this.editTaskAction();
                            }
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "AddBtn" });
        }
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width(Const.THOUSANDTH_1000);
            Row.height(Const.DEFAULT_56);
            Row.position({ x: 0, y: 0 });
            Row.backgroundColor(`rgba(${WHITE_COLOR_0X},${WHITE_COLOR_0X},${WHITE_COLOR_0X},${this.naviAlpha})`);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777219, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            __Text__titleTextStyle();
            Text.fontSize({ "id": 16777312, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.padding({ left: Const.THOUSANDTH_66 });
        }, Text);
        Text.pop();
        Row.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new CustomDialogView(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/HomeComponent.ets", line: 183 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "CustomDialogView" });
        }
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
