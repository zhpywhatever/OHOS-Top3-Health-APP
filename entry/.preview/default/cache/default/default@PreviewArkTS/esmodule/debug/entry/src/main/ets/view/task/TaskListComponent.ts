if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TaskList_Params {
    taskList?: ITaskItem[];
}
import router from "@ohos:router";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
import { formatParams } from "@bundle:com.example.healthy_life/entry/ets/viewmodel/TaskViewModel";
import type { ITaskItem } from '../../model/TaskInitList';
export default class TaskList extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__taskList = this.initializeConsume("taskList", "taskList");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TaskList_Params) {
    }
    updateStateVars(params: TaskList_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__taskList.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__taskList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __taskList: ObservedPropertyAbstractPU<ITaskItem[]>;
    get taskList() {
        return this.__taskList.get();
    }
    set taskList(newValue: ITaskItem[]) {
        this.__taskList.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: Const.LIST_ITEM_SPACE });
            List.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(26:5)");
            List.height(Const.THOUSANDTH_1000);
            List.width(Const.THOUSANDTH_940);
        }, List);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
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
                        ListItem.height(Const.THOUSANDTH_80);
                        ListItem.borderRadius(Const.DEFAULT_12);
                        ListItem.onClick(() => {
                            router.pushUrl({
                                url: 'pages/TaskEditPage',
                                params: {
                                    params: formatParams(item)
                                }
                            });
                        });
                        ListItem.backgroundColor({ "id": 16777386, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        ListItem.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(28:9)");
                    };
                    const deepRenderFunction = (elmtId, isInitialRender) => {
                        itemCreation(elmtId, isInitialRender);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Row.create();
                            Row.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(29:11)");
                            Row.width(Const.THOUSANDTH_1000);
                            Row.justifyContent(FlexAlign.SpaceBetween);
                            Row.padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 });
                        }, Row);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Row.create();
                            Row.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(30:13)");
                            Row.width(Const.THOUSANDTH_500);
                        }, Row);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Image.create(item?.icon);
                            Image.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(31:15)");
                            Image.width(Const.DEFAULT_24);
                            Image.height(Const.DEFAULT_24);
                            Image.margin({ right: Const.DEFAULT_8 });
                        }, Image);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create(item?.taskName);
                            Text.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(35:15)");
                            Text.fontSize(Const.DEFAULT_20);
                            Text.fontColor({ "id": 16777385, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        }, Text);
                        Text.pop();
                        Row.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Blank.create();
                            Blank.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(41:13)");
                            Blank.layoutWeight(1);
                        }, Blank);
                        Blank.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            If.create();
                            if (item?.isOpen) {
                                this.ifElseBranchUpdateFunction(0, () => {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Text.create({ "id": 16777233, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                                        Text.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(44:15)");
                                        Text.fontSize(Const.DEFAULT_16);
                                        Text.flexGrow(1);
                                        Text.align(Alignment.End);
                                        Text.margin({ right: Const.DEFAULT_8 });
                                        Text.fontColor({ "id": 16777385, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                                    }, Text);
                                    Text.pop();
                                });
                            }
                            else {
                                this.ifElseBranchUpdateFunction(1, () => {
                                });
                            }
                        }, If);
                        If.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Image.create({ "id": 16777362, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                            Image.debugLine("entry/src/main/ets/view/task/TaskListComponent.ets(51:13)");
                            Image.width(Const.DEFAULT_8);
                            Image.height(Const.DEFAULT_16);
                        }, Image);
                        Row.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.taskList, forEachItemGenFunction, (item: ITaskItem) => JSON.stringify(item), false, false);
        }, ForEach);
        ForEach.pop();
        List.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
