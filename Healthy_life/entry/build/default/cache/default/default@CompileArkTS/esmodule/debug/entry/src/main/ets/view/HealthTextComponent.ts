if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HealthText_Params {
    title?: string;
    titleResource?: Resource;
    fontSize?: number | string | Resource;
    fontWeight?: number | FontWeight | string;
    fontColor?: ResourceColor;
    fontFamily?: string | Resource;
}
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
export default class HealthText extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__title = new SynchedPropertySimpleOneWayPU(params.title, this, "title");
        this.titleResource = { "id": 16777237, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        this.fontSize = { "id": 16777307, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        this.fontWeight = Const.FONT_WEIGHT_500;
        this.fontColor = { "id": 16777289, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        this.fontFamily = { "id": 16777224, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" };
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HealthText_Params) {
        if (params.title === undefined) {
            this.__title.set('');
        }
        if (params.titleResource !== undefined) {
            this.titleResource = params.titleResource;
        }
        if (params.fontSize !== undefined) {
            this.fontSize = params.fontSize;
        }
        if (params.fontWeight !== undefined) {
            this.fontWeight = params.fontWeight;
        }
        if (params.fontColor !== undefined) {
            this.fontColor = params.fontColor;
        }
        if (params.fontFamily !== undefined) {
            this.fontFamily = params.fontFamily;
        }
    }
    updateStateVars(params: HealthText_Params) {
        this.__title.reset(params.title);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__title.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__title.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __title: SynchedPropertySimpleOneWayPU<string>;
    get title() {
        return this.__title.get();
    }
    set title(newValue: string) {
        this.__title.set(newValue);
    }
    private titleResource: Resource;
    private fontSize: number | string | Resource;
    private fontWeight: number | FontWeight | string;
    private fontColor: ResourceColor;
    private fontFamily: string | Resource;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.title || this.titleResource);
            Text.fontSize(this.fontSize);
            Text.fontWeight(this.fontWeight);
            Text.fontColor(this.fontColor);
            Text.fontFamily(this.fontFamily);
        }, Text);
        Text.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
