if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AgencyCard_Params {
    taskList?: AgencyCardInfo[];
    showWidget?: boolean;
    iconList?;
    ACTION_TYPE?: string;
    ABILITY_NAME?: string;
    FULL_WIDTH_PERCENT?: string;
    FULL_HEIGHT_PERCENT?: string;
    EMPTY_IMAGE_WIDTH?: string;
    AGENCY_COMPONENT_HEIGHT?: string;
    EMPTY_IMAGE_HEIGHT?: string;
    TEXT_MARGIN_TOP?: string;
    CROSS_BAR_SYMBOL?: string;
    SLASHES?: string;
    TARGET_VALUE_SPLICING?: string;
    LIST_SPACE?: number;
    LIST_TWO_LANES?: number;
    TEXT_OPACITY?: number;
    TARGET_TEXT_OPACITY?: number;
    TARGET_TEXT_WEIGHT?: number;
    TEXT_SLIGHTLY_BOLD?: number;
}
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
let agencyStorage = new LocalStorage();
class AgencyCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.iconList = {
            getup: { "id": 16777390, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
            drink: { "id": 16777393, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
            apple: { "id": 16777388, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
            smile: { "id": 16777392, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
            clean: { "id": 16777389, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
            sleep: { "id": 16777391, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
        } as iconInfo;
        this.ACTION_TYPE = 'router';
        this.ABILITY_NAME = 'EntryAbility';
        this.FULL_WIDTH_PERCENT = '100%';
        this.FULL_HEIGHT_PERCENT = '100%';
        this.EMPTY_IMAGE_WIDTH = '31%';
        this.AGENCY_COMPONENT_HEIGHT = '31%';
        this.EMPTY_IMAGE_HEIGHT = '51%';
        this.TEXT_MARGIN_TOP = '0.5%';
        this.CROSS_BAR_SYMBOL = '--';
        this.SLASHES = '/';
        this.TARGET_VALUE_SPLICING = this.CROSS_BAR_SYMBOL + this.SLASHES;
        this.LIST_SPACE = 5;
        this.LIST_TWO_LANES = 2;
        this.TEXT_OPACITY = 0.4;
        this.TARGET_TEXT_OPACITY = 0.6;
        this.TARGET_TEXT_WEIGHT = 1;
        this.TEXT_SLIGHTLY_BOLD = 500;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AgencyCard_Params) {
        if (params.iconList !== undefined) {
            this.iconList = params.iconList;
        }
        if (params.ACTION_TYPE !== undefined) {
            this.ACTION_TYPE = params.ACTION_TYPE;
        }
        if (params.ABILITY_NAME !== undefined) {
            this.ABILITY_NAME = params.ABILITY_NAME;
        }
        if (params.FULL_WIDTH_PERCENT !== undefined) {
            this.FULL_WIDTH_PERCENT = params.FULL_WIDTH_PERCENT;
        }
        if (params.FULL_HEIGHT_PERCENT !== undefined) {
            this.FULL_HEIGHT_PERCENT = params.FULL_HEIGHT_PERCENT;
        }
        if (params.EMPTY_IMAGE_WIDTH !== undefined) {
            this.EMPTY_IMAGE_WIDTH = params.EMPTY_IMAGE_WIDTH;
        }
        if (params.AGENCY_COMPONENT_HEIGHT !== undefined) {
            this.AGENCY_COMPONENT_HEIGHT = params.AGENCY_COMPONENT_HEIGHT;
        }
        if (params.EMPTY_IMAGE_HEIGHT !== undefined) {
            this.EMPTY_IMAGE_HEIGHT = params.EMPTY_IMAGE_HEIGHT;
        }
        if (params.TEXT_MARGIN_TOP !== undefined) {
            this.TEXT_MARGIN_TOP = params.TEXT_MARGIN_TOP;
        }
        if (params.CROSS_BAR_SYMBOL !== undefined) {
            this.CROSS_BAR_SYMBOL = params.CROSS_BAR_SYMBOL;
        }
        if (params.SLASHES !== undefined) {
            this.SLASHES = params.SLASHES;
        }
        if (params.TARGET_VALUE_SPLICING !== undefined) {
            this.TARGET_VALUE_SPLICING = params.TARGET_VALUE_SPLICING;
        }
        if (params.LIST_SPACE !== undefined) {
            this.LIST_SPACE = params.LIST_SPACE;
        }
        if (params.LIST_TWO_LANES !== undefined) {
            this.LIST_TWO_LANES = params.LIST_TWO_LANES;
        }
        if (params.TEXT_OPACITY !== undefined) {
            this.TEXT_OPACITY = params.TEXT_OPACITY;
        }
        if (params.TARGET_TEXT_OPACITY !== undefined) {
            this.TARGET_TEXT_OPACITY = params.TARGET_TEXT_OPACITY;
        }
        if (params.TARGET_TEXT_WEIGHT !== undefined) {
            this.TARGET_TEXT_WEIGHT = params.TARGET_TEXT_WEIGHT;
        }
        if (params.TEXT_SLIGHTLY_BOLD !== undefined) {
            this.TEXT_SLIGHTLY_BOLD = params.TEXT_SLIGHTLY_BOLD;
        }
    }
    updateStateVars(params: AgencyCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__taskList.purgeDependencyOnElmtId(rmElmtId);
        this.__showWidget.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__taskList.aboutToBeDeleted();
        this.__showWidget.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __taskList: ObservedPropertyAbstractPU<AgencyCardInfo[]> = this.createLocalStorageProp<AgencyCardInfo[]>('taskList', [], "taskList");
    get taskList() {
        return this.__taskList.get();
    }
    set taskList(newValue: AgencyCardInfo[]) {
        this.__taskList.set(newValue);
    }
    private __showWidget: ObservedPropertyAbstractPU<boolean> = this.createLocalStorageProp<boolean>('showWidget', false, "showWidget");
    get showWidget() {
        return this.__showWidget.get();
    }
    set showWidget(newValue: boolean) {
        this.__showWidget.set(newValue);
    }
    private iconList;
    /*
     * The action type.
     */
    readonly ACTION_TYPE: string;
    /*
     * The ability name.
     */
    readonly ABILITY_NAME: string;
    /*
     * The with percentage setting.
     */
    readonly FULL_WIDTH_PERCENT: string;
    /*
     * The height percentage setting.
     */
    readonly FULL_HEIGHT_PERCENT: string;
    /*
     * The empty image width percentage setting.
     */
    readonly EMPTY_IMAGE_WIDTH: string;
    /*
     * The agency component height percentage setting.
     */
    readonly AGENCY_COMPONENT_HEIGHT: string;
    /*
     * The empty image height percentage setting.
     */
    readonly EMPTY_IMAGE_HEIGHT: string;
    /*
     * The empty data text component margin top.
     */
    readonly TEXT_MARGIN_TOP: string;
    /*
     * The cross bar symbol stitching
     */
    readonly CROSS_BAR_SYMBOL: string;
    /*
     * The slashes splicing.
     */
    readonly SLASHES: string;
    /*
     * The target value splicing
     */
    readonly TARGET_VALUE_SPLICING: string;
    /**
     * The list component space.
     */
    readonly LIST_SPACE: number;
    /**
     * The list component two lanes.
     */
    readonly LIST_TWO_LANES: number;
    /**
     * The empty data text opacity.
     */
    readonly TEXT_OPACITY: number;
    /**
     * The target text opacity.
     */
    readonly TARGET_TEXT_OPACITY: number;
    /**
     * The target text weight.
     */
    readonly TARGET_TEXT_WEIGHT: number;
    /**
     * The text slightly bold.
     */
    readonly TEXT_SLIGHTLY_BOLD: number;
    getIconByCardTaskType(key?: string): Resource {
        let result: Resource = { "id": 16777237, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        switch (key) {
            case 'getup':
                result = { "id": 16777390, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            case 'drink':
                result = { "id": 16777393, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            case 'apple':
                result = { "id": 16777388, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            case 'smile':
                result = { "id": 16777392, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            case 'clean':
                result = { "id": 16777389, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            case 'sleep':
                result = { "id": 16777391, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
                break;
            default:
                break;
        }
        return result;
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.showWidget) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        List.create({ space: this.LIST_SPACE });
                        List.padding({
                            left: { "id": 16777295, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
                            top: { "id": 16777297, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
                            right: { "id": 16777296, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
                            bottom: { "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
                        });
                        List.lanes(this.LIST_TWO_LANES);
                        List.backgroundColor({ "id": 16777277, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        List.width(this.FULL_WIDTH_PERCENT);
                        List.height(this.FULL_HEIGHT_PERCENT);
                    }, List);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = _item => {
                            const taskItem = _item;
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
                                    ListItem.margin({ right: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
                                    ListItem.borderRadius({ "id": 16777293, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                                    ListItem.backgroundColor(Color.White);
                                };
                                const deepRenderFunction = (elmtId, isInitialRender) => {
                                    itemCreation(elmtId, isInitialRender);
                                    this.AgencyComponent.bind(this)(taskItem, this);
                                    ListItem.pop();
                                };
                                this.observeComponentCreation2(itemCreation2, ListItem);
                                ListItem.pop();
                            }
                        };
                        this.forEachUpdateFunction(elmtId, this.taskList, forEachItemGenFunction, (taskItem: AgencyCardInfo) => JSON.stringify(taskItem), false, false);
                    }, ForEach);
                    ForEach.pop();
                    List.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.AgencyNoData.bind(this)(this);
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    AgencyNoData(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.justifyContent(FlexAlign.Center);
            Column.width(this.FULL_WIDTH_PERCENT);
            Column.height(this.FULL_HEIGHT_PERCENT);
            Column.backgroundColor({ "id": 16777279, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.onClick(() => {
                this.jumpToAbility();
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777379, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.width(this.EMPTY_IMAGE_WIDTH);
            Image.height(this.EMPTY_IMAGE_HEIGHT);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777228, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777336, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor(Color.White);
            Text.fontWeight(FontWeight.Normal);
            Text.opacity(this.TEXT_OPACITY);
            Text.margin({ top: this.TEXT_MARGIN_TOP });
        }, Text);
        Text.pop();
        Column.pop();
    }
    AgencyComponent(taskItem: AgencyCardInfo, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.padding({
                left: { "id": 16777298, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" },
                right: { "id": 16777298, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }
            });
            Row.width(this.FULL_WIDTH_PERCENT);
            Row.height(this.AGENCY_COMPONENT_HEIGHT);
            Row.onClick(() => {
                this.jumpToAbility();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.getIconByCardTaskType(taskItem.taskType));
            Image.width({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.height({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (taskItem.dateType) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(taskItem.isDone ? taskItem.targetValue : this.TARGET_VALUE_SPLICING + taskItem.targetValue);
                        Text.fontSize({ "id": 16777344, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Text.fontColor({ "id": 16777288, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Text.opacity(this.TARGET_TEXT_OPACITY);
                        Text.fontWeight(FontWeight.Normal);
                        Text.layoutWeight(this.TARGET_TEXT_WEIGHT);
                        Text.textAlign(TextAlign.End);
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.layoutWeight(this.TARGET_TEXT_WEIGHT);
                        Row.justifyContent(FlexAlign.End);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(taskItem.finValueIsNull ? this.CROSS_BAR_SYMBOL : taskItem.finValue);
                        Text.fontSize(taskItem.finValueIsNull ? { "id": 16777344, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } : { "id": 16777299, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Text.fontWeight(taskItem.finValueIsNull ? FontWeight.Normal : this.TEXT_SLIGHTLY_BOLD);
                        Text.fontColor(taskItem.finValueIsNull ? { "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } : { "id": 16777288, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.SLASHES + taskItem.targetValue);
                        Text.fontSize({ "id": 16777344, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Text.fontWeight(FontWeight.Normal);
                        Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(taskItem.unit);
                        Text.fontSize({ "id": 16777344, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                        Text.fontWeight(FontWeight.Normal);
                        Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
                    }, Text);
                    Text.pop();
                    Row.pop();
                });
            }
        }, If);
        If.pop();
        Row.pop();
    }
    jumpToAbility() {
        postCardAction(this, {
            'action': this.ACTION_TYPE,
            'abilityName': this.ABILITY_NAME
        });
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "AgencyCard";
    }
}
class AgencyCardInfo {
    taskType?: string;
    targetValue?: string;
    finValue?: string;
    unit?: string;
    dateType?: boolean;
    hasTargetValue?: boolean;
    finValueIsNull?: boolean;
    isDone?: boolean;
}
interface iconInfo {
    getup: Resource;
    drink: Resource;
    apple: Resource;
    smile: Resource;
    clean: Resource;
    sleep: Resource;
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadEtsCard(new AgencyCard(undefined, {}, agencyStorage), "com.example.healthy_life/entry/ets/agency/pages/AgencyCard");
ViewStackProcessor.StopGetAccessRecording();
