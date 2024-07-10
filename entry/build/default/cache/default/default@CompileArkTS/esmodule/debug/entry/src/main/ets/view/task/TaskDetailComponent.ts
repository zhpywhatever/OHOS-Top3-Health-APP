if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TaskDetail_Params {
    broadCast?: BroadCast;
    settingParams?: ITaskItem;
    frequency?: string;
    isChanged?: boolean;
}
import router from "@ohos:router";
import promptAction from "@ohos:promptAction";
import type common from "@ohos:app.ability.common";
import type { ITaskItem } from '../../model/TaskInitList';
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import TaskInfo, { taskType } from "@bundle:com.example.healthy_life/entry/ets/viewmodel/TaskInfo";
import { TaskChooseItem, TargetSetItem, OpenRemindItem, RemindTimeItem, FrequencyItem } from "@bundle:com.example.healthy_life/entry/ets/view/task/TaskEditListItem";
import { BroadCastType } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import type { BroadCast } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import { HealthDataSrcMgr } from "@bundle:com.example.healthy_life/entry/ets/common/utils/HealthDataSrcMgr";
import { initFrequencyString, addTask, formatParams } from "@bundle:com.example.healthy_life/entry/ets/viewmodel/TaskViewModel";
import { TaskDialogView } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/TaskDialogView";
import { GlobalContext } from "@bundle:com.example.healthy_life/entry/ets/common/utils/GlobalContext";
export default class TaskDetail extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__broadCast = new ObservedPropertyObjectPU(HealthDataSrcMgr.getInstance().getBroadCast(), this, "broadCast");
        this.addProvidedVar("broadCast", this.__broadCast, false);
        this.__settingParams = new ObservedPropertyObjectPU(this.parseRouterParams(), this, "settingParams");
        this.addProvidedVar("settingParams", this.__settingParams, false);
        this.__frequency = new ObservedPropertySimplePU(initFrequencyString(this.settingParams?.frequency), this, "frequency");
        this.addProvidedVar("frequency", this.__frequency, false);
        this.isChanged = false;
        this.setInitiallyProvidedValue(params);
        this.declareWatch("settingParams", this.onParamsChanged);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TaskDetail_Params) {
        if (params.broadCast !== undefined) {
            this.broadCast = params.broadCast;
        }
        if (params.settingParams !== undefined) {
            this.settingParams = params.settingParams;
        }
        if (params.frequency !== undefined) {
            this.frequency = params.frequency;
        }
        if (params.isChanged !== undefined) {
            this.isChanged = params.isChanged;
        }
    }
    updateStateVars(params: TaskDetail_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__broadCast.purgeDependencyOnElmtId(rmElmtId);
        this.__settingParams.purgeDependencyOnElmtId(rmElmtId);
        this.__frequency.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__broadCast.aboutToBeDeleted();
        this.__settingParams.aboutToBeDeleted();
        this.__frequency.aboutToBeDeleted();
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
    private __settingParams: ObservedPropertyObjectPU<ITaskItem>;
    get settingParams() {
        return this.__settingParams.get();
    }
    set settingParams(newValue: ITaskItem) {
        this.__settingParams.set(newValue);
    }
    private __frequency: ObservedPropertySimplePU<string>;
    get frequency() {
        return this.__frequency.get();
    }
    set frequency(newValue: string) {
        this.__frequency.set(newValue);
    }
    private isChanged: boolean;
    parseRouterParams() {
        let params = router.getParams() as Record<string, Object>;
        const routerParams: ITaskItem = JSON.parse(params.params as string);
        return routerParams;
    }
    onParamsChanged() {
        this.isChanged = true;
    }
    backIndexParams(): string {
        return formatParams(this.settingParams);
    }
    finishTaskEdit() {
        if (this.isChanged) {
            let context: Context = getContext(this) as common.Context;
            let taskInfo: TaskInfo = new TaskInfo(Const.ZERO, Const.GLOBAL_KEY, this.settingParams.taskID, this.settingParams.targetValue, this.settingParams.isAlarm, this.settingParams.startTime, this.settingParams.endTime, this.settingParams.frequency, false, '', this.settingParams.isOpen);
            addTask(taskInfo, context).then((res: number) => {
                GlobalContext.getContext().setObject('taskListChange', true);
                router.back({
                    url: 'pages/MainPage',
                    params: {
                        editTask: this.backIndexParams(),
                    }
                });
                Logger.info('addTaskFinished', JSON.stringify(res));
            }).catch((error: Error) => {
                promptAction.showToast({
                    message: Const.SETTING_FINISH_FAILED_MESSAGE
                });
                Logger.error('addTaskFailed', JSON.stringify(error));
            });
            return;
        }
        router.back({
            url: 'pages/MainPage',
        });
    }
    aboutToAppear() {
        this.broadCast.off(BroadCastType.SHOW_TARGET_SETTING_DIALOG, () => {
        });
        this.broadCast.off(BroadCastType.SHOW_REMIND_TIME_DIALOG, () => {
        });
        this.broadCast.off(BroadCastType.SHOW_FREQUENCY_DIALOG, () => {
        });
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width(Const.THOUSANDTH_1000);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: Const.LIST_ITEM_SPACE });
            List.width(Const.THOUSANDTH_940);
        }, List);
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                itemCreation2(elmtId, isInitialRender);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
                ListItem.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                ListItem.height(Const.DEFAULT_56);
                ListItem.borderRadius(Const.DEFAULT_10);
                ListItem.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new TaskChooseItem(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 108 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {};
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "TaskChooseItem" });
                }
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                itemCreation2(elmtId, isInitialRender);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
                ListItem.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                ListItem.height(Const.DEFAULT_56);
                ListItem.borderRadius(Const.DEFAULT_10);
                ListItem.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
                ListItem.enabled(this.settingParams?.isOpen
                    && this.settingParams?.taskID !== taskType.smile
                    && this.settingParams?.taskID !== taskType.brushTeeth);
                ListItem.onClick(() => {
                    this.broadCast.emit(BroadCastType.SHOW_TARGET_SETTING_DIALOG);
                });
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new TargetSetItem(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 113 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {};
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "TargetSetItem" });
                }
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                itemCreation2(elmtId, isInitialRender);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
                ListItem.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                ListItem.height(Const.DEFAULT_56);
                ListItem.borderRadius(Const.DEFAULT_10);
                ListItem.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
                ListItem.enabled(this.settingParams?.isOpen);
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new OpenRemindItem(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 127 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {};
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "OpenRemindItem" });
                }
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                itemCreation2(elmtId, isInitialRender);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
                ListItem.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                ListItem.height(Const.DEFAULT_56);
                ListItem.borderRadius(Const.DEFAULT_10);
                ListItem.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
                ListItem.enabled(this.settingParams?.isOpen && this.settingParams?.isAlarm);
                ListItem.onClick(() => {
                    this.broadCast.emit(BroadCastType.SHOW_REMIND_TIME_DIALOG);
                });
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new RemindTimeItem(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 133 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {};
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "RemindTimeItem" });
                }
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                itemCreation2(elmtId, isInitialRender);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
                ListItem.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                ListItem.height(Const.DEFAULT_56);
                ListItem.borderRadius(Const.DEFAULT_10);
                ListItem.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
                ListItem.enabled(this.settingParams?.isOpen && this.settingParams?.isAlarm);
                ListItem.onClick(() => {
                    this.broadCast.emit(BroadCastType.SHOW_FREQUENCY_DIALOG);
                });
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new FrequencyItem(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 142 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {};
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "FrequencyItem" });
                }
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        List.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.width(Const.THOUSANDTH_800);
            Button.height(Const.DEFAULT_48);
            Button.backgroundColor({ "id": 16777269, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Button.onClick(() => {
                this.finishTaskEdit();
            });
            Button.position({
                x: Const.THOUSANDTH_100,
                y: Const.THOUSANDTH_800
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777235, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777309, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor({ "id": 16777268, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        Text.pop();
        Button.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new TaskDialogView(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/task/TaskDetailComponent.ets", line: 167 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "TaskDialogView" });
        }
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
