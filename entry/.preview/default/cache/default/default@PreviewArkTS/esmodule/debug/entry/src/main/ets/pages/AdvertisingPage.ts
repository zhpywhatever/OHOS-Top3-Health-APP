if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AdvertisingPage_Params {
    duration?: number;
    intervalId?: number;
}
import router from "@ohos:router";
import { CommonConstants as Const } from "@bundle:com.example.healthy_life/entry/ets/common/constants/CommonConstants";
class AdvertisingPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__duration = new ObservedPropertySimplePU(Const.AD_DURATION, this, "duration");
        this.intervalId = -1;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AdvertisingPage_Params) {
        if (params.duration !== undefined) {
            this.duration = params.duration;
        }
        if (params.intervalId !== undefined) {
            this.intervalId = params.intervalId;
        }
    }
    updateStateVars(params: AdvertisingPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__duration.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__duration.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __duration: ObservedPropertySimplePU<number>;
    get duration() {
        return this.__duration.get();
    }
    set duration(newValue: number) {
        this.__duration.set(newValue);
    }
    private intervalId: number;
    goToHomePage() {
        clearInterval(this.intervalId);
        router.replaceUrl({ url: 'pages/MainPage' });
    }
    aboutToAppear() {
        this.intervalId = setInterval(() => {
            if (this.duration > 0) {
                this.duration -= 1;
            }
            else {
                this.goToHomePage();
            }
        }, Const.DURATION_1000);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(41:5)");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundImagePosition({ x: 0, y: 0 });
            Column.backgroundImage({ "id": 16777337, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Column.backgroundImageSize({ width: '100%', height: '100%' });
            Column.justifyContent(FlexAlign.SpaceBetween);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(42:7)");
            Row.width('90%');
            Row.justifyContent(FlexAlign.End);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777241, "type": 10003, params: [this.duration], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(43:9)");
            Text.fontSize({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor({ "id": 16777386, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.borderRadius({ "id": 16777296, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.letterSpacing(Const.LETTER_1);
            Text.height({ "id": 16777306, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.backgroundColor('rgba(0,0,0,0.20)');
            Text.border({ color: { "id": 16777386, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" }, width: { "id": 16777289, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
            Text.margin({ top: { "id": 16777306, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
            Text.padding({ "id": 16777321, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.onClick(() => this.goToHomePage());
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(58:7)");
            Row.height({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Row.width('100%');
            Row.justifyContent(FlexAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777276, "type": 20000, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(59:9)");
            Image.width({ "id": 16777314, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.height({ "id": 16777314, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: Const.SPACE_4 });
            Column.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(63:9)");
            Column.alignItems(HorizontalAlign.Start);
            Column.margin({ left: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" } });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(64:11)");
            Text.fontFamily({ "id": 16777224, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontSize({ "id": 16777302, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor({ "id": 16777385, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontWeight(Const.FONT_WEIGHT_700);
            Text.letterSpacing(Const.LETTER_1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777219, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/AdvertisingPage.ets(70:11)");
            Text.fontFamily({ "id": 16777223, "type": 10003, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontColor({ "id": 16777385, "type": 10001, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
            Text.fontWeight(Const.FONT_WEIGHT_400);
            Text.letterSpacing(Const.LETTER_34);
            Text.opacity(Const.OPACITY_4);
            Text.fontSize({ "id": 16777296, "type": 10002, params: [], "bundleName": "com.example.healthy_life", "moduleName": "entry" });
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "AdvertisingPage";
    }
}
registerNamedRoute(() => new AdvertisingPage(undefined, {}), "", { bundleName: "com.example.healthy_life", moduleName: "entry", pagePath: "pages/AdvertisingPage", pageFullPath: "entry/src/main/ets/pages/AdvertisingPage", integratedHsp: "false" });
