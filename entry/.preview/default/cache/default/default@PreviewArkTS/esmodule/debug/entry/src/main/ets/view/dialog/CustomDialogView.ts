if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface CustomDialogView_Params {
    isShow?: boolean;
    achievementLevel?: number;
    broadCast?: BroadCast;
    currentTask?: TaskInfo;
    dialogCallBack?: CustomDialogCallback;
    // achievement dialog
    achievementDialog?: CustomDialogController;
    // task clock dialog
    taskDialog?: CustomDialogController;
}
import { AchievementDialog } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/AchievementDialog";
import { TaskDetailDialog } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/TaskDetailDialog";
import { BroadCastType } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import type { BroadCast } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import { TaskItem } from "@bundle:com.example.healthy_life/entry/ets/model/TaskInitList";
import type TaskInfo from '../../viewmodel/TaskInfo';
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
export class CustomDialogCallback {
    confirmCallback: Function = () => {
    };
    cancelCallback: Function = () => {
    };
}
export class CustomDialogView extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__isShow = new ObservedPropertySimplePU(false, this, "isShow");
        this.__achievementLevel = new ObservedPropertySimplePU(0, this, "achievementLevel");
        this.addProvidedVar("achievementLevel", this.__achievementLevel, false);
        this.__broadCast = this.initializeConsume("broadCast", "broadCast");
        this.__currentTask = new ObservedPropertyObjectPU(TaskItem, this, "currentTask");
        this.addProvidedVar("currentTask", this.__currentTask, false);
        this.__dialogCallBack = new ObservedPropertyObjectPU(new CustomDialogCallback(), this, "dialogCallBack");
        this.addProvidedVar("dialogCallBack", this.__dialogCallBack, false);
        this.achievementDialog = new CustomDialogController({
            builder: () => {
                let jsDialog = new AchievementDialog(this, {}, undefined, -1, () => { }, { page: "entry/src/main/ets/view/dialog/CustomDialogView.ets", line: 39 });
                jsDialog.setController(this.
                // achievement dialog
                achievementDialog);
                ViewPU.create(jsDialog);
                let paramsLambda = () => {
                    return {};
                };
                jsDialog.paramsGenerator_ = paramsLambda;
            },
            autoCancel: true,
            customStyle: true
        }, this);
        this.taskDialog = new CustomDialogController({
            builder: () => {
                let jsDialog = new TaskDetailDialog(this, {}, undefined, -1, () => { }, { page: "entry/src/main/ets/view/dialog/CustomDialogView.ets", line: 45 });
                jsDialog.setController(this.
                // task clock dialog
                taskDialog);
                ViewPU.create(jsDialog);
                let paramsLambda = () => {
                    return {};
                };
                jsDialog.paramsGenerator_ = paramsLambda;
            },
            autoCancel: true,
            customStyle: true
        }, this);
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: CustomDialogView_Params) {
        if (params.isShow !== undefined) {
            this.isShow = params.isShow;
        }
        if (params.achievementLevel !== undefined) {
            this.achievementLevel = params.achievementLevel;
        }
        if (params.currentTask !== undefined) {
            this.currentTask = params.currentTask;
        }
        if (params.dialogCallBack !== undefined) {
            this.dialogCallBack = params.dialogCallBack;
        }
        if (params.achievementDialog !== undefined) {
            this.achievementDialog = params.achievementDialog;
        }
        if (params.taskDialog !== undefined) {
            this.taskDialog = params.taskDialog;
        }
    }
    updateStateVars(params: CustomDialogView_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__isShow.purgeDependencyOnElmtId(rmElmtId);
        this.__achievementLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__broadCast.purgeDependencyOnElmtId(rmElmtId);
        this.__currentTask.purgeDependencyOnElmtId(rmElmtId);
        this.__dialogCallBack.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__isShow.aboutToBeDeleted();
        this.__achievementLevel.aboutToBeDeleted();
        this.__broadCast.aboutToBeDeleted();
        this.__currentTask.aboutToBeDeleted();
        this.__dialogCallBack.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __isShow: ObservedPropertySimplePU<boolean>;
    get isShow() {
        return this.__isShow.get();
    }
    set isShow(newValue: boolean) {
        this.__isShow.set(newValue);
    }
    private __achievementLevel: ObservedPropertySimplePU<number>;
    get achievementLevel() {
        return this.__achievementLevel.get();
    }
    set achievementLevel(newValue: number) {
        this.__achievementLevel.set(newValue);
    }
    private __broadCast: ObservedPropertyAbstractPU<BroadCast>;
    get broadCast() {
        return this.__broadCast.get();
    }
    set broadCast(newValue: BroadCast) {
        this.__broadCast.set(newValue);
    }
    private __currentTask: ObservedPropertyObjectPU<TaskInfo>;
    get currentTask() {
        return this.__currentTask.get();
    }
    set currentTask(newValue: TaskInfo) {
        this.__currentTask.set(newValue);
    }
    private __dialogCallBack: ObservedPropertyObjectPU<CustomDialogCallback>;
    get dialogCallBack() {
        return this.__dialogCallBack.get();
    }
    set dialogCallBack(newValue: CustomDialogCallback) {
        this.__dialogCallBack.set(newValue);
    }
    // achievement dialog
    private achievementDialog: CustomDialogController;
    // task clock dialog
    private taskDialog: CustomDialogController;
    aboutToAppear() {
        Logger.debug('CustomDialogView', 'aboutToAppear');
        // achievement dialog
        this.broadCast.on(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, (achievementLevel: number) => {
            Logger.debug('CustomDialogView', 'SHOW_ACHIEVEMENT_DIALOG');
            this.achievementLevel = achievementLevel;
            this.achievementDialog.open();
        });
        // task clock dialog
        this.broadCast.on(BroadCastType.SHOW_TASK_DETAIL_DIALOG, (currentTask: TaskInfo, dialogCallBack: CustomDialogCallback) => {
            Logger.debug('CustomDialogView', 'SHOW_TASK_DETAIL_DIALOG');
            this.currentTask = currentTask || TaskItem;
            this.dialogCallBack = dialogCallBack;
            this.taskDialog.open();
        });
    }
    aboutToDisappear() {
        Logger.debug('CustomDialogView', 'aboutToDisappear');
    }
    initialRender() {
    }
    rerender() {
        this.updateDirtyElements();
    }
}
