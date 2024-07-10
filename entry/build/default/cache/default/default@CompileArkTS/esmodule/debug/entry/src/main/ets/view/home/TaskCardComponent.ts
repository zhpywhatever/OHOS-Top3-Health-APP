if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TaskCard_Params {
    taskInfoStr?: string;
    clickAction?: Function;
    taskInfo?: TaskInfo;
}
import { TaskMapById } from "@bundle:com.example.healthy_life/entry/ets/model/TaskInitList";
import HealthText from "@bundle:com.example.healthy_life/entry/ets/view/HealthTextComponent";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import TaskInfo from "@bundle:com.example.healthy_life/entry/ets/viewmodel/TaskInfo";
function __Text__labelTextStyle(): void {
    Text.fontSize({ "id": 16777307, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
    Text.fontWeight(Const.FONT_WEIGHT_500);
    Text.opacity(Const.OPACITY_6);
    Text.fontFamily({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
}
export class TaskCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__taskInfoStr = new SynchedPropertySimpleOneWayPU(params.taskInfoStr, this, "taskInfoStr");
        this.clickAction = (isClick: boolean) => {
        };
        this.__taskInfo = new ObservedPropertyObjectPU(new TaskInfo(-1, '', -1, '', false, '', '', '', false, '', false), this, "taskInfo");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TaskCard_Params) {
        if (params.taskInfoStr === undefined) {
            this.__taskInfoStr.set('');
        }
        if (params.clickAction !== undefined) {
            this.clickAction = params.clickAction;
        }
        if (params.taskInfo !== undefined) {
            this.taskInfo = params.taskInfo;
        }
    }
    updateStateVars(params: TaskCard_Params) {
        this.__taskInfoStr.reset(params.taskInfoStr);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__taskInfoStr.purgeDependencyOnElmtId(rmElmtId);
        this.__taskInfo.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__taskInfoStr.aboutToBeDeleted();
        this.__taskInfo.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __taskInfoStr: SynchedPropertySimpleOneWayPU<string>;
    get taskInfoStr() {
        return this.__taskInfoStr.get();
    }
    set taskInfoStr(newValue: string) {
        this.__taskInfoStr.set(newValue);
    }
    private clickAction: Function;
    private __taskInfo: ObservedPropertyObjectPU<TaskInfo>;
    get taskInfo() {
        return this.__taskInfo.get();
    }
    set taskInfo(newValue: TaskInfo) {
        this.__taskInfo.set(newValue);
    }
    aboutToAppear() {
        this.taskInfo = JSON.parse(this.taskInfoStr);
    }
    targetValueBuilder(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.taskInfo.isDone) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new HealthText(ViewPU.__proto__ !== NativeViewPartialUpdate && parent instanceof PUV2ViewBase ? parent : this, { title: '', titleResource: { "id": 16777260, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/home/TaskCardComponent.ets", line: 49 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        title: '',
                                        titleResource: { "id": 16777260, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
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
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                    }, Row);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new HealthText(ViewPU.__proto__ !== NativeViewPartialUpdate && parent instanceof PUV2ViewBase ? parent : this, {
                                    title: this.taskInfo.finValue || `--`,
                                    fontSize: { "id": 16777312, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/home/TaskCardComponent.ets", line: 52 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        title: this.taskInfo.finValue || `--`,
                                        fontSize: { "id": 16777312, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                    title: this.taskInfo.finValue || `--`
                                });
                            }
                        }, { name: "HealthText" });
                    }
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(` / ${this.taskInfo.targetValue} ${TaskMapById[this.taskInfo.taskID - 1].unit}`);
                        __Text__labelTextStyle();
                        Text.fontWeight(Const.FONT_WEIGHT_400);
                    }, Text);
                    Text.pop();
                    Row.pop();
                });
            }
        }, If);
        If.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width(Const.THOUSANDTH_1000);
            Row.height(Const.THOUSANDTH_1000);
            Row.justifyContent(FlexAlign.SpaceBetween);
            Row.borderRadius({ "id": 16777312, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Row.padding({ left: Const.THOUSANDTH_50, right: Const.THOUSANDTH_33 });
            Row.backgroundColor({ "id": 16777290, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Row.onClick(() => this.clickAction(true));
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create();
            LongPressGesture.onAction(() => this.clickAction(false));
            LongPressGesture.pop();
            Gesture.pop();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: Const.DEFAULT_6 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(TaskMapById[this.taskInfo.taskID - 1].icon);
            Image.width({ "id": 16777317, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.height({ "id": 16777317, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.objectFit(ImageFit.Contain);
        }, Image);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new HealthText(this, {
                        title: '',
                        titleResource: TaskMapById[this.taskInfo.taskID - 1].taskName,
                        fontFamily: { "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/home/TaskCardComponent.ets", line: 69 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            title: '',
                            titleResource: TaskMapById[this.taskInfo.taskID - 1].taskName,
                            fontFamily: { "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
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
        Row.pop();
        this.targetValueBuilder.bind(this)(this);
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
