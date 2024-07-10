if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ProgressCard_Params {
    numerator?: number;
    denominator?: number;
    percent?: string;
    ACTION_TYPE?: string;
    ABILITY_NAME?: string;
    FULL_WIDTH_PERCENT?: string;
    FULL_HEIGHT_PERCENT?: string;
    PROGRESS_LAYOUT_HEIGHT?: string;
    RESULTS_LAYOUT_HEIGHT?: string;
    PERCENTAGE?: string;
    SLASHES?: string;
    PROGRESS_TOTAL?: number;
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
let progressStorage = new LocalStorage();
class ProgressCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.ACTION_TYPE = 'router';
        this.ABILITY_NAME = 'EntryAbility';
        this.FULL_WIDTH_PERCENT = '100%';
        this.FULL_HEIGHT_PERCENT = '100%';
        this.PROGRESS_LAYOUT_HEIGHT = '80%';
        this.RESULTS_LAYOUT_HEIGHT = '20%';
        this.PERCENTAGE = '%';
        this.SLASHES = '/';
        this.PROGRESS_TOTAL = 100;
        this.TEXT_SLIGHTLY_BOLD = 500;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ProgressCard_Params) {
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
        if (params.PROGRESS_LAYOUT_HEIGHT !== undefined) {
            this.PROGRESS_LAYOUT_HEIGHT = params.PROGRESS_LAYOUT_HEIGHT;
        }
        if (params.RESULTS_LAYOUT_HEIGHT !== undefined) {
            this.RESULTS_LAYOUT_HEIGHT = params.RESULTS_LAYOUT_HEIGHT;
        }
        if (params.PERCENTAGE !== undefined) {
            this.PERCENTAGE = params.PERCENTAGE;
        }
        if (params.SLASHES !== undefined) {
            this.SLASHES = params.SLASHES;
        }
        if (params.PROGRESS_TOTAL !== undefined) {
            this.PROGRESS_TOTAL = params.PROGRESS_TOTAL;
        }
        if (params.TEXT_SLIGHTLY_BOLD !== undefined) {
            this.TEXT_SLIGHTLY_BOLD = params.TEXT_SLIGHTLY_BOLD;
        }
    }
    updateStateVars(params: ProgressCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__numerator.purgeDependencyOnElmtId(rmElmtId);
        this.__denominator.purgeDependencyOnElmtId(rmElmtId);
        this.__percent.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__numerator.aboutToBeDeleted();
        this.__denominator.aboutToBeDeleted();
        this.__percent.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __numerator: ObservedPropertyAbstractPU<number> = this.createLocalStorageProp<number>('numerator', 0, "numerator");
    get numerator() {
        return this.__numerator.get();
    }
    set numerator(newValue: number) {
        this.__numerator.set(newValue);
    }
    private __denominator: ObservedPropertyAbstractPU<number> = this.createLocalStorageProp<number>('denominator', 0, "denominator");
    get denominator() {
        return this.__denominator.get();
    }
    set denominator(newValue: number) {
        this.__denominator.set(newValue);
    }
    private __percent: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('percent', '0', "percent");
    get percent() {
        return this.__percent.get();
    }
    set percent(newValue: string) {
        this.__percent.set(newValue);
    }
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
     * The progress layout height percentage setting.
     */
    readonly PROGRESS_LAYOUT_HEIGHT: string;
    /*
     * The finish results layout percentage setting.
     */
    readonly RESULTS_LAYOUT_HEIGHT: string;
    /*
     * The percent sign.
     */
    readonly PERCENTAGE: string;
    /*
     * The slashes splicing.
     */
    readonly SLASHES: string;
    /**
     * The progress total to 100.
     */
    readonly PROGRESS_TOTAL: number;
    /**
     * The text slightly bold.
     */
    readonly TEXT_SLIGHTLY_BOLD: number;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.backgroundColor({ "id": 16777284, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.width(this.FULL_WIDTH_PERCENT);
            Column.height(this.FULL_HEIGHT_PERCENT);
            Column.onClick(() => {
                postCardAction(this, {
                    'action': this.ACTION_TYPE,
                    'abilityName': this.ABILITY_NAME
                });
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.height(this.PROGRESS_LAYOUT_HEIGHT);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Progress.create({ value: 0, total: this.PROGRESS_TOTAL, type: ProgressType.Ring });
            Progress.value(Number.parseInt(this.percent));
            Progress.width({ "id": 16777342, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Progress.height({ "id": 16777342, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Progress.backgroundColor({ "id": 16777283, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Progress.style({ strokeWidth: { "id": 16777343, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
        }, Progress);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.justifyContent(FlexAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.percent);
            Text.fontSize({ "id": 16777341, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor(Color.Black);
            Text.fontWeight(FontWeight.Normal);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.PERCENTAGE);
            Text.fontSize({ "id": 16777340, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor(Color.Black);
            Text.fontWeight(this.TEXT_SLIGHTLY_BOLD);
            Text.margin({ top: { "id": 16777339, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        Row.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height(this.RESULTS_LAYOUT_HEIGHT);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.numerator.toString());
            Text.fontColor({ "id": 16777280, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777338, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.lineHeight({ "id": 16777337, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Normal);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.SLASHES + this.denominator);
            Text.fontColor({ "id": 16777271, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777335, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.lineHeight({ "id": 16777334, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Normal);
        }, Text);
        Text.pop();
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ProgressCard";
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadEtsCard(new ProgressCard(undefined, {}, progressStorage), "com.example.healthy_life/entry/ets/progress/pages/ProgressCard");
ViewStackProcessor.StopGetAccessRecording();
