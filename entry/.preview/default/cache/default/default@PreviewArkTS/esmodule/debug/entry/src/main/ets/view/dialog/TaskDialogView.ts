if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TaskDialogView_Params {
    isShow?: boolean;
    broadCast?: BroadCast;
    // target setting dialog
    targetSettingDialog?: CustomDialogController;
    // remind time dialog
    RemindTimeDialogController?: CustomDialogController;
    // frequency dialog
    FrequencyDialogController?: CustomDialogController;
}
import { TargetSettingDialog, RemindTimeDialog, FrequencyDialog } from "@bundle:com.example.healthy_life/entry/ets/view/dialog/TaskSettingDialog";
import { BroadCastType } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import type { BroadCast } from "@bundle:com.example.healthy_life/entry/ets/common/utils/BroadCast";
import Logger from "@bundle:com.example.healthy_life/entry/ets/common/utils/Logger";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export interface CustomDialogCallback {
    confirmCallback: Function;
    cancelCallback: Function;
}
export class TaskDialogView extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__isShow = new ObservedPropertySimplePU(false, this, "isShow");
        this.__broadCast = this.initializeConsume("broadCast", "broadCast");
        this.targetSettingDialog = new CustomDialogController({
            builder: () => {
                let jsDialog = new TargetSettingDialog(this, {}, undefined, -1, () => { }, { page: "entry/src/main/ets/view/dialog/TaskDialogView.ets", line: 32 });
                jsDialog.setController(this.
                // target setting dialog
                targetSettingDialog);
                ViewPU.create(jsDialog);
                let paramsLambda = () => {
                    return {};
                };
                jsDialog.paramsGenerator_ = paramsLambda;
            },
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
        }, this);
        this.RemindTimeDialogController = new CustomDialogController({
            builder: () => {
                let jsDialog = new RemindTimeDialog(this, {}, undefined, -1, () => { }, { page: "entry/src/main/ets/view/dialog/TaskDialogView.ets", line: 39 });
                jsDialog.setController(this.
                // remind time dialog
                RemindTimeDialogController);
                ViewPU.create(jsDialog);
                let paramsLambda = () => {
                    return {};
                };
                jsDialog.paramsGenerator_ = paramsLambda;
            },
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
        }, this);
        this.FrequencyDialogController = new CustomDialogController({
            builder: () => {
                let jsDialog = new FrequencyDialog(this, {}, undefined, -1, () => { }, { page: "entry/src/main/ets/view/dialog/TaskDialogView.ets", line: 46 });
                jsDialog.setController(this.
                // frequency dialog
                FrequencyDialogController);
                ViewPU.create(jsDialog);
                let paramsLambda = () => {
                    return {};
                };
                jsDialog.paramsGenerator_ = paramsLambda;
            },
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
        }, this);
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TaskDialogView_Params) {
        if (params.isShow !== undefined) {
            this.isShow = params.isShow;
        }
        if (params.targetSettingDialog !== undefined) {
            this.targetSettingDialog = params.targetSettingDialog;
        }
        if (params.RemindTimeDialogController !== undefined) {
            this.RemindTimeDialogController = params.RemindTimeDialogController;
        }
        if (params.FrequencyDialogController !== undefined) {
            this.FrequencyDialogController = params.FrequencyDialogController;
        }
    }
    updateStateVars(params: TaskDialogView_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__isShow.purgeDependencyOnElmtId(rmElmtId);
        this.__broadCast.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__isShow.aboutToBeDeleted();
        this.__broadCast.aboutToBeDeleted();
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
    private __broadCast: ObservedPropertyAbstractPU<BroadCast>;
    get broadCast() {
        return this.__broadCast.get();
    }
    set broadCast(newValue: BroadCast) {
        this.__broadCast.set(newValue);
    }
    // target setting dialog
    private targetSettingDialog: CustomDialogController;
    // remind time dialog
    private RemindTimeDialogController: CustomDialogController;
    // frequency dialog
    private FrequencyDialogController: CustomDialogController;
    aboutToAppear() {
        Logger.debug('CustomDialogView', 'aboutToAppear');
        // target setting dialog
        this.broadCast.on(BroadCastType.SHOW_TARGET_SETTING_DIALOG, () => {
            this.targetSettingDialog.open();
        });
        // remind time dialog
        this.broadCast.on(BroadCastType.SHOW_REMIND_TIME_DIALOG, () => {
            this.RemindTimeDialogController.open();
        });
        // frequency dialog
        this.broadCast.on(BroadCastType.SHOW_FREQUENCY_DIALOG, () => {
            this.FrequencyDialogController.open();
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
